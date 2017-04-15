----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:46:08 01/25/2017 
-- Design Name: 
-- Module Name:    stepper - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity stepper is
    Port ( clk : in STD_LOGIC;
			  start : in  STD_LOGIC;
           direction : in  STD_LOGIC;
			  speed : in STD_LOGIC_VECTOR(1 downto 0);
			  enable : out std_logic_vector(3 downto 0);
           output : out  STD_LOGIC_VECTOR(3 downto 0));
end stepper;

architecture Behavioral of stepper is
signal timer : std_logic_vector(26 downto 0) := (others => '0');-- "0000000000";
signal q, q1, q2, q3, q4 : std_logic_vector(3 downto 0) := "0000";

begin

	enable <= "0000";
	process(clk)
	begin
		if rising_edge(clk) then
			if(start = '0') then
				timer <= (others => '0');--"0000000000";
			elsif(direction = '1') then
				timer <= timer + 1;
			else
				timer <= timer - 1;
			end if;
		end if;
	end process;
	
	with timer(26 downto 25) select q1 <=
		"0001" when "00",
		"0010" when "01",
		"0100" when "10",
		"1000" when others;
		
	with timer(24 downto 23) select q2 <=
		"0001" when "00",
		"0010" when "01",
		"0100" when "10",
		"1000" when others;
	with timer(22 downto 21) select q3 <=
		"0001" when "00",
		"0010" when "01",
		"0100" when "10",
		"1000" when others;
	with timer(20 downto 19) select q4 <=
		"0001" when "00",
		"0010" when "01",
		"0100" when "10",
		"1000" when others;
		
	with speed select q <=
		q4 when "00",
		q3 when "01",
		q2 when "10",
		q1 when others;
		
	with start select output <=
		(	not q) when '1',	-- removed NOT
		"1111" when others;	--changed from "1111"

end Behavioral;

