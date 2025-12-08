library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nivel_2 is
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
end nivel_2;

architecture rtl of nivel_2 is
    component pc is
        port (
                 clk        : in STD_LOGIC := '0';
                 reset        : in STD_LOGIC := '0';

                 call_detected   : in STD_LOGIC := '0';

                 ld_call : out STD_LOGIC := '0';
                 enable_dispatch  : out STD_LOGIC := '0';
                 clear_call  : out STD_LOGIC := '0'
             );
    end component;
    signal s_ld_call          : STD_LOGIC;
    signal s_enable_dispatch  : STD_LOGIC;
    signal s_clear_call       : STD_LOGIC;

    component po is
        generic (w : natural := 32);
        port (
                 signal clk              : in STD_LOGIC := '0';
                 signal reset            : in STD_LOGIC := '0';

                 signal r_call_up        : in STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
                 signal r_call_down      : in STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

                 -- 0floor_sensor_1
                 signal floor_sensor_1   : in STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
                 -- 0floor_sensor_2
                 signal floor_sensor_2   : in STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
                 -- 0floor_sensor_3
                 signal floor_sensor_3   : in STD_LOGIC_VECTOR(4 downto 0) := (others => '0');

                 -- 0moving_1
                 signal moving_1         : in STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
                 -- 0moving_2
                 signal moving_2         : in STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
                 -- 0moving_3
                 signal moving_3         : in STD_LOGIC_VECTOR(1 downto 0) := (others => '0');

                 -- 0ld_call
                 signal ld_call          : in STD_LOGIC := '0';
                 -- 0enable_dispatch
                 signal enable_dispatch  : in STD_LOGIC := '0';
                 -- 0clear_call
                 signal clear_call       : in STD_LOGIC := '0';

                 signal solicit_floor_1  : out STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
                 signal solicit_floor_2  : out STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
                 signal solicit_floor_3  : out STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
                 signal solicit_dir      : out STD_LOGIC := '0';
                 signal solicit_enable   : out STD_LOGIC := '0';

                 signal clear_command    : out STD_LOGIC := '0';
                 signal clear_floor_up   : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
                 signal clear_floor_down : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

                 signal call_detected   : out STD_LOGIC := '0'
             );
    end component;
    signal s_call_detected    : STD_LOGIC;

    signal clear_command    : STD_LOGIC;
    signal clear_floor_up   : STD_LOGIC_VECTOR(31 downto 0);
    signal clear_floor_down : STD_LOGIC_VECTOR(31 downto 0);

    component reg_cham_ext is
        port (
                 clk   : in STD_LOGIC := '0';
                 reset : in STD_LOGIC := '0';

                 -- 0call_up
                 call_up    : in STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
                 -- 0call_down
                 call_down  : in STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

                 -- 0clear_command
                 clear_command     : in STD_LOGIC := '0';
                 -- 0clear_floor_up
                 clear_floor_up    : in STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
                 -- 0clear_floor_down
                 clear_floor_down  : in STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

                 r_call_up    : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
                 r_call_down  : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0')
             );
    end component;
    signal r_call_up    : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal r_call_down  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
begin
    PC_BLOCK: pc
     port map(
        clk => clk,
        reset => reset,
        call_detected => s_call_detected,
        ld_call => s_ld_call,
        enable_dispatch => s_enable_dispatch,
        clear_call => s_clear_call
    );
    PO_BLOCK: po
     generic map(w => w)
     port map(
        clk => clk,
        reset => reset,
        r_call_up => r_call_up,
        r_call_down => r_call_down,
        floor_sensor_1 => floor_sensor_1,
        floor_sensor_2 => floor_sensor_2,
        floor_sensor_3 => floor_sensor_3,
        moving_1 => moving_1,
        moving_2 => moving_2,
        moving_3 => moving_3,
        ld_call => s_ld_call,
        enable_dispatch => s_enable_dispatch,
        clear_call => s_clear_call,
        solicit_floor_1 => solicit_floor_1,
        solicit_floor_2 => solicit_floor_2,
        solicit_floor_3 => solicit_floor_3,
        solicit_dir => solicit_dir,
        solicit_enable => solicit_enable,
        clear_command => clear_command,
        clear_floor_up => clear_floor_up,
        clear_floor_down => clear_floor_down,
        call_detected => s_call_detected
    );
    EXT_CALL_REG: reg_cham_ext
     port map(
        clk => clk,
        reset => reset,
        call_up => call_up,
        call_down => call_down,
        clear_command => clear_command,
        clear_floor_up => clear_floor_up,
        clear_floor_down => clear_floor_down,
        r_call_up => r_call_up,
        r_call_down => r_call_down
    );

    process(clk)
    begin
    end process;
end rtl;
