library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clear_dec is
    port ( 
             r_next_floor       : in STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
             r_next_dir         : in STD_LOGIC := '0';
             clear_call         : in STD_LOGIC := '0';

             clear_command      : out STD_LOGIC := '0';
             clear_floor_up     : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
             clear_floor_down   : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0')
         );
end clear_dec;

architecture rtl of clear_dec is
begin
    process(r_next_floor, r_next_dir, clear_call)
    begin
        if (clear_call = '1') then
            if (r_next_dir = '1') then
                clear_command <= '1';
                clear_floor_up <= (others => '0');
                clear_floor_up(TO_INTEGER(UNSIGNED(r_next_floor))) <= '1';
                clear_floor_down <= (others => '0');
            else
                clear_command <= '1';
                clear_floor_up <= (others => '0');
                clear_floor_down <= (others => '0');
                clear_floor_down(TO_INTEGER(UNSIGNED(r_next_floor))) <= '1';
            end if;
        else 
            clear_command <= '0';
        end if;
    end process;
end rtl;
