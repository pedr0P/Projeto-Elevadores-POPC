library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_out_gen is
    end tb_out_gen;

architecture test of tb_out_gen is
    constant C_CLK_PERIOD  : time := 10 ns;
    component out_gen is
        port (
                 clk             : in STD_LOGIC := '0';
                 reset           : in STD_LOGIC := '0';

                 r_next_floor    : in STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
                 direction       : in STD_LOGIC := '0';
                 winner_elev     : in STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
                 enable_dispatch : in STD_LOGIC := '0';

                 solicit_floor_um   : out STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
                 solicit_floor_dois : out STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
                 solicit_floor_tres : out STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
                 solicit_direction  : out STD_LOGIC := '0'; 
                 solicit_enable     : out STD_LOGIC := '0'
             );   
    end component;
    
    -- Control Signals:
    signal s_clk : STD_LOGIC := '0';
    signal s_reset : STD_LOGIC := '0';

    -- Input Signals:
    signal s_r_next_floor : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal s_direction : STD_LOGIC := '0';
    signal s_winner_elev : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    signal s_enable_dispatch : STD_LOGIC := '0';

    -- Output Signals:
    signal s_solicit_floor_um : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal s_solicit_floor_dois : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal s_solicit_floor_tres : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal s_solicit_direction : STD_LOGIC := '0'; 
    signal s_solicit_enable : STD_LOGIC := '0';

    -- Domestic Signals for testing
    signal sim_finished : BOOLEAN := false;

begin
    -- Instantiation
    UUT: component out_gen
     port map(
        clk => s_clk,
        reset => s_reset,
        r_next_floor => s_r_next_floor,
        direction => s_direction,
        winner_elev => s_winner_elev,
        enable_dispatch => s_enable_dispatch,
        solicit_floor_um => s_solicit_floor_um,
        solicit_floor_dois => s_solicit_floor_dois,
        solicit_floor_tres => s_solicit_floor_tres,
        solicit_direction => s_solicit_direction,
        solicit_enable => s_solicit_enable
    );

    -- Clock Generation Process
    clk_gen_proc : process
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
    stim_proc : process is
    begin
        report "Iniciando simulacao do Componente: Out_gen (Output Generator).";
        
        -- Case 1: Elevator One ####################################
        report "Setting up signals for first case...";
        s_r_next_floor <= "00100";
        s_direction <= '1';
        s_winner_elev <= "01";
        report "Activating enable_dispatch!";
        s_enable_dispatch <= '1';

        wait for C_CLK_PERIOD;

        -- Case 2: Elevator Two ####################################
        report "Setting up signals for second case...";
        s_r_next_floor <= "01000";
        s_direction <= '0';
        s_winner_elev <= "10";
        report "Activating enable_dispatch!";
        s_enable_dispatch <= '1';

        wait for C_CLK_PERIOD;

        -- Case 3: Elevator Three ####################################
        report "Setting up signals for third case...";
        s_r_next_floor <= "00010";
        s_direction <= '1';
        s_winner_elev <= "11";
        report "Activating enable_dispatch!";
        s_enable_dispatch <= '1';

        wait for C_CLK_PERIOD;

        -- Case 5: Reset ####################################
        report "Resetting...";
        s_reset <= '1';

        report "Simulacao concluida.";

        sim_finished <= true; 
        wait;
    end process;

end test;
