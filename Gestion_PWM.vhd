library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- This module generate the signal Pulse Width Modulation (PWM) to apply the correction over the MEMS internal resistance.
-- Its outputs are the PWM logic & power supply (3.3V).

-- It also repetitivly output a signal & power sypply level (at 65 535 Hz) in order to get the voltage level of the MEMS resistance.

-- CAREFUL :
-- If the transistor use for switching is a PMOS you need to reverse the output logic for the alimentation control (0 <-> 3.3V).

entity Gestion_PWM is
    Port ( clk              : in   STD_LOGIC;
           rst              : in   STD_LOGIC;
           frequency        : in   STD_LOGIC_VECTOR(23 downto 0) ; -- System Frequency
           control_output   : in   STD_LOGIC ;
           alpha            : in   SIGNED (15 downto 0);
           n_periode        : in   UNSIGNED ( 2 downto 0); -- Allows to divide the period of the PWM in multiple tinier periods.
           sampling_time    : in   UNSIGNED(4 downto 0) ; -- Allows to reduce/increse the time it takes to get the voltage value each period, in 
                                                --order to be right with the analogic part of the circuit (switching time, traveling time etc.)
          -- If the traveling time of your signal require you to wait X second, and those X seconds representes 5% of the period,
          -- you put sampling_time = 1/(5%) = 20. So, on each period of the PWM, you'll have 5% of your signal always on to be able to get the
          -- voltage value each period.
           
           logic_output     : out  STD_LOGIC;
           alim_output      : out  STD_LOGIC_VECTOR(15 downto 0)
         );
end Gestion_PWM;

architecture Behavioral of Gestion_PWM is
-- It could have been better to use 2 processes.
  
        signal cpt : UNSIGNED(23 downto 0) ;

begin

        process(clk, rst, control_output)
        begin
            
            if rst = '1' then
                cpt <= TO_UNSIGNED(0, 24);
                logic_output <= '0' ;
                alim_output <= "0000000000000000" ;  -- "0101010001111010" ; -- 21626 -> 3.3 V IF PMOS Inverted logic because of PMOS control       
                
            elsif clk'event AND clk = '1' then
                if cpt > UNSIGNED(frequency)/n_periode then
                    cpt <= TO_UNSIGNED(0, 24);
                else
                    cpt <= cpt + 1 ;
                end if ;

                -- THE PART THAT FORCES THE ACQUISITION OF THE VALUE -- 
                if control_output = '1' then 
                    cpt <= UNSIGNED(frequency)/sampling_time;
                    logic_output <= '1' ;
                    alim_output <= "0101010001111010" ; -- "0000000000000000" ; -- IF PMOS Inverted logic because of PMOS control

                -- ELSE, THE STANDARD BEHAVIOUR --
                else 
                    if alpha < 0 then -- if the correction is negative, we cannot cool the resistance other than by turning off the power supply.
                        logic_output <= '0' ;
                        alim_output <= "0000000000000000" ; -- "0101010001111010" ; -- 3.3 V IF PMOS Inverted logic because of PMOS control                    
                    else 
                        if cpt < (UNSIGNED(alpha)*2)/n_periode then -- PWM logic level up
                            logic_output <= '1' ;
                            alim_output <= "0101010001111010" ; -- "0000000000000000" ; -- IF PMOS Inverted logic because of PMOS control
                        else                                        -- PWM logic level down
                            logic_output <= '0' ;
                            alim_output <= "0000000000000000" ; -- "0101010001111010" ; -- 3.3 V IF PMOS Inverted logic because of PMOS control 
                        
                        end if ;
                    end if;        
                end if;    
            end if;    
        end process;

end Behavioral;
