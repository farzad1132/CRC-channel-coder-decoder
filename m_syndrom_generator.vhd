----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:57:10 01/18/2021 
-- Design Name: 
-- Module Name:    m_syndrom_generator - Behavioral 
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
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity m_syndrom_generator is
	port( clk, EN: in std_logic;
			poly: in std_logic_vector(3 downto 0);
			data: in std_logic_vector(6 downto 0);
			syndrom: out std_logic_vector(2 downto 0);
			data_ready: out std_logic);
end m_syndrom_generator;

architecture Behavioral of m_syndrom_generator is
	constant crc_len: integer range 0 to 7 := poly'length-1;
	signal msb, lsb: integer range 0 to 7 := data'left;
	signal poly_int: std_logic_vector(3 downto 0) := (others => '0');
	signal cal_reg: std_logic_vector(6 downto 0) := (others => '0');
	signal syndrom_int: std_logic_vector(2 downto 0) := (others => '0');
	signal data_ready_int: std_logic := '0';
	type state is (idle, calculation, result);
	signal p_state: state;
begin
	lsb <= msb - crc_len;
	data_ready <= data_ready_int;
	syndrom <= syndrom_int;
	
	process(clk)
	begin
		if rising_edge(clk) then
			case p_state is
				when idle =>
					data_ready_int <= '0';
					if EN = '1' then
						p_state <= calculation;
						poly_int <= poly;
						cal_reg <= data;
						msb <= cal_reg'left;
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
					syndrom_int <= cal_reg(msb-1 downto 0);
					p_state <= idle;
					data_ready_int <= '1';
				
				when others =>
					p_state <= idle;
				end case;
		end if;
	end process;

end Behavioral;

