library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_cham_ext is
    port (
             clk   : in STD_LOGIC := '0';
             reset : in STD_LOGIC := '0';

             call_up    : in STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
             call_down  : in STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

             clear_command     : in STD_LOGIC := '0';
             clear_floor_up    : in STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
             clear_floor_down  : in STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

             r_call_up    : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
             r_call_down  : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0')
         );
end reg_cham_ext;

architecture behavioral of reg_cham_ext is
    signal s_reg_up    : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal s_reg_down  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if (reset = '1') then
            s_reg_up <= (others => '0');
            s_reg_down <= (others => '0');
        else if rising_edge(clk) then
            if (clear_command = '1') then
                s_reg_up   <= (s_reg_up OR call_up) AND NOT clear_floor_up;
                s_reg_down <= (s_reg_down OR call_down) AND NOT clear_floor_down;
            else
                s_reg_up   <= s_reg_up OR call_up;
                s_reg_down <= s_reg_down OR call_down;
            end if;    
        end if;
    end if;
end process;
    r_call_up   <= s_reg_up;
    r_call_down <= s_reg_down;

end behavioral;
