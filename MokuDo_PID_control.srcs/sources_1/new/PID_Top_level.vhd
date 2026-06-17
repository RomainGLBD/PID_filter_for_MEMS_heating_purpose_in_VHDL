library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.Numeric_Std.all;


architecture Behavioural of CustomInstrument is

  
begin
    Top: entity Work.Top_level
        port map (
            
          clk => Clk ,
          rst => Control(15)(0) ,
          inputA => InputA , -- valeur de température sortie de l'ADC 16 bits
          control0 => Control(0)(21 downto 0) , -- Point de référence de la température (valeur en tension)
          control1 => Control(1)(21 downto 0) , -- Kp
          control2 => Control(2)(21 downto 0) , -- Ki
          control3 => Control(3)(21 downto 0) , -- Kd

          control_signal => OutputA, -- Output 16 bits
          status0 => Status(0) , -- observation du feedback
          status1 => Status(1) , -- propo output
          status2 => Status(2) , -- integ output
          status3 => Status(3)  -- deriv output
           
        );



end architecture;
