library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_sweeper is
end tb_sweeper;

architecture behavior of tb_sweeper is

    -- Declaração do Componente
    component sweeper
        generic (w : natural := 32);
        port(
            r_call_up       : in  std_logic_vector(w-1 downto 0);
            r_call_down     : in  std_logic_vector(w-1 downto 0);
            r_scan_priority : in  std_logic;
            next_floor      : out std_logic_vector(4 downto 0);
            next_dir        : out std_logic;
            call_detected   : out std_logic
        );
    end component;

    -- Configuração do genérico para teste (Ex: 32 andares)
    constant W_TEST : natural := 32;

    -- Sinais
    signal r_call_up       : std_logic_vector(W_TEST-1 downto 0) := (others => '0');
    signal r_call_down     : std_logic_vector(W_TEST-1 downto 0) := (others => '0');
    signal r_scan_priority : std_logic := '0';

    -- Saídas
    signal next_floor      : std_logic_vector(4 downto 0);
    signal next_dir        : std_logic;
    signal call_detected   : std_logic;

begin

    -- Instanciação (Mapeando genérico w para 32)
    uut: sweeper 
    generic map (
        w => W_TEST
    )
    port map (
        r_call_up       => r_call_up,
        r_call_down     => r_call_down,
        r_scan_priority => r_scan_priority,
        next_floor      => next_floor,
        next_dir        => next_dir,
        call_detected   => call_detected
    );

    -- Processo de Estímulo
    stim_proc: process
    begin
        -- wait inicial
        wait for 10 ns;

        -- CASO 1: Nenhuma chamada
        r_call_up   <= (others => '0');
        r_call_down <= (others => '0');
        wait for 10 ns;
        -- Esperado: call_detected = '0'

        -- CASO 2: Apenas subida (Andar 3 chama para subir)
        -- Prioridade = 0 (Check Up then Down)
        r_scan_priority <= '0';
        r_call_up(3)    <= '1'; 
        wait for 10 ns;
        -- Esperado: next_floor = 3, next_dir = 1 (subir)

        -- CASO 3: Apenas descida (Andar 8 chama para descer)
        r_call_up       <= (others => '0');
        r_call_down(8)  <= '1';
        wait for 10 ns;
        -- Esperado: next_floor = 8, next_dir = 0 (descer)

        -- CASO 4: Conflito - Subida no andar 2 e Descida no andar 9
        -- Prioridade = 0 (Prefere SUBIDA crescente)
        r_call_up(2)    <= '1';
        r_call_down(9)  <= '1';
        r_scan_priority <= '0';
        wait for 10 ns;
        -- Esperado: Deve escolher o andar 2 (Up) pois scan_priority é 0 (Up first)

        -- CASO 5: Mesmo cenário do Caso 4, mas mudando a Prioridade
        -- Prioridade = 1 (Prefere DESCIDA decrescente)
        r_scan_priority <= '1';
        wait for 10 ns;
        -- Esperado: Deve escolher o andar 9 (Down) pois scan_priority é 1 (Down first)

        -- CASO 6: Múltiplas chamadas na mesma direção
        -- Chamadas para subir nos andares 4 e 7. Prioridade '0'.
        r_call_up   <= (others => '0');
        r_call_down <= (others => '0');
        r_scan_priority <= '0';
        
        r_call_up(4) <= '1';
        r_call_up(7) <= '1';
        wait for 10 ns;
        -- Esperado: Deve pegar o menor índice (4) primeiro, pois o loop vai de 0 a w-1

        -- CASO 7: Múltiplas chamadas descendo
        -- Chamadas para descer nos andares 5 e 2. Prioridade '1'.
        r_scan_priority <= '1';
        r_call_down(5) <= '1';
        r_call_down(2) <= '1';
        wait for 10 ns;
        -- Esperado: Deve pegar o maior índice (5) primeiro, pois o loop vai de w-1 a 0

        wait;
    end process;

end behavior;