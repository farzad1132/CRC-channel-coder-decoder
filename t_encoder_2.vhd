--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:51:15 01/18/2021
-- Design Name:   
-- Module Name:   C:/ISE/FinalProject/t_encoder_2.vhd
-- Project Name:  FinalProject
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: m_encoder_2
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
 
ENTITY t_encoder_2 IS
END t_encoder_2;
 
ARCHITECTURE behavior OF t_encoder_2 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT m_encoder_2
    PORT(
         clk : IN  std_logic;
         EN : IN  std_logic;
         data : IN  std_logic_vector(3 downto 0);
         poly : IN  std_logic_vector(3 downto 0);
         codeword : OUT  std_logic_vector(6 downto 0);
         data_ready : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal EN : std_logic := '0';
   signal data : std_logic_vector(3 downto 0) := (others => '0');
   signal poly : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal codeword : std_logic_vector(6 downto 0);
   signal data_ready : std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: m_encoder_2 PORT MAP (
          clk => clk,
          EN => EN,
          data => data,
          poly => poly,
          codeword => codeword,
          data_ready => data_ready
        );

clk <= not clk after 5 ns;
poly <= "1011";
data <= "0101", "0010" after 60 ns, "1111" after 120 ns, "0001" after 180 ns;
EN <= '1' after 10 ns;

END;
