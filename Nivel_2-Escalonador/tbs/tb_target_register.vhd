library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_target_register is
end tb_target_register;

architecture behavior of tb_target_register is

    -- Declaração do Componente (Unit Under Test - UUT)
    component target_register
    port(
        clk          : in  std_logic := '0';
        reset        : in  std_logic := '0';
        ld_call      : in  std_logic := '0';
        next_floor   : in  std_logic_vector(4 downto 0) := (others => '0');
        next_dir     : in  std_logic := '0';
        
        r_next_floor : out std_logic_vector(4 downto 0) := (others => '0');
        r_next_dir   : out std_logic := '0'
    );
    end component;

    -- Sinais para conectar ao UUT
    signal clk          : std_logic := '0';
    signal reset        : std_logic := '0';
    signal ld_call      : std_logic := '0';
    signal next_floor   : std_logic_vector(4 downto 0) := (others => '0');
    signal next_dir     : std_logic := '0';

    -- Saídas
    signal r_next_floor : std_logic_vector(4 downto 0);
    signal r_next_dir   : std_logic;

    -- Definição do período do clock
    constant clk_period : time := 10 ns;

    signal sim_finished : BOOLEAN := false;
begin

    -- Instanciação do UUT
    uut: target_register port map (
        clk          => clk,
        reset        => reset,
        ld_call      => ld_call,
        next_floor   => next_floor,
        next_dir     => next_dir,
        r_next_floor => r_next_floor,
        r_next_dir   => r_next_dir
    );

    -- Processo de geração de Clock
    clk_gen_proc : process
    begin
        while not sim_finished loop 
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Processo de Estímulo
    stim_proc: process
    begin
        -- 1. Reset inicial
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 10 ns;

        -- 2. Tentar escrever SEM habilitar ld_call (Esperado: Saída mantém 0)
        next_floor <= "00101"; -- Andar 5
        next_dir   <= '1';     -- Subir
        ld_call    <= '0';
        wait for clk_period;

        -- 3. Habilitar ld_call para escrever (Esperado: Saída atualiza para Andar 5, Dir 1)
        ld_call <= '1';
        wait for clk_period; -- Aguarda borda de subida

        -- 4. Desabilitar ld_call e mudar entrada (Esperado: Saída mantém Andar 5, ignora nova entrada)
        ld_call    <= '0';
        next_floor <= "10000"; -- Andar 16
        next_dir   <= '0';     -- Descer
        wait for clk_period;

        -- 5. Escrever novo valor
        ld_call    <= '1';
        wait for clk_period; -- Agora deve atualizar para Andar 16

        -- 6. Testar Reset durante operação (Esperado: Saída zera imediatamente)
        wait for 5 ns; -- No meio do ciclo
        reset <= '1';
        wait for 10 ns;
        reset <= '0';

        sim_finished <= true;
        wait;
    end process;

end behavior;
