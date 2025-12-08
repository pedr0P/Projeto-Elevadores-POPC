library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_nivel_2 is
    end tb_nivel_2;

architecture test of tb_nivel_2 is
    constant C_W          : natural := 32;
    constant C_CLK_PERIOD  : time := 1 ns;
    component nivel_2 is
        generic (w : natural := 32);
        port (
                 signal clk              : in STD_LOGIC;
                 signal reset            : in STD_LOGIC;

                 signal call_up        : in STD_LOGIC_VECTOR(31 downto 0);
                 signal call_down      : in STD_LOGIC_VECTOR(31 downto 0);

                 signal floor_sensor_1   : in STD_LOGIC_VECTOR(4 downto 0);
                 signal floor_sensor_2   : in STD_LOGIC_VECTOR(4 downto 0);
                 signal floor_sensor_3   : in STD_LOGIC_VECTOR(4 downto 0);

                 signal moving_1         : in STD_LOGIC_VECTOR(1 downto 0);
                 signal moving_2         : in STD_LOGIC_VECTOR(1 downto 0);
                 signal moving_3         : in STD_LOGIC_VECTOR(1 downto 0);

                 signal solicit_floor_1  : out STD_LOGIC_VECTOR(4 downto 0);
                 signal solicit_floor_2  : out STD_LOGIC_VECTOR(4 downto 0);
                 signal solicit_floor_3  : out STD_LOGIC_VECTOR(4 downto 0);
                 signal solicit_dir      : out STD_LOGIC;
                 signal solicit_enable   : out STD_LOGIC
             );
    end component;

    -- Control signals:
    signal s_clk   : STD_LOGIC := '0';
    signal s_reset : STD_LOGIC := '0';

    -- Input Signals:
    signal s_call_up   : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal s_call_down : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

    signal s_floor_sensor_1 : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal s_floor_sensor_2 : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal s_floor_sensor_3 : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');

    signal s_moving_1       : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    signal s_moving_2       : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    signal s_moving_3       : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');

    -- Output Signals:
    signal s_solicit_floor_1  : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal s_solicit_floor_2  : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal s_solicit_floor_3  : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal s_solicit_dir      : STD_LOGIC := '0';
    signal s_solicit_enable   : STD_LOGIC := '0';

    -- Domestic Signals for testing
    signal sim_finished : BOOLEAN := false;
begin

    -- Instantiation
    UUT: nivel_2
     generic map(w => C_W)
     port map(
        clk => s_clk,
        reset => s_reset,
        call_up => s_call_up,
        call_down => s_call_down,
        floor_sensor_1 => s_floor_sensor_1,
        floor_sensor_2 => s_floor_sensor_2,
        floor_sensor_3 => s_floor_sensor_3,
        moving_1 => s_moving_1,
        moving_2 => s_moving_2,
        moving_3 => s_moving_3,
        solicit_floor_1 => s_solicit_floor_1,
        solicit_floor_2 => s_solicit_floor_2,
        solicit_floor_3 => s_solicit_floor_3,
        solicit_dir => s_solicit_dir,
        solicit_enable => s_solicit_enable
    );

    -- Clock Generation Process
    CLK_GEN : process
    begin
        while not sim_finished loop 
            s_clk <= '1';
            wait for C_CLK_PERIOD / 2;
            s_clk <= '0';
            wait for C_CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Test:
    STIM_PROC : process is
    begin
        wait for C_CLK_PERIOD * 2;
        report "Iniciando simulacao do Nivel 2";

        report "Test Case 1:";
        s_call_up(10) <= '1';
        s_floor_sensor_1 <= STD_LOGIC_VECTOR(TO_UNSIGNED(0, 5));
        s_floor_sensor_2 <= STD_LOGIC_VECTOR(TO_UNSIGNED(0, 5));
        s_floor_sensor_3 <= STD_LOGIC_VECTOR(TO_UNSIGNED(7, 5));

        wait for C_CLK_PERIOD * 1;
        s_call_up <= (others => '0');

        report "Esperando resultados...";
        wait for C_CLK_PERIOD * 2;

        report "Test Case 2:";
        s_call_up(1) <= '1';
        s_call_up(17) <= '1';
        s_floor_sensor_1 <= STD_LOGIC_VECTOR(TO_UNSIGNED(1, 5));
        s_floor_sensor_2 <= STD_LOGIC_VECTOR(TO_UNSIGNED(15, 5));
        s_floor_sensor_3 <= STD_LOGIC_VECTOR(TO_UNSIGNED(31, 5));
        wait for C_CLK_PERIOD * 1;
        s_call_up <= (others => '0');

        report "Esperando resultados...";
        wait for C_CLK_PERIOD * 4;

        report "Test Case 3:";
        s_call_up(26) <= '1';
        s_call_down(9) <= '1';
        s_floor_sensor_1 <= STD_LOGIC_VECTOR(TO_UNSIGNED(10, 5));
        s_floor_sensor_2 <= STD_LOGIC_VECTOR(TO_UNSIGNED(0, 5));
        s_floor_sensor_3 <= STD_LOGIC_VECTOR(TO_UNSIGNED(31, 5));
        wait for C_CLK_PERIOD * 1;
        s_call_up <= (others => '0');

        report "Esperando resultados...";
        wait for C_CLK_PERIOD * 6;

        report "Simulacao concluida.";

        sim_finished <= true; 
        wait;
    end process;

end test;
