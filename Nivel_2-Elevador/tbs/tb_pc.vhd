library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_pc is
    end tb_pc;

architecture test of tb_pc is
    constant C_CLK_PERIOD  : time := 10 ns;
    component pc is
        port (
                 signal clk   : in STD_LOGIC;
                 signal reset : in STD_LOGIC;

                 signal call_detected : in STD_LOGIC := '0';

                 signal ld_call : out STD_LOGIC := '0';
                 signal enable_dispatch : out STD_LOGIC := '0';
                 signal clear_call : out STD_LOGIC := '0'
             );   
    end component;

    -- Control signals:
    signal s_clk   : STD_LOGIC := '0';
    signal s_reset : STD_LOGIC := '0';

    -- Input Signals:
    signal s_call_detected : STD_LOGIC := '0';

    -- Output Signals:
    signal s_ld_call : STD_LOGIC := '0';
    signal s_enable_dispatch : STD_LOGIC := '0';
    signal s_clear_call : STD_LOGIC := '0';

    -- Domestic Signals for testing
    signal sim_finished : BOOLEAN := false;
begin

    -- Instantiation
    UUT: component pc
    port map(
                clk => s_clk,
                reset => s_reset,
                call_detected => s_call_detected,
                ld_call => s_ld_call,
                enable_dispatch => s_enable_dispatch,
                clear_call => s_clear_call
            );

    -- Clock Generation Process
    clk_gen_proc : process
    begin
        while not sim_finished loop 
            s_clk <= '0';
            wait for C_CLK_PERIOD / 2;
            s_clk <= '1';
            wait for C_CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Test:
    stim_proc : process is
    begin
        report "Iniciando simulacao do Componente: PC (Parte de Controle).";
        report "Ativando call_detected...";

        s_call_detected <= '1';

        report "Esperando resultados...";
        wait for C_CLK_PERIOD * 2;

        report "Simulacao concluida.";

        sim_finished <= true; 
        wait;
    end process;

end test;
