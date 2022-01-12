library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.math_real.all;
use ieee.std_logic_textio.all;
library std_developerskit;
use std_developerskit.std_iopak.all;
library std;
use std.textio.all;
use std.env.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_montgomery_mult_vhd IS
END test_montgomery_mult_vhd;
 
ARCHITECTURE behavior OF test_montgomery_mult_vhd IS 
  CONSTANT M : INTEGER := 8;
    -- Component Declaration for the Unit Under Test (UUT)
  Component montgomery_mult is
  port(
    a,b : IN std_logic_vector(M-1 DOWNTO 0);
    clk, reset, start : IN std_logic;
    z: OUT std_logic_vector(M-1 DOWNTO 0);
    done: OUT std_logic
    );
  END Component;
  -- inputs
    
  signal clk : std_logic := '0';
  signal reset : std_logic := '1';
  signal a : std_logic_vector(M-1 downto 0) := (others => '0');
  signal b : std_logic_vector(M-1 downto 0) := (others => '0');

  -- Outputs
  signal z_out : std_logic_vector(M-1 downto 0):= (others => '0');
  SIGNAL done : STD_LOGIC:= '0';
  signal data_check: std_logic_vector(M-1 downto 0):= (others => '0');

  -- Clock period definitions
  constant clk_period : time := 100 ns;
  signal start:std_logic:= '0';
 
BEGIN
 
  -- Instantiate the Unit Under Test (UUT)
  uut: montgomery_mult PORT MAP (
    clk => clk,
    reset => reset,
    a => a,
    b => b,
    z => z_out,
    start => start,
    done => done
    );

  -- Clock process definitions
  clk <= not clk after clk_period / 2;

  
  
  -- Stimulus process
  stim_proc: process
    file infile : text open read_mode is "MontMul.txt";

    VARIABLE inline : LINE;
    VARIABLE outline : LINE;
    VARIABLE itr_numline : STRING(1 TO 2);  -- Line for iteration 'N='
    VARIABLE a_line : STRING(1 TO 2);           -- line for a 'A='
    VARIABLE b_line : STRING(1 TO 2);       -- Line for b 'B ='
    VARIABLE c_line : STRING(1 to 2);
    VARIABLE iteration_num : INTEGER;       
    VARIABLE a_str : STRING(1 TO 2);
    VARIABLE b_str : STRING(1 TO 2);
    VARIABLE c_str : STRING(1 TO 2);
    VARIABLE exp_c : STD_LOGIC_VECTOR(M-1 DOWNTO 0):= (OTHERS => '0');
	
    VARIABLE number_of_test : integer := 0;
    VARIABLE number_of_success : integer := 0;
    VARIABLE number_of_failure : integer := 0;
	
  begin		
    wait for 1 ns;
    reset <= '0';
    start <= '0';
    WAIT UNTIL (clk'EVENT AND clk ='1');
    reset <= '1';
    write(outline, string'("Tables Known Answer Tests"));
    writeline(output, outline);
    write(outline, string'("-------------------------"));
    while(not endfile(infile)) loop
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      readline(infile, inline);
      read(inline, itr_numline);
      read(inline, iteration_num);
      readline(infile, inline);
      read(inline, a_line);
      read(inline, a_str);
      readline(infile, inline);
      read(inline, b_line);
      read(inline, b_str);
      readline(infile, inline);
      read(inline, c_line);
      read(inline, c_str);
      WAIT UNTIL (clk'EVENT AND clk ='1');
      a <= to_StdLogicVector(From_HexString(a_str));
      b <= to_StdLogicVector(From_HexString(b_str));
      exp_c := to_StdLogicVector(From_HexString(c_str));
      WAIT UNTIL (clk'EVENT AND clk='1');
      reset <= '0';
      WAIT UNTIL (clk'EVENT AND clk='1');
      start <= '1';     
      WAIT UNTIL (clk'EVENT AND clk ='1');
      start <= '0';
      WAIT UNTIL done ='1';
      data_check <= z_out;
      WAIT FOR 2*clk_period;  -- 2* clk_period
      
      write(outline, string'("Test Vector Number - "));
      write(outline, iteration_num);
      writeline(output, outline);
      write(outline, string'("Result: "));
      if (data_check = exp_c) then
        write(outline, string'("OK"));
        number_of_success := number_of_success + 1;
      else
        write(outline, string'("Error"));
        number_of_failure := number_of_failure + 1;
      end if;
      writeline(output, outline);
      number_of_test := number_of_test + 1;	
   end loop;

    write(outline, string'("=============== Summary ==========================="));
    writeline(output, outline);
    write(outline, string'("Number of inputs: "));
    write(outline, number_of_test);
    writeline(output, outline);
    write(outline, string'("Number of test passed: "));
    write(outline, number_of_success);
    writeline(output, outline);
    write(outline, string'("Number of test failed: "));
    write(outline, number_of_failure);
    writeline(output, outline);
    write(outline, string'("==================================================="));
    writeline(output, outline);
    finish(2);
  end process;

END;
