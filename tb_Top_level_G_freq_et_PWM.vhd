--library IEEE;
--use IEEE.Std_logic_1164.all;
--use IEEE.Numeric_Std.all;

--entity Top_Level_G_freq_et_PWM_tb is
--end;

--architecture bench of Top_Level_G_freq_et_PWM_tb is

--  component Top_Level_G_freq_et_PWM
--      Port (
--          clk                 : in  STD_LOGIC;
--          rst                 : in  STD_LOGIC;
--          alpha               : in  STD_LOGIC_VECTOR(15 downto 0);
--          output_front_enable : out STD_LOGIC
--      );
--  end component;

--  signal clk: STD_LOGIC;
--  signal rst: STD_LOGIC;
--  signal alpha: STD_LOGIC_VECTOR(15 downto 0);
--  signal output_front_enable: STD_LOGIC ;

--  constant clock_period: time := 10 ns;
--  signal stop_the_clock: boolean;

--begin

--  uut: Top_Level_G_freq_et_PWM port map ( clk                 => clk,
--                            rst                 => rst,
--                            alpha               => alpha,
--                            output_front_enable => output_front_enable );

--  stimulus: process
--  begin
---- 32268 = 50%   |  13107 = 20 %
--rst <= '1', '0' after 200 ns ;
--alpha <= STD_LOGIC_VECTOR(TO_UNSIGNED( 13107, 16)), STD_LOGIC_VECTOR(TO_UNSIGNED( 0, 16)) after 1000000 ns,
--        STD_LOGIC_VECTOR(TO_UNSIGNED( 65535, 16)) after 2000000 ns ;

--    wait;
--  end process;

--  clocking: process
--  begin
--    while not stop_the_clock loop
--      clk <= '0', '1' after clock_period / 2;
--      wait for clock_period;
--    end loop;
--    wait;
--  end process;

--end;
  