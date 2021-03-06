-- ALU
LIBRARY IEEE;
use IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ALU IS  
   PORT (
		A      	: IN   STD_LOGIC_VECTOR(3 DOWNTO 0);
		B      	: IN   STD_LOGIC_VECTOR(3 DOWNTO 0);
		CLK		: IN   STD_LOGIC;
		OPT		: OUT  STD_LOGIC_VECTOR(2 DOWNTO 0);
		OUTPUT	: OUT  STD_LOGIC_VECTOR(3 DOWNTO 0)
   );
END ALU; 

ARCHITECTURE BEHAVIORAL OF ALU IS
	-- OPTION SIGNALS
	SIGNAL CLK_REDUCT : UNSIGNED(25 downto 0) := (OTHERS => '0');
	SIGNAL OPTION     : UNSIGNED( 2 DOWNTO 0) := (OTHERS => '0');

	-- FULL ADDER COMPONENT
	COMPONENT FA
	PORT (
		A    : IN  STD_LOGIC;
		B    : IN  STD_LOGIC;
		CIN  : IN  STD_LOGIC;
		S    : OUT STD_LOGIC;
		COUT : OUT STD_LOGIC
	);
	END COMPONENT;
	
	-- FULL ADDER SIGNALS
	SIGNAL FA_C0  : STD_LOGIC := '0';
	SIGNAL FA_C1  : STD_LOGIC := '0';
	SIGNAL FA_C2  : STD_LOGIC := '0';
	SIGNAL FA_C3  : STD_LOGIC := '0';
	SIGNAL FA_OUT : STD_LOGIC_VECTOR (3 DOWNTO 0);
	
	-- FULL SUBTRACTOR COMPONENT
	COMPONENT FS
	PORT (
		A    : IN  STD_LOGIC;
		B    : IN  STD_LOGIC;
		BIN  : IN  STD_LOGIC;
		D    : OUT STD_LOGIC;
		BOUT : OUT STD_LOGIC
	);
	END COMPONENT;
	
	-- FULL SUBTRACTOR SIGNALS
	SIGNAL FS_B0  : STD_LOGIC := '0';
	SIGNAL FS_B1  : STD_LOGIC := '0';
	SIGNAL FS_B2  : STD_LOGIC := '0';
	SIGNAL FS_B3  : STD_LOGIC := '0';
	SIGNAL FS_OUT : STD_LOGIC_VECTOR (3 DOWNTO 0);
	
	-- 4x4 MULTIPLIER COMPONENT
	COMPONENT MULT
	PORT (
		A    : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
		B    : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
		POUT : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
	);
	END COMPONENT;
	
	-- 4x4 MULTIPLIER SIGNALS
	SIGNAL MULT_OUT : STD_LOGIC_VECTOR (3 DOWNTO 0);
	
	-- OTHER SIGNALS
	SIGNAL RESULT : STD_LOGIC_VECTOR (3 DOWNTO 0);

BEGIN
	
	-- FULL ADDER MAPPING
	FA0: FA PORT MAP (A(0), B(0),    '0', FA_OUT(0), FA_C0);
	FA1: FA PORT MAP (A(1), B(1),  FA_C0, FA_OUT(1), FA_C1);
	FA2: FA PORT MAP (A(2), B(2),  FA_C1, FA_OUT(2), FA_C2);
	FA3: FA PORT MAP (A(3), B(3),  FA_C2, FA_OUT(3), FA_C3);
	
	-- FULL SUBTRACTOR MAPPING
	FS0: FS PORT MAP (A(0), B(0),    '0', FS_OUT(0), FS_B0);
	FS1: FS PORT MAP (A(1), B(1),  FS_B0, FS_OUT(1), FS_B1);
	FS2: FS PORT MAP (A(2), B(2),  FS_B1, FS_OUT(2), FS_B2);
	FS3: FS PORT MAP (A(3), B(3),  FS_B2, FS_OUT(3), FS_B3);
		
	-- 4x4 MULTIPLIER MAPPING
	MULT0: MULT PORT MAP (A, B, MULT_OUT);

	PROCESS(A, B, CLK, OPTION, FA_OUT, FS_OUT, MULT_OUT)
	BEGIN
		IF RISING_EDGE(CLK) THEN
			IF (CLK_REDUCT(25) = '1' AND CLK_REDUCT(24) = '1') THEN -- REDUCES CLOCK TO 0.993 Hz
				OPTION <= OPTION + 1;
				CLK_REDUCT <= (OTHERS => '0');
			ELSE
				CLK_REDUCT <= CLK_REDUCT + 1;
			END IF;
		END IF;
		
		CASE(OPTION) IS
			WHEN "000" => -- A AND B
				RESULT <= A AND B;
				
			WHEN "001" => -- A OR B
				RESULT <= A OR B;
				
			WHEN "010" => -- NOT A
				RESULT <= NOT A;
				
			WHEN "011" => -- NOT B
				RESULT <= NOT B;
				
			WHEN "100" => -- A XOR B
				RESULT <= A XOR B;
				
			WHEN "101" => -- A + B
				RESULT <= FA_OUT;
				
			WHEN "110" => -- A - B
				RESULT <= FS_OUT;
				
			WHEN "111" => -- A * B
				RESULT <= MULT_OUT;
		END CASE;
	END PROCESS;
	
	OPT    <= STD_LOGIC_VECTOR(OPTION); -- OPTION OUT
	OUTPUT <= RESULT; -- ALU OUT
	
END BEHAVIORAL;