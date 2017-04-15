----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:19:32 01/12/2017 
-- Design Name: 
-- Module Name:    Encoder_toplevel - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Encoder_toplevel is
    Port ( clk : in  STD_LOGIC;
           A_i : in  STD_LOGIC;
           B_i : in  STD_LOGIC;
			  reset : in std_logic;
			  bit_switch : in std_logic_vector(1 downto 0);
			  FWD : out STD_LOGIC;
			  REV : out STD_LOGIC;
			  input1 : out std_logic;
			  input2 : out std_logic;
			  MOV : out STD_LOGIC;
           count : out  STD_LOGIC_VECTOR (7 downto 0));
end Encoder_toplevel;

architecture Behavioral of Encoder_toplevel is

component QDEC port (
	CLK : in    std_logic;
	A   : in    std_logic;
	B   : in    std_logic;
	FWD : out   std_logic;
	REV : out   std_logic;
	MOV : out   std_logic);
	end component;
	
	component debouncer port (
	reset : in  STD_LOGIC;
	input : in  STD_LOGIC;
	clk : in  STD_LOGIC;
	output : out  STD_LOGIC);
	end component;
	
	component RED port (
	reset : in  STD_LOGIC;
	input : in  STD_LOGIC;
	clk : in  STD_LOGIC;
	output : out  STD_LOGIC);
	end component;
	
	
	signal A, B, mov_temp, count_en : std_logic := '0';
	signal count_unsigned : unsigned(39 downto 0) := (others => '0');
 
begin
	db1 : debouncer port map (reset => reset, input => A_i, clk => clk, output => A);
	db2 : debouncer port map (reset => reset, input => B_i, clk => clk, output => B);
--	A <= A_i;
--	B <= B_i;
	input1 <= A_i;
	input2 <= B_i;
	
	decoder : QDEC port map (clk => clk, A => A, B => B, FWD => FWD, REV => REV, MOV => MOV_temp);
	
	red_mov : RED port map (reset => '0', input => mov_temp, clk => clk, output => count_en);
	
	process(clk, count_en, reset)
	begin
	if (reset = '1') then
		count_unsigned <= (others => '0');
--	elsif (rising_edge(count_en)) then
	elsif (rising_edge(clk) and (count_en = '1')) then
		count_unsigned <= count_unsigned + 1;
	end if;
	end process;
	mov <= mov_temp;
	count <= std_logic_vector(count_unsigned(15 downto 8)) when bit_switch = "00" 
		else std_logic_vector(count_unsigned(23 downto 16)) when bit_switch = "01"
		else std_logic_vector(count_unsigned(31 downto 24)) when bit_switch = "10"
		else std_logic_vector(count_unsigned(39 downto 32));
end Behavioral;

