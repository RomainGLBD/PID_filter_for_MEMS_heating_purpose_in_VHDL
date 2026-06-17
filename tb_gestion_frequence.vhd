library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity gestion_frequence_tb is
end;

architecture bench of gestion_frequence_tb is

  component gestion_frequence
      Port ( clk : in STD_LOGIC;
             rst : in STD_LOGIC;
             enable_sampling : out STD_LOGIC ;
             enable_PID_calc : out STD_LOGIC
             ); 
  end component;

  signal clk: STD_LOGIC;
  signal rst: STD_LOGIC;
  signal enable_sampling: STD_LOGIC ;
  signal enable_PID_calc : STD_LOGIC ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: gestion_frequence port map ( clk       => clk,
                                    rst       => rst,
                                    enable_sampling => enable_sampling,
                                    enable_PID_calc => enable_PID_calc
                                     );

  stimulus: process
  begin

    -- Put initialisation code here

    rst <= '1', '0' after 200 ns ;
    -- Put test bench stimulus code here

    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;