-- Author: Yi Zhu
-- Email: yi.zhu6@mail.mcgill.ca

-- Import the necessary libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Declare entity
entity counter is
	Generic(
	constant maximum : unsigned := x"9"
	);
	Port (
	clk	: in std_logic;
	rst	: in std_logic;
	count	: out std_logic_vector(3 downto 0)
	);
end counter;

architecture behaviour of counter is

begin

	process(clk,rst)
	  variable count_reg : unsigned(3 downto 0);
	  variable count_up : std_logic;
	begin
	  if(rst = '1')then
	    count_reg := (others => '0');
   	    count_up := '1';
	  elsif (clk'event and clk = '1')then
	    count <= std_logic_vector(count_reg);
	  if(count_reg = maximum) then
	    count_up := '0';
	  elsif (count_reg = "0000") then
	    count_up := '1';
	  end if;
	  if( count_up = '1') then
	    count_reg := count_reg + 1;
	  else
	    count_reg := count_reg - 1;
	  end if;
	end if;

  end process;
end behaviour;
