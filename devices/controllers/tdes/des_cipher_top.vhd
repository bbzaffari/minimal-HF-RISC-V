---------------------------------------------------------------------
--				(c) Copyright 2006, CoreTex Systems, LLC					 --
--		                   www.coretexsys.com                        --    
--                                                            		 --
--		This source file may be used and distributed without         --
--		restriction provided that this copyright statement is not    --
--		removed from the file and that any derivative work contains  --
--		the original copyright notice and the associated disclaimer. --
--                                                            		 --
--		    THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY      --
--		EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED    --
--		TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS    --
--		FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR       --
--		OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,          --
--		INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES     --
--		(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE    --
--		GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR         --
--		BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF   --
--		LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT   --
--		(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT   --
--		OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE          --
--		POSSIBILITY OF SUCH DAMAGE.                                  --
--																						 --
---------------------------------------------------------------------

----------------------------------------------------------------------

-- Poject structure: 

--  |- tdes_top.vhd
--  |
--    |- des_cipher_top.vhd
--    |- des_top.vhd
--      |- block_top.vhd
--        |- add_key.vhd
--        |
--        |- add_left.vhd
--        |
--				|- e_expansion_function.vhd
--				|
--				|- p_box.vhd
--				|
--				|- s_box.vhd
--            |- s1_box.vhd
--            |- s2_box.vhd
--            |- s3_box.vhd
--            |- s4_box.vhd
--            |- s5_box.vhd
--            |- s6_box.vhd
--            |- s7_box.vhd
--            |- s8_box.vhd
--    |- key_schedule.vhd

----------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
--
-- Title       : des_cipher_top
-- Company     : CoreTex Systems, LLC
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity des_cipher_top is
port(
		--
		-- Core Interface 
		--
		key_in:				in std_logic_vector(0 to 63);		-- input for key
		--ldkey:				in std_logic;							-- signal for loading key
		function_select:	in	std_logic; 							-- function	select: '1' = encryption, '0' = decryption
		
		data_in:				in std_logic_vector(0 to 63);		-- input for data
		
		data_out:			out std_logic_vector(0 to 63);	-- output for data

		lddata:				in 	std_logic;						-- data strobe (active high)
		core_busy:			out	std_logic;						-- active high when encrypting/decryption data 
		des_out_rdy:		out	std_logic;						-- active high when encryption/decryption of data is done	

		reset: 				in std_logic;							-- active high
		clock: 				in std_logic							-- master clock

	);
end des_cipher_top;

architecture des_cipher_top of des_cipher_top is


signal key_select_internal: std_logic_vector(3 downto 0);
signal key_round_internal: std_logic_vector(0 to 47);
signal key_ready_internal: std_logic;
signal data_in_internal: std_logic_vector(0 to 63);
signal data_ready_internal: std_logic;

begin

process (clock)
begin
	
if rising_edge(clock) then
 
		if lddata = '1' then
		
			-- capute data from the bus
			data_in_internal 		<= data_in; -- register data from the bus
			data_ready_internal	<= '1';		-- data has been loaded: continue with encryptio/decryption   
		
		else
			
			data_ready_internal	<= '0';		-- data is not loaded: wait for data 
		
		end if;

end if;
end process;

--
-- KEY EXPANDER AND DES CORE instantiation
--
KEYSCHEDULE: entity work.key_schedule 
port map (

		KeySelect 	=> key_select_internal,
		key_in 		=> key_in,
		
		key_out 		=> key_round_internal,
		key_ready 	=> key_ready_internal,

		reset 		=> reset,
		clock 		=> clock
);

DESTOP: entity work.des_top 
port map (

		key_round_in 	=> key_round_internal,
		
		data_in		 	=> data_in_internal,
		
		key_ready 		=> key_ready_internal,
		data_ready 		=> data_ready_internal,

		KeySelect 		=> key_select_internal,

		func_select 	=> function_select,

		data_out 		=> data_out,
		core_busy 		=> core_busy,
		des_out_rdy 	=> des_out_rdy,

		reset 			=> reset,
		clock 			=> clock
);

end des_cipher_top;
