--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:29:42 03/16/2017
-- Design Name:   
-- Module Name:   C:/GMU/Spring 2017/ECE 493/PWM VHDL/Stepper_sohail/stepper_sohail_tb.vhd
-- Project Name:  Stepper_sohail
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: stepper
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
 
ENTITY stepper_sohail_tb IS
END stepper_sohail_tb;
 
ARCHITECTURE behavior OF stepper_sohail_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT stepper
    PORT(
         clk : IN  std_logic;
         start : IN  std_logic;
         speed : IN  std_logic_vector(1 downto 0);
         direction : IN  std_logic;
         enable : OUT  std_logic_vector(3 downto 0);
         output : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal start : std_logic := '0';
   signal speed : std_logic_vector(1 downto 0) := (others => '0');
   signal direction : std_logic := '0';

 	--Outputs
   signal enable : std_logic_vector(3 downto 0);
   signal output : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: stepper PORT MAP (
          clk => clk,
          start => start,
          speed => speed,
          direction => direction,
          enable => enable,
          output => output
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
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
