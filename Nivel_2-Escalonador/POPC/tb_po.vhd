library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_po is
    end tb_po;

architecture test of tb_po is
    constant C_W          : natural := 32;
    constant C_CLK_PERIOD : time := 10 ns;

    component po is
        generic (w : natural := 32);
        port (
                 clk             : in STD_LOGIC;
                 reset           : in STD_LOGIC;

                 r_call_up       : in STD_LOGIC_VECTOR(31 downto 0);
                 r_call_down     : in STD_LOGIC_VECTOR(31 downto 0);

                 floor_sensor_1  : in STD_LOGIC_VECTOR(4 downto 0);
                 floor_sensor_2  : in STD_LOGIC_VECTOR(4 downto 0);
                 floor_sensor_3  : in STD_LOGIC_VECTOR(4 downto 0);

                 moving_1        : in STD_LOGIC_VECTOR(1 downto 0);
                 moving_2        : in STD_LOGIC_VECTOR(1 downto 0);
                 moving_3        : in STD_LOGIC_VECTOR(1 downto 0);

                 ld_call         : in STD_LOGIC;
                 enable_dispatch : in STD_LOGIC;
                 clear_call      : in STD_LOGIC;

                 solicit_floor_1 : out STD_LOGIC_VECTOR(4 downto 0);
                 solicit_floor_2 : out STD_LOGIC_VECTOR(4 downto 0);
                 solicit_floor_3 : out STD_LOGIC_VECTOR(4 downto 0);
                 solicit_dir     : out STD_LOGIC;
                 solicit_enable  : out STD_LOGIC;

                 clear_command    : out STD_LOGIC;
                 clear_floor_up   : out STD_LOGIC_VECTOR(31 downto 0);
                 clear_floor_down : out STD_LOGIC_VECTOR(31 downto 0);

                 call_detected   : out STD_LOGIC
             );
    end component;

    -- Control signals:
    signal s_clk          : STD_LOGIC := '0';
    signal s_reset        : STD_LOGIC := '0';

    -- Input Signals:
    signal s_r_call_up    : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal s_r_call_down  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

    signal s_floor_sensor_1 : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal s_floor_sensor_2 : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal s_floor_sensor_3 : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');

    signal s_moving_1       : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    signal s_moving_2       : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    signal s_moving_3       : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');

    signal s_ld_call         : STD_LOGIC := '0';
    signal s_enable_dispatch : STD_LOGIC := '0';
    signal s_clear_call      : STD_LOGIC := '0';

    -- Output Signals:
    signal s_solicit_floor_1 : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal s_solicit_floor_2 : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal s_solicit_floor_3 : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal s_solicit_dir     : STD_LOGIC := '0';
    signal s_solicit_enable  : STD_LOGIC := '0';
    signal s_call_detected   : STD_LOGIC := '0';

    -- Domestic Signals for testing
    signal sim_finished : BOOLEAN := false;
begin

    -- Instantiation
    UUT: po
     generic map( w => C_W)
     port map(
        clk => s_clk,
        reset => s_reset,
        r_call_up => s_r_call_up,
        r_call_down => s_r_call_down,
        floor_sensor_1 => s_floor_sensor_1,
        floor_sensor_2 => s_floor_sensor_2,
        floor_sensor_3 => s_floor_sensor_3,
        moving_1 => s_moving_1,
        moving_2 => s_moving_2,
        moving_3 => s_moving_3,
        ld_call => s_ld_call,
        enable_dispatch => s_enable_dispatch,
        clear_call => s_clear_call,
        solicit_floor_1 => s_solicit_floor_1,
        solicit_floor_2 => s_solicit_floor_2,
        solicit_floor_3 => s_solicit_floor_3,
        solicit_dir => s_solicit_dir,
        solicit_enable => s_solicit_enable,
        call_detected => s_call_detected
    );

    -- Clock Generation Process
    CLK_GEN : process
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
    STIM_PROC : process is
    begin
        report "Iniciando simulacao do Componente: PO (Parte Operacional).";
        s_r_call_up(10) <= '1';
        s_floor_sensor_1 <= STD_LOGIC_VECTOR(TO_UNSIGNED(0, 5));
        s_floor_sensor_2 <= STD_LOGIC_VECTOR(TO_UNSIGNED(0, 5));
        s_floor_sensor_3 <= STD_LOGIC_VECTOR(TO_UNSIGNED(7, 5));

        report "Esperando resultados...";
        s_ld_call <= '1';

        report "Esperando resultados...";
        wait for C_CLK_PERIOD;

        s_enable_dispatch <= '1';
        s_clear_call <= '1';

        report "Simulacao concluida.";

        sim_finished <= true; 
        wait;
    end process;

end test;
