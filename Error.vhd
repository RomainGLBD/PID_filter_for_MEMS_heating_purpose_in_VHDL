library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Error is
    Port ( feedback : in SIGNED (15 downto 0);
           setpoint : in STD_LOGIC_VECTOR (15 downto 0);
           enable : in STD_LOGIC ;
           error : out SIGNED (15 downto 0)
         );
end Error;

architecture Behavioral of Error is

signal reg : SIGNED( 15 downto 0) := "0000000000000000";
  
begin
-- We shift the value in order to simulate a multiplication < 1
-- when the value is multiply by Kp, Ki, and Kd.
-- Ex : In reality, value is       32   | Kp is   2

--    If shift = 2, value is       8    | Kp is   2       (because >> 2 means /4)
--    This is equal to having      32   | Kp is   0.5  
    process (enable)
    begin 
        if enable = '1' then
            error <= SHIFT_RIGHT( RESIZE( SIGNED(setpoint) - feedback, 16), 4) ; -- Here the shift is 4, so Kp,i,d are /16
            reg <=   SHIFT_RIGHT( RESIZE( SIGNED(setpoint) - feedback, 16), 4) ;
      else                                                                     
            error <= reg ;
        end if;
    end process ;
end Behavioral;