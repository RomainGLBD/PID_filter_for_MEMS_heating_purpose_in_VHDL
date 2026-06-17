library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity P_filter is
    Port ( error : in SIGNED (15 downto 0);
           K_P : in STD_LOGIC_VECTOR (15 downto 0) ;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           enable : in STD_LOGIC;
           proportional_output : out SIGNED (15 downto 0 )
         );
           
end P_filter;

architecture Behavioral of P_filter is

signal proportional_calcul : SIGNED( 15 downto 0) ;

begin

process(clk, rst, error) 
    begin

    if ( rst = '1' ) then
        proportional_calcul <= TO_SIGNED( 0, 16) ;
    else
        if ( clk'EVENT AND clk = '1' ) then
            if enable = '1' then
                proportional_calcul <= SIGNED(RESIZE( UNSIGNED(K_P) * UNSIGNED(error), 16)) ;
            end if;
        end if;
    end if;
    
    proportional_output <= proportional_calcul ;
    
end process;

end Behavioral;