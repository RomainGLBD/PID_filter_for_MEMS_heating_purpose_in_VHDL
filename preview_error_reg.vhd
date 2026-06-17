library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity previous_error_reg is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           error : in SIGNED (21 downto 0);
           previous_error : out SIGNED (21 downto 0));
end previous_error_reg;

architecture Behavioral of previous_error_reg is

signal error_reg : SIGNED ( 21 downto 0) ;

begin
process(rst, clk, error)
    begin
    if ( rst = '1' ) then
        error_reg <= TO_SIGNED( 0, 22) ;
    else
        if ( clk'EVENT AND clk = '1' ) then
            error_reg <= error ;
        end if;
    end if;
    
    previous_error <= error_reg ;

    end process ;

end Behavioral;
