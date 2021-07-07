----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:20:13 01/18/2021 
-- Design Name: 
-- Module Name:    m_decoder - Behavioral 
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

entity m_decoder is
	port(	clk, EN1, EN2: in std_logic;
			codeword: in std_logic_vector(6 downto 0);
			poly: in std_logic_vector(3 downto 0);
			data: out std_logic_vector(3 downto 0);
			data_ready, init_complete, bit_fixed: out std_logic);
			-- data_ready: whenever this is 1 it means decoder has been decoded the codeword and data is correct
			-- init_complete: whenever this is 1 it means from now decoder can accept input
			-- bit_fixed: 	whenever this is 1 and data_ready is also 1 it means data is correct but the given codeword had one incorrect bit ant the
			--					the decoder has fixed that bit
end m_decoder;

architecture Behavioral of m_decoder is
	type lookup_type is array (7 downto 0) of std_logic_vector(6 downto 0);
	signal lookup: lookup_type:= (others => (others => '0'));
	type state is (idle1, init, idle2, decode);
	signal p_state: state;
	
	component m_syndrom_generator is
	port( clk, EN: in std_logic;
			poly: in std_logic_vector(3 downto 0);
			data: in std_logic_vector(6 downto 0);
			syndrom: out std_logic_vector(2 downto 0);
			data_ready: out std_logic);
	end component;
	
	signal en_int, dec_ready, syndrom_ready, init_com_int, bit_fix_int, flag: std_logic := '0';
	signal poly_int, dec_out: std_logic_vector(3 downto 0) := (others => '0');
	signal codeword_int: std_logic_vector(6 downto 0) := (others => '0');
	signal count: integer range 0 to 8 := 8;
	signal count2: integer range 0 to 6 := 5;
	signal syndrom_int : std_logic_vector(2 downto 0) := (others => '0');
begin
	
	syndrome: m_syndrom_generator
			port map(clk => clk,
						EN => en_int,
						poly => poly_int,
						data => codeword_int,
						syndrom => syndrom_int,
						data_ready => syndrom_ready);
	data <= dec_out;
	data_ready <= dec_ready;
	init_complete <= init_com_int;
	bit_fixed <= bit_fix_int;
	process(clk)
		variable dump_var: std_logic_vector(6 downto 0) := (others => '0');
		variable error_vec, error_vec2: std_logic_vector(6 downto 0) := "1000000";
	begin
		if rising_edge(clk) then
			case p_state is
				when idle1 =>
					init_com_int <= '0';
					if EN1 = '1' then
						p_state <= init;
						poly_int <= poly;
						en_int <= '1';
						codeword_int <= error_vec;
					else
						p_state <= idle1;
						en_int <= '0';
						codeword_int <= "0000000";
					end if;
		
				when init =>
					if count = 8 then
						p_state <= init;
						en_int <= '0';
						error_vec := "1000000";
						error_vec2 := "1000000";
						count <= count - 1;
					elsif count = 0 then
						p_state <= idle2;
						init_com_int <= '1';
						en_int <= '0';
					else
						p_state <= init;
						count2 <= count2 - 1;
						if count2 = 1 then
							error_vec2 := error_vec;
							error_vec := '0' & error_vec(6 downto 1);
							codeword_int <= error_vec;
							if count /= 1 then
								en_int <= '1';
							else
								en_int <= '0';
							end if;
						end if;
						if syndrom_ready = '1' then
								count <= count - 1;
								lookup(conv_integer(syndrom_int)) <= error_vec2;
								en_int <= '0';
								count2 <= 5;
						end if;
					end if;
				
				when idle2 =>
					dec_ready <= '0';
					bit_fix_int <= '0';
					dec_ready <= '0';
					if EN2 = '1' then
						en_int <= '1';
						codeword_int <= codeword;
						p_state <= decode;
					else
						en_int <= '0';
						p_state <= idle2;
					end if;
				
				when decode =>
					en_int <= '0';
					if syndrom_ready = '1' then
						dec_ready <= '1';
						p_state <= idle2;
						if syndrom_int /= "000" then
							dump_var := codeword_int xor lookup(conv_integer(syndrom_int));
							dec_out <= dump_var(3 downto 0);
							bit_fix_int <= '1';
						else
							dec_out <= codeword_int(3 downto 0);
							bit_fix_int <= '0';
						end if;
					else
						p_state <= decode;
					end if;
				
				when others =>
					p_state <= idle1;
					dec_ready <= '0';
					init_com_int <= '0';
					en_int <= '0';
			end case;
		end if;
	
	end process;
end Behavioral;

