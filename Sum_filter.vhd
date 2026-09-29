library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Sum_filter is
    generic ( 
        REGISTER_LENGTH : integer := 32 
    );
    Port ( 
           proportional_input : in SIGNED (REGISTER_LENGTH-1 downto 0);
           integral_input : in SIGNED (REGISTER_LENGTH-1 downto 0);
           derivate_input : in SIGNED (REGISTER_LENGTH-1 downto 0);
           
           sum_output : out SIGNED (15 downto 0)
           );
end Sum_filter;

architecture Behavioral of Sum_filter is
    
    signal sum : SIGNED(REGISTER_LENGTH-1 downto 0) ;
    begin
    
    sum <= SHIFT_RIGHT(proportional_input + integral_input + derivate_input, 7) ;
        
    process(proportional_input, integral_input, derivate_input)
    begin
   
        if sum > TO_SIGNED(32767, REGISTER_LENGTH) then
            sum_output <= TO_SIGNED( 32767, 16) ;
        elsif sum < TO_SIGNED(800, REGISTER_LENGTH) then
            sum_output <= TO_SIGNED( 800, 16) ;
        else       
            sum_output <= RESIZE(sum, 16) ;
        end if;
    end process ;
end Behavioral;
