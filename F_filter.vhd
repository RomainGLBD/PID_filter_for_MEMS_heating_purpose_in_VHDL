library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity F_filter is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           enable : in STD_LOGIC;
           pid_input : in SIGNED (15 downto 0);
           filter_output : out SIGNED (15 downto 0));
end F_filter;

architecture Behavioral of F_filter is

type reg_array is array (0 to 7) of signed(15 downto 0);
signal REG : reg_array;
signal filter_calcul : SIGNED( 18 downto 0) ;
signal which_REG : UNSIGNED(2 downto 0) := "000";

begin

process(clk, rst)
    begin
        if (rst = '1') then
            which_REG <= "000";
        elsif (clk'EVENT AND clk='1') then
            if (enable = '1') then 
                if which_REG = "111" then
                    which_REG <= "001" ;            
                else
                    which_REG <= which_REG + 1 ;
                end if ;
            end if;
        end if;
    end process;

process(clk, rst) 
    begin

    if ( rst = '1' ) then
        filter_calcul <= TO_SIGNED( 0, 19) ;
        REG(0) <= TO_SIGNED( 0, 16) ;
        REG(1) <= TO_SIGNED( 0, 16) ;
        REG(2) <= TO_SIGNED( 0, 16) ;
        REG(3) <= TO_SIGNED( 0, 16) ;
        REG(4) <= TO_SIGNED( 0, 16) ;
        REG(5) <= TO_SIGNED( 0, 16) ;
        REG(6) <= TO_SIGNED( 0, 16) ;
        REG(7) <= TO_SIGNED( 0, 16) ;
        
    else
        if ( clk'EVENT AND clk = '1' ) then
            if enable = '1' then
                case which_REG is
                    when "000" =>
                        REG(0) <= (pid_input) ;
                        REG(1) <= (pid_input) ;
                        REG(2) <= (pid_input) ;
                        REG(3) <= (pid_input) ;
                        REG(4) <= (pid_input) ;
                        REG(5) <= (pid_input) ;
                        REG(6) <= (pid_input) ;
                        REG(7) <= (pid_input) ;
                        
                    when "001" =>
                        REG(0) <= (pid_input) ;
                        REG(1) <= (pid_input) ;
                        
                    when "010" =>
                        REG(2) <= (pid_input) ;
                                            
                    when "011" =>
                        REG(3) <= (pid_input) ;
                        
                    when "100" =>
                        REG(4) <= (pid_input) ;
                        
                    when "101" =>
                        REG(5) <= (pid_input) ;
                        
                    when "110" =>
                        REG(6) <= (pid_input) ;
                        
                    when "111" =>
                        REG(7) <= (pid_input) ;
                       
                    
                    when others =>
                end case ;
                
            else
                filter_calcul <= RESIZE((REG(0)),19) + RESIZE((REG(1)),19) +
                                 RESIZE((REG(2)),19) + RESIZE((REG(3)),19) +
                                 RESIZE((REG(4)),19) + RESIZE((REG(5)),19) +
                                 RESIZE((REG(6)),19) + RESIZE((REG(7)),19) 
                                 ;    
                
            end if;
        end if;
    end if;
end process;    
    
    filter_output <= filter_calcul(18 downto 3) ;


end Behavioral;
