-- 7SEG BCD DECODER
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY DEC7SEG IS
	PORT (
		INPUT  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		OUTPUT : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	 );
END ENTITY;
 
ARCHITECTURE BEHAVIORAL OF DEC7SEG IS
BEGIN
	PROCESS(INPUT) IS
	BEGIN
		CASE (INPUT) IS
			WHEN "0000" =>
				OUTPUT <= "1000000";
				
			WHEN "0001" =>
				OUTPUT <= "1111001";
				
			WHEN "0010" =>
				OUTPUT <= "0100100";
				
			WHEN "0011" =>
				OUTPUT <= "0110000";
				
			WHEN "0100" =>
				OUTPUT <= "0011001";
				
			WHEN "0101" =>
				OUTPUT <= "0010010";
				
			WHEN "0110" =>
				OUTPUT <= "0000010";
				
			WHEN "0111" =>
				OUTPUT <= "1111000";
				
			WHEN "1000" =>
				OUTPUT <= "0000000";
				
			WHEN "1001" =>
				OUTPUT <= "0010000";
				
			WHEN "1010" =>
				OUTPUT <= "0001000";
				
			WHEN "1011" =>
				OUTPUT <= "0000011";
				
			WHEN "1110" =>
				OUTPUT <= "0010010";
				
			WHEN "1111" =>
				OUTPUT <= "0001100";
				
			WHEN OTHERS =>
				OUTPUT <= "0000110";
				
		END CASE;
	END PROCESS;

END ARCHITECTURE;