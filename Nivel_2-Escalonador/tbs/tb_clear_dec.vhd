library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_clear_dec is
    end tb_clear_dec;

architecture test of tb_clear_dec is
    constant WAIT_TIME  : time := 10 ns;
    component clear_dec is
        port ( 
                 r_next_floor       : in STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
                 r_next_dir         : in STD_LOGIC := '0';
                 clear_call         : in STD_LOGIC := '0';

                 clear_command      : out STD_LOGIC := '0';
                 clear_floor_up     : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
                 clear_floor_down   : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0')
             );
    end component;

    -- Input Signals:
    signal s_r_next_floor   : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal s_r_next_dir     : STD_LOGIC := '0';
    signal s_clear_call     : STD_LOGIC := '0';

    -- Output Signals:
    signal clear_command    : STD_LOGIC := '0';
    signal clear_floor_up   : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal clear_floor_down : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

begin
    -- Instantiation
    UUT: component clear_dec
    port map(
                r_next_floor => s_r_next_floor,
                r_next_dir => s_r_next_dir,
                clear_call => s_clear_call,
                clear_command => clear_command,
                clear_floor_up => clear_floor_up,
                clear_floor_down => clear_floor_down
            );
    stim_proc : process is
    begin
        report "Iniciando simulacao do Componente: Clear_dec (Clear Decoder).";

        -- Case 1: Clear 'up' calls in the register ####################################
        report "Setting up signals for first case...";
        s_r_next_floor <= "00100";
        s_r_next_dir <= '1';
        report "Activating clear_call!";
        s_clear_call <= '1';

        wait for WAIT_TIME;

        report "Clearing last test case's signal...";
        s_r_next_floor <= (others => '0');

        -- Case 2: Clear 'down' calls in the register ####################################
        report "Setting up signals for first case...";
        s_r_next_floor <= "01111";
        s_r_next_dir <= '0';
        report "Activating clear_call!";
        s_clear_call <= '1';

        wait for WAIT_TIME;

        wait;
    end process;

end test;
