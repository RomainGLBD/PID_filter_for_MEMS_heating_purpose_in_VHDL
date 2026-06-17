----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.05.2026 11:15:27
-- Design Name: 
-- Module Name: Sum_filter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Sum_filter is
    Port ( proportional_input : in SIGNED (15 downto 0);
           integral_input : in SIGNED (15 downto 0);
           derivate_input : in SIGNED (15 downto 0);
           
           sum_output : out SIGNED (15 downto 0)
           );
end Sum_filter;

architecture Behavioral of Sum_filter is
    
    begin
    process(proportional_input, integral_input, derivate_input)
    begin
        if ( RESIZE(proportional_input, 22) + RESIZE(integral_input,22) + RESIZE(derivate_input,22) < TO_SIGNED(32767, 22)) then
            sum_output <= proportional_input + integral_input + derivate_input ;
        else
            sum_output <= TO_SIGNED( 32767, 16) ;
        end if;
    end process ;
end Behavioral;
