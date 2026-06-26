library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- This module output the 2 signals needed to control the PID calcul & the sampling of the internal MEMS resistance voltage value.
-- The Frequency is  65 535 Hz.

entity gestion_frequence is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           sampling_time : in UNSIGNED(4 downto 0) ; -- Allows to change the acquisition time of the voltage value (ex : 5%  => 1/0.05 = 20) 
           frequency : in STD_LOGIC_VECTOR(23 downto 0) ; -- System Frequency
          
           enable_sampling : out STD_LOGIC ; -- Allows the sampling of the value
           enable_PID_calc : out STD_LOGIC   -- Allows the P, I and D calculus
           );
end gestion_frequence;


architecture Behavioral of gestion_frequence is

signal cpt_sampling : unsigned(23 downto 0) := to_unsigned(0,24);

begin

sampling: process (clk, rst)
    begin
        if (rst='1') then
            cpt_sampling <= to_unsigned(0,24);
        elsif clk='1' and clk'event then
            if cpt_sampling = UNSIGNED(frequency) then
                cpt_sampling <= TO_UNSIGNED( 0, 24) ;
            else
                cpt_sampling <= cpt_sampling + 1;
            end if;
        end if;
    end process sampling;
    
calcul_output: process (cpt_sampling)
    begin
        if cpt_sampling > UNSIGNED(frequency) - UNSIGNED(frequency)/sampling_time then
            enable_sampling <= '1';
            if cpt_sampling = UNSIGNED(frequency) - (UNSIGNED(frequency)/sampling_time)/2 then -- the center of the sampling signal (to be sure to get the right Voltage info
                enable_PID_calc <= '1' ;
            else 
                enable_PID_calc <= '0' ;
            end if ;
       else
          enable_sampling <= '0';
          enable_PID_calc <= '0'; 
       end if;
end process calcul_output;

end Behavioral;
