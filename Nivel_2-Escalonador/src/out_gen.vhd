library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity out_gen is
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
end out_gen;

architecture rtl of out_gen is
begin
    process(clk)
    begin
        if (reset = '1') then
            solicit_floor_um   <= (others => '0');
            solicit_floor_dois <= (others => '0');
            solicit_floor_tres <= (others => '0');
            solicit_direction  <= '0';
            solicit_enable     <= '0';
        else if (enable_dispatch = '1') then
            solicit_enable <= '1';
            solicit_direction <= direction;
            case (winner_elev) is
                when "00" =>
                    solicit_floor_um <= r_next_floor;
                when "01" =>
                    solicit_floor_dois <= r_next_floor;
                when "10" =>
                    solicit_floor_tres <= r_next_floor;
                when others =>
                    solicit_enable <= '0';
            end case;
        else
            solicit_floor_um   <= (others => '0');
            solicit_floor_dois <= (others => '0');
            solicit_floor_tres <= (others => '0');
            solicit_enable <= '0';
        end if;
    end if;
end process;
end rtl;
