library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity target_register is
    port (
        signal clk : in STD_LOGIC := '0';
        signal reset : in STD_LOGIC := '0';
        signal ld_call : in STD_LOGIC := '0';

        signal next_floor : in STD_LOGIC_VECTOR(4 downto 0) := (others => '0'); -- O andar a ser limpo
        signal next_dir   : in STD_LOGIC := '0'; -- 0 para descer, 1 para subir
        
        signal r_next_floor : out STD_LOGIC_VECTOR(4 downto 0) := (others => '0'); -- O andar a ser limpo
        signal r_next_dir   : out STD_LOGIC := '0'
    );
end target_register;

architecture comportamental of target_register is
begin

    process(clk, reset)
    begin
        
        if reset = '1' then
            r_next_floor    <= (others => '0');
            r_next_dir      <= '0';

        elsif rising_edge(clk) then

            if ld_call = '1' then
                r_next_floor    <= next_floor;
                r_next_dir      <= next_dir;

            end if;
            
        end if;
        
    end process;

end comportamental;
