--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:09:42 01/28/2021
-- Design Name:   
-- Module Name:   C:/ISE/FinalProject/t_exp_1_decoder.vhd
-- Project Name:  FinalProject
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: m_decoder
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
 
ENTITY t_exp_1_decoder IS
END t_exp_1_decoder;
 
ARCHITECTURE behavior OF t_exp_1_decoder IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT m_decoder
    PORT(
         clk : IN  std_logic;
         EN1 : IN  std_logic;
         EN2 : IN  std_logic;
         codeword : IN  std_logic_vector(6 downto 0);
         poly : IN  std_logic_vector(3 downto 0);
         data : OUT  std_logic_vector(3 downto 0);
         data_ready : OUT  std_logic;
         init_complete : OUT  std_logic;
         bit_fixed : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal EN1 : std_logic := '0';
   signal EN2 : std_logic := '0';
   signal poly : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal data : std_logic_vector(3 downto 0);
   signal data_ready : std_logic;
   signal init_complete : std_logic;
   signal bit_fixed : std_logic;
	type input_type is array (9 downto 0) of std_logic_vector(6 downto 0);
	constant input: input_type := (
		"1011000", "1110100", "0101100", "1101001", "0001011",
		"0100111", "0110001", "0000000", "0000000", "0000000");
	signal codeword : std_logic_vector(6 downto 0) := input(9);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: m_decoder PORT MAP (
          clk => clk,
          EN1 => EN1,
          EN2 => EN2,
          codeword => codeword,
          poly => poly,
          data => data,
          data_ready => data_ready,
          init_complete => init_complete,
          bit_fixed => bit_fixed
        );

clk <= not clk after 5 ns;
process(data_ready)
	variable index: integer range 9 downto 0 := 8;
begin
	if rising_edge(data_ready) then
		codeword <= input(index);
		index := index-1;
	end if;
end process;
EN1 <= '0', '1' after 20 ns;
EN2 <= '0', '1' after 20 ns;

poly <= "1011";

END;
