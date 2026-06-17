library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity D_filter is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           enable : in STD_LOGIC;
           K_D : STD_LOGIC_VECTOR ( 15 downto 0);
           error : in SIGNED (15 downto 0);
           derivate_output : out SIGNED (15 downto 0));
end D_filter;


architecture Behavioral of D_filter is

signal derivate_calcul : SIGNED( 15 downto 0) ;
signal previous_error : SIGNED (15 downto 0);

begin



process(clk, rst) 
    begin

    if ( rst = '1' OR UNSIGNED(K_D) = 0) then
        derivate_calcul <= TO_SIGNED( 0, 16) ;
        previous_error <= TO_SIGNED( 0, 16) ;
    else
        if ( clk'EVENT AND clk = '1' ) then
            if enable = '1' then
                derivate_calcul <= RESIZE( SIGNED(K_D) * (error - previous_error), 16) ;
                previous_error <= error ;
            end if;
        end if;
    end if;
    
    derivate_output <= derivate_calcul ;

end process;
    
end Behavioral;
