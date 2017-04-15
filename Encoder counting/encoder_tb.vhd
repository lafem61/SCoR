--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:39:30 01/05/2017
-- Design Name:   
-- Module Name:   C:/GMU/Spring 2017/ECE 493/PWM VHDL/Encoder/encoder_tb.vhd
-- Project Name:  Encoder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: QDEC
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY encoder_tb IS
END encoder_tb;
 
ARCHITECTURE behavior OF encoder_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT QDEC
    PORT(
         CLK : IN  std_logic;
         A : IN  std_logic;
         B : IN  std_logic;
         FWD : OUT  std_logic;
         REV : OUT  std_logic;
         MOV : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal A : std_logic := '0';
   signal B : std_logic := '0';

 	--Outputs
   signal FWD : std_logic;
   signal REV : std_logic;
   signal MOV : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: QDEC PORT MAP (
          CLK => CLK,
          A => A,
          B => B,
          FWD => FWD,
          REV => REV,
          MOV => MOV
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '1';
		wait for CLK_period/2;
		CLK <= '0';
		wait for CLK_period/2;
   end process;
  

   -- Stimulus process
   stim_proc: process
   begin		
		a <= '0';
		b <= '0';
		wait for clk_period*5;
		a <= '1';
      wait for CLK_period*5;
		b <= '1';
		wait for clk_period*5;
		a <= '0';
		wait for clk_period*5;
		b <= '0';

   end process;

END;
