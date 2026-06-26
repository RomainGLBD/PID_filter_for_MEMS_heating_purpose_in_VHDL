# PID_filter_for_MEMS_heating_purpose_in_VHDL
The goal is to implement a PID control in VHDL using voltage for heating up/cooling down the internal resistor of a MEMS.
By maintaining a constant temperature, the MEMS frequency remains stable.

# Schematic (made on Vivado v2025.2) :
<img width="2069" height="640" alt="schematic version 17 juin" src="https://github.com/user-attachments/assets/e083345b-8056-4801-b3e8-1f9b0227af8f" />

# Moku implementation :
The first implementation is on Moku devices from Liquid Instruments : https://liquidinstruments.com/ .
You must manually import all required files from Vivado to Moku compile : https://compile.liquidinstruments.com/ .
Then you'll want to create a new top level file in order to match the Input/Output name of the device.
Below, the TOP_LEVEL I made for the project :

```vhdl
library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.Numeric_Std.all;

-- This is the Top Level architecture needed in order to use the Moku device.

architecture Behavioural of CustomInstrument is

begin
    Top: entity Work.Top_level
        port map (
          
----------------------- INPUT -----------------------
          clk               => Clk ,
          rst               => Control(15)(0) ,
          inputA            => InputA , -- MEMS voltage value
          inputB            => InputB , -- Multimeter value
          
          control0          => Control(0)(15 downto 0) , -- Voltage reference point (you must do the conversion from the table "______")
          control1          => Control(1)(15 downto 0) , -- Kp constant
          control2          => Control(2)(15 downto 0) , -- Ki constant
          control3          => Control(3)(15 downto 0) , -- Kd constant
          control4          => Control(4)(15 downto 0) , -- n_period (number of repetition of the PWM during one period ( Freq = 2^16 Hz))
          control5          => Control(5)(15 downto 0) , -- sampling time : the time (in 1/%) on which the system will enable power in the circuit 
                                                         -- in order to get a voltage value of the MEMS 
          control6          => Control(6)(23 downto 0) , -- System Frequency
----------------------- OUTPUT -----------------------

          control_signal    => OutputA ,    -- PWM Power output
          outputb               => OutputB , -- 
          
          status0           => Status(0) ,  -- feedback
          status1           => Status(1) ,  -- propo output
          status2           => Status(2) ,  -- integ output
          status3           => Status(3) ,  -- deriv output
          status4           => Status(4) ,  -- error
          status5           => Status(5) ,  -- MEMS voltage value
          status6           => Status(6) ,  -- Enable Sampling
          status7           => Status(7) ,  -- output logic PWM
          status8           => Status(8) ,  --
          status9           => Status(9) ,  -- Reference point
           
          status10          => Status(10),  -- Multimeter value
          status11          => Status(11)   -- PWM Power output
        );

end architecture;
```
# BreadBoard Implementation :
<img width="600" height="872" alt="BreadBoard 2026-06-18 + comments" src="https://github.com/user-attachments/assets/d37cae6a-ac8d-4187-92b1-43d346e09293" />
