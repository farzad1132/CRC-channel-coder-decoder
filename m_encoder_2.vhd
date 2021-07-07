----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:24:41 01/18/2021 
-- Design Name: 
-- Module Name:    m_encoder_2 - Behavioral 
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity m_encoder_2 is
	port( clk, EN: in std_logic;
			data, poly: in std_logic_vector(3 downto 0);
			codeword: out std_logic_vector(6 downto 0);
			data_ready: out std_logic);
end m_encoder_2;

architecture Behavioral of m_encoder_2 is

	constant crc_len: integer range 0 to 7 := poly'length-1;
	constant zero_vector: std_logic_vector(crc_len-1 downto 0) := (others => '0');
	signal msb, lsb: integer range 0 to 7 := data'left;
	signal data_int, poly_int: std_logic_vector(3 downto 0) := (others => '0');
	signal cal_reg, output_int: std_logic_vector(codeword'left downto 0) := (others => '0');
	signal data_ready_int: std_logic := '0';
	type state is (idle, calculation, result);
	signal p_state: state;
begin
	lsb <= msb - crc_len;
	data_ready <= data_ready_int;
	codeword <= output_int;
	
	process(clk)
	begin
		if rising_edge(clk) then
			case p_state is
				when idle =>
					if EN = '1' then
						p_state <= calculation;
						data_int <= data;
						poly_int <= poly;
						cal_reg <= data & zero_vector;
						msb <= cal_reg'left;
						data_ready_int <= '0';
					else
						p_state <= idle;
					end if;
				
				when calculation =>
					if lsb = 0 then
						p_state <= result;
					else
						p_state <= calculation;
						msb <= msb-1;
					end if;
					
					if cal_reg(msb) = '1' then
						cal_reg(msb downto lsb) <= cal_reg(msb downto lsb) xor poly_int;
					end if;
				
				when result =>
					output_int <= cal_reg(msb-1 downto 0) & data_int;
					p_state <= idle;
					data_ready_int <= '1';
				
				when others =>
					p_state <= idle;
				end case;
		end if;
	end process;

end Behavioral;

