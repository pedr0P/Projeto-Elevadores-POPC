library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Testbenches não têm portas (Entity vazia), pois são autossuficientes
entity tb_RegistradorChamadas is
end tb_RegistradorChamadas;

architecture Simulação of tb_RegistradorChamadas is

    -- 1. DECLARAÇÃO DO COMPONENTE (Cópia exata da Entity do seu design)
    component RegistradorChamadas
        Port ( 
            clk              : in  STD_LOGIC;
            reset            : in  STD_LOGIC;
            call_up          : in  STD_LOGIC_VECTOR(31 downto 0);
            call_down        : in  STD_LOGIC_VECTOR(31 downto 0);
            clear_command    : in  STD_LOGIC;
            clear_floor_up   : in  STD_LOGIC_VECTOR(31 downto 0);
            clear_floor_down : in  STD_LOGIC_VECTOR(31 downto 0);
            r_call_up        : out STD_LOGIC_VECTOR(31 downto 0);
            r_call_down      : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    -- 2. SINAIS INTERNOS (Fios para conectar no componente)
    signal s_clk              : STD_LOGIC := '0';
    signal s_reset            : STD_LOGIC := '0';
    signal s_call_up          : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal s_call_down        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal s_clear_command    : STD_LOGIC := '0';
    signal s_clear_floor_up   : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal s_clear_floor_down : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    
    -- Saídas (observadas)
    signal s_r_call_up        : STD_LOGIC_VECTOR(31 downto 0);
    signal s_r_call_down      : STD_LOGIC_VECTOR(31 downto 0);

    -- Constante para definir a velocidade do clock (10ns = 100MHz)
    constant clk_period : time := 10 ns;

begin

    -- 3. INSTANCIAÇÃO (Conectar os fios virtuais ao componente real)
    UUT: RegistradorChamadas Port Map (
        clk              => s_clk,
        reset            => s_reset,
        call_up          => s_call_up,
        call_down        => s_call_down,
        clear_command    => s_clear_command,
        clear_floor_up   => s_clear_floor_up,
        clear_floor_down => s_clear_floor_down,
        r_call_up        => s_r_call_up,
        r_call_down      => s_r_call_down
    );

    -- 4. PROCESSO DO CLOCK (Gera a onda quadrada infinita)
    clock_process : process
    begin
        s_clk <= '0';
        wait for clk_period/2;
        s_clk <= '1';
        wait for clk_period/2;
    end process;

    -- 5. PROCESSO DE ESTIMULOS (O Roteiro de Teste)
    stim_proc: process
    begin		
        -- == PASSO 1: Reset Inicial ==
        report "Inicio da Simulacao: Resetando...";
        s_reset <= '1';
        wait for 20 ns; -- Espera 2 clocks
        s_reset <= '0';
        wait for clk_period;

        -- == PASSO 2: Chamada nos Andares 2 (Subir) e 5 (Descer) ==
        -- Nota: Bit 2 é o terceiro bit (0, 1, 2) = 3º Andar na prática, ou andar índice 2.
        report "Testando Entrada de Chamadas...";
        
        -- Configura os vetores (usando atribuição direta aos bits pra facilitar)
        s_call_up(2)   <= '1'; -- Chamada para subir no andar 2
        s_call_down(5) <= '1'; -- Chamada para descer no andar 5
        
        wait for clk_period; -- Espera um clock para registrar

        -- == PASSO 3: Soltar o botão (Latch) ==
        report "Soltando botoes (Teste de Memoria)...";
        s_call_up(2)   <= '0'; 
        s_call_down(5) <= '0';
        
        wait for clk_period;
        
        -- AQUI você deve verificar no gráfico: as saídas r_call_up(2) e r_call_down(5) 
        -- devem continuar em '1' mesmo com a entrada zerada.

        -- == PASSO 4: Limpar (Clear) apenas o andar 2 (Subir) ==
        report "Atendendo andar 2 (Clear)...";
        s_clear_command <= '1';       -- Habilita o comando de limpar
        s_clear_floor_up(2) <= '1';   -- Diz qual andar limpar
        
        wait for clk_period;
        
        -- Desativa o comando de clear
        s_clear_command <= '0';
        s_clear_floor_up(2) <= '0';
        
        wait for clk_period;
        
        -- AQUI: r_call_up(2) deve ter voltado para '0'.
        -- MAS r_call_down(5) deve continuar em '1' (não foi atendido ainda).

        -- == PASSO 5: Reset Final ==
        report "Reset Final...";
        s_reset <= '1';
        wait for 20 ns;
        
        -- Finaliza a simulação
        report "Fim do Teste.";
        wait; -- O 'wait' sozinho para o processo para sempre
    end process;

end Simulação;
