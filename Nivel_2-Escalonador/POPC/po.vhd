library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity po is
    generic (w : natural := 32);
    port (
             signal clk              : in STD_LOGIC := '0';
             signal reset            : in STD_LOGIC := '0';

             signal r_call_up        : in STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
             signal r_call_down      : in STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

             signal floor_sensor_1   : in STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
             signal floor_sensor_2   : in STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
             signal floor_sensor_3   : in STD_LOGIC_VECTOR(4 downto 0) := (others => '0');

             signal moving_1         : in STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
             signal moving_2         : in STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
             signal moving_3         : in STD_LOGIC_VECTOR(1 downto 0) := (others => '0');

             signal ld_call          : in STD_LOGIC := '0';
             signal enable_dispatch  : in STD_LOGIC := '0';
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
end po;

architecture rtl of po is
    component sweeper is
        generic (w : natural := 32);
        port (
                 -- 0r_call_up
                 r_call_up  : in STD_LOGIC_VECTOR(w-1 downto 0) := (others => '0');
                 -- 0r_call_down
                 r_call_down : in STD_LOGIC_VECTOR(w-1 downto 0) := (others => '0');

                 next_floor : out STD_LOGIC_VECTOR(4 downto 0) := (others => '0'); -- O andar a ser limpo
                 next_dir   : out STD_LOGIC := '0'; -- 0 para descer, 1 para subir
                 call_detected : out STD_LOGIC := '0'
             );
    end component;
    signal next_floor : STD_LOGIC_VECTOR(4 downto 0);
    signal next_dir   : STD_LOGIC;

    component target_register is
        port (
                 clk : in STD_LOGIC := '0';
                 reset : in STD_LOGIC := '0';
                 -- 0ld_call
                 ld_call : in STD_LOGIC := '0';

                 -- 0next_floor
                 next_floor : in STD_LOGIC_VECTOR(4 downto 0) := (others => '0'); -- O andar a ser limpo
                                                               -- 0next_dir
                 next_dir   : in STD_LOGIC := '0'; -- 0 para descer, 1 para subir

                 r_next_floor : out STD_LOGIC_VECTOR(4 downto 0) := (others => '0'); -- O andar a ser limpo
                 r_next_dir   : out STD_LOGIC := '0'
             );
    end component;
    signal r_next_floor : STD_LOGIC_VECTOR(4 downto 0); signal r_next_dir : STD_LOGIC;

    component custo_distancia is
        port (
                 -- 0r_next_floor
                 chamada_ativa : in std_logic_vector(4 downto 0)  := (others => '0');
                 -- 0floor_sensor_x
                 floor_sensor  : in std_logic_vector(4 downto 0)  := (others => '0');
                 distancia     : out std_logic_vector(4 downto 0) := (others => '0') 
             );
    end component;
    signal distancia_1 : std_logic_vector(4 downto 0) := (others => '0');
    signal distancia_2 : std_logic_vector(4 downto 0) := (others => '0');
    signal distancia_3 : std_logic_vector(4 downto 0) := (others => '0');

    component cost_calculator is
        port (
                 -- 0r_next_floor
                 signal call_floor : in STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
                 -- 0r_next_dir
                 signal direction : in STD_LOGIC := '0'; -- 1 para subir e 0 para descer
                                                         -- 0floor_sensor_x
                 signal floor_sensor : in STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
                 -- 0moving_x
                 signal moving : in STD_LOGIC_VECTOR(1 downto 0) := (others => '0'); -- 00 - parado, 10 - subindo, 01 - descendo

                 signal elevator_cost : out STD_LOGIC_VECTOR(1 downto 0) := (others => '0')   -- 00 (melhor), 01 (bom), 10 (ruim), 11 (inválido)
             );
    end component;
    signal elevator_cost_1 : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    signal elevator_cost_2 : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    signal elevator_cost_3 : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');

    component comparador_custo is
        port (
                 -- UMA ENTRADA PARA CADA ELEVADOR
                 -- 0distancia_1
                 distancia_0_in      : IN  STD_LOGIC_VECTOR(4 DOWNTO 0) := (others => '0');
                 -- 0distancia_2
                 distancia_1_in      : IN  STD_LOGIC_VECTOR(4 DOWNTO 0) := (others => '0');
                 -- 0distancia_3
                 distancia_2_in      : IN  STD_LOGIC_VECTOR(4 DOWNTO 0) := (others => '0');

                 -- 0elevator_cost_1
                 custo_elev_0_in : IN  STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');
                 -- 0elevator_cost_2
                 custo_elev_1_in : IN  STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');
                 -- 0elevator_cost_3
                 custo_elev_2_in : IN  STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');

                 -- SAÍDA: ÍNDICE DO ELEVADOR COM MENOR CUSTO
                 elevador_vencedor_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0') -- "00", "01" ou "10"
             );
    end component;
    signal elevador_vencedor_out : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');

    component out_gen is
        port ( 
                 clk             : in STD_LOGIC := '0';
                 reset           : in STD_LOGIC := '0';
        --
                 -- 0r_next_floor
                 r_next_floor    : in STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
                 -- 0r_next_dir
                 direction       : in STD_LOGIC := '0';

                 winner_elev     : in STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
                 enable_dispatch : in STD_LOGIC := '0';

                 -- 0solicit_floor_1
                 solicit_floor_um   : out STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
                 -- 0solicit_floor_2
                 solicit_floor_dois : out STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
                 -- 0solicit_floor_3
                 solicit_floor_tres : out STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
                 -- 0solicit_direction
                 solicit_direction  : out STD_LOGIC := '0'; 
                 -- 0solicit_enable
                 solicit_enable     : out STD_LOGIC := '0'
             );
    end component;

    component clear_dec is
        port ( 
                 -- 0r_next_floor
                 r_next_floor       : in STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
                 -- 0next_dir
                 r_next_dir         : in STD_LOGIC := '0';
                 -- 0clear_call
                 clear_call         : in STD_LOGIC := '0';

                 clear_command      : out STD_LOGIC := '0';
                 clear_floor_up     : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
                 clear_floor_down   : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0')
             );
    end component;
begin
    SWEEPER_BLOCK: sweeper
    generic map( w => w)
    port map(
                r_call_up => r_call_up,
                r_call_down => r_call_down,
                next_floor => next_floor,
                next_dir => next_dir,
                call_detected => call_detected
            );
    TARGET_REG_BLOCK: target_register
    port map(
                clk => clk,
                reset => reset,
                ld_call => ld_call,
                next_floor => next_floor,
                next_dir => next_dir,
                r_next_floor => r_next_floor,
                r_next_dir => r_next_dir
            );

    DIST_CALC_1: custo_distancia
    port map(
                chamada_ativa => r_next_floor,
                floor_sensor => floor_sensor_1,
                distancia => distancia_1
            );
    DIST_CALC_2: custo_distancia
    port map(
                chamada_ativa => r_next_floor,
                floor_sensor => floor_sensor_2,
                distancia => distancia_2
            );
    DIST_CALC_3: custo_distancia
    port map(
                chamada_ativa => r_next_floor,
                floor_sensor => floor_sensor_3,
                distancia => distancia_3
            );

    COST_CALC_1: cost_calculator
    port map(
                call_floor => r_next_floor,
                direction => r_next_dir,
                floor_sensor => floor_sensor_1,
                moving => moving_1,
                elevator_cost => elevator_cost_1
            );
    COST_CALC_2: cost_calculator
    port map(
                call_floor => r_next_floor,
                direction => r_next_dir,
                floor_sensor => floor_sensor_2,
                moving => moving_2,
                elevator_cost => elevator_cost_2
            );
    COST_CALC_3: cost_calculator
    port map(
                call_floor => r_next_floor,
                direction => r_next_dir,
                floor_sensor => floor_sensor_3,
                moving => moving_3,
                elevator_cost => elevator_cost_3
            );

    COMPARADOR_CUSTO_BLOCK: comparador_custo
    port map(
                distancia_0_in => distancia_1,
                distancia_1_in => distancia_2,
                distancia_2_in => distancia_3,
                custo_elev_0_in => elevator_cost_1,
                custo_elev_1_in => elevator_cost_2,
                custo_elev_2_in => elevator_cost_3,
                elevador_vencedor_out => elevador_vencedor_out
            );
    OUT_GEN_BLOCK: out_gen
    port map(
                clk => clk,
                reset => reset,
                r_next_floor => r_next_floor,
                direction => r_next_dir,
                winner_elev => elevador_vencedor_out,
                enable_dispatch => enable_dispatch,
                solicit_floor_um => solicit_floor_1,
                solicit_floor_dois => solicit_floor_2,
                solicit_floor_tres => solicit_floor_3,
                solicit_direction => solicit_dir,
                solicit_enable => solicit_enable
            );
    CLEAR_DEC_BLOCK: clear_dec
    port map(
                r_next_floor =>  r_next_floor,
                r_next_dir => r_next_dir,
                clear_call => clear_call,
                clear_command => clear_command,
                clear_floor_up => clear_floor_up,
                clear_floor_down => clear_floor_down
            );

    process(clk)
    begin
    end process;
end rtl;
