library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Error is
generic ( 
        RESISTANCE_VALUE : integer := 32 ;
        REGISTER_LENGTH : integer := 32 
        );

    Port ( 
           clk : in STD_LOGIC ;
           rst : in STD_LOGIC ;
          -- enable : in STD_LOGIC;
           feedback : in UNSIGNED (REGISTER_LENGTH-1 downto 0);
           setpoint : in UNSIGNED (REGISTER_LENGTH-1 downto 0);
           res_value : in UNSIGNED(RESISTANCE_VALUE-1 downto 0);
           previous_control : in UNSIGNED(REGISTER_LENGTH-1 downto 0); -- Now it is just the Power supply on the MEMS used for getting the current.
           output_error : out SIGNED (REGISTER_LENGTH-1 downto 0);
           
           res_div : out STD_LOGIC_VECTOR(31 downto 0) ;
          val : in STD_LOGIC
          
           
         );
end Error;



architecture Behavioral of Error is

signal res_mult : UNSIGNED( res_value'length + feedback'length-1 downto 0);
signal res_soust : UNSIGNED( res_value'length + feedback'length-1 downto 0);
signal quotient : STD_LOGIC_VECTOR( res_value'length + feedback'length-1 downto 0);

-- signal res_delay : SIGNED(RESISTANCE_VALUE-1 downto 0);

begin

    B_divider : entity work.divider
    
    GENERIC MAP (
        DATA_SIZE => res_value'length + feedback'length 
    )
    
    PORT MAP ( 
        rst         => rst, 
        clk         => clk,
        start       => val,--'1', 
        dividend    => STD_LOGIC_VECTOR(res_mult),
        divider     => STD_LOGIC_VECTOR(res_soust),
        quotient    => quotient
    );


process(clk, rst)
begin 
    if clk'event AND clk = '1' then
        if rst = '1' then
            res_mult    <= (others => '0');
            res_soust   <= (others => '0');
            
        else
        --    if (enable = '1' ) then
                res_mult <= feedback*res_value ;
                res_soust <= RESIZE(previous_control - feedback, res_value'length + feedback'length)  ;

              --  res_delay <= RESIZE(SIGNED(setpoint) - SIGNED(quotient), REGISTER_LENGTH) ; 
       --     end if;
       end if ;
    end if;
    
end process;
    output_error <= RESIZE(SIGNED(setpoint) - SIGNED(quotient), REGISTER_LENGTH) ; -- res_delay ;
    res_div <= quotient(31 downto 0) ; -- debugging
end Behavioral;
