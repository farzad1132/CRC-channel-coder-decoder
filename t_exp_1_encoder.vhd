--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:06:31 01/28/2021
-- Design Name:   
-- Module Name:   C:/ISE/FinalProject/t_exp_1_encoder.vhd
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
 
ENTITY t_exp_1_encoder IS
END t_exp_1_encoder;
 
ARCHITECTURE behavior OF t_exp_1_encoder IS 
 
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
data <= "1000", "0100" after 60 ns, "1100" after 120 ns, "1001" after 180 ns, "1011" after 240 ns, "0111" after 300 ns, "0001" after 360 ns;
EN <= '1' after 10 ns;

END;
