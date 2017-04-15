--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:47:09 01/12/2017
-- Design Name:   
-- Module Name:   C:/GMU/Spring 2017/ECE 493/PWM VHDL/Encoder_counter/Dec_ctr_tb.vhd
-- Project Name:  Encoder_counter
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Encoder_toplevel
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
 
ENTITY Dec_ctr_tb IS
END Dec_ctr_tb;
 
ARCHITECTURE behavior OF Dec_ctr_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Encoder_toplevel
    PORT(
         clk : IN  std_logic;
         A_i : IN  std_logic;
         B_i : IN  std_logic;
			bit_switch : in std_logic;
         FWD : OUT  std_logic;
         REV : OUT  std_logic;
         MOV : OUT  std_logic;
         count : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal A_i : std_logic := '0';
   signal B_i : std_logic := '0';
	signal bit_switch : std_logic := '0';

 	--Outputs
   signal FWD : std_logic;
   signal REV : std_logic;
   signal MOV : std_logic;
   signal count : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Encoder_toplevel PORT MAP (
          clk => clk,
          A_i => A_i,
          B_i => B_i,
			 bit_switch => bit_switch,
          FWD => FWD,
          REV => REV,
          MOV => MOV,
          count => count
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		a_i <= '0';
		b_i <= '0';
		bit_switch <= '1';
		wait for clk_period*5;
		a_i <= '1';
		wait for CLK_period*5;
		b_i <= '1';
		bit_switch <= '0';
		wait for clk_period*5;
		a_i <= '0';
		wait for clk_period*5;
		b_i <= '0';
		wait for 1000 ns;
   end process;

END;
