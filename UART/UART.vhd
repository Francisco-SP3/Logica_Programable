-- Librerías
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Definición de entidad
entity uart is
  port(
    clk, reset: 	in 	std_logic; -- Clock y reset
    tx_start: 	in 	std_logic; -- Entrada de comienzo
    s_tick: 	in	std_logic; -- Tick
    d_in: 		in 	std_logic_vector(7 downto 0);
    tx_done_tick:	out	std_logic;
    tx: 		out 	std_logic
  );
end entity;

-- Arquitectura de entidad
architecture Behaviour of uart is

  -- Definición de componente
  component baudrate_gen is
    port(
      clk, reset: 	in 	std_logic;
      tick: 	out 	std_logic
    );
  end component;
  
  signal tick : std_Logic;

begin
  
    baud_gen : baudrate_gen port map(clk, reset, tick);

    process (clk, reset)
    
    type state_type is (idle, start, data, stop);
  	variable state: state_type := idle;
    variable count: integer range 0 to 7 := 0;
    
    begin
    
      if reset = '1' then
        state := idle;
        count := 0;
        tx <= '1';
        tx_done_tick <= '0';
        
      elsif rising_edge(clk) then
      
        case state is
        
          when idle =>
            if tx_start = '0' then
              state := idle;
            elsif tx_start = '1' then
              state := start;
            end if;
            
          when start =>
              if tick = '0' then
                state := start;
              elsif tick = '1' then
              	state := data;
              end if;
              
          when data =>
            if tick = '0' then
              state := data;
            elsif tick = '1' AND count < 7 then
              state := data;
              tx <= d_in(count);
              count := count + 1;
            elsif tick = '1' AND count >= 7 then
              state := stop;
            end if;
            
          when stop =>
            tx <= '1';
            tx_done_tick <= '1';
            if tick = '1' then
              state := idle;
            end if;
            
        end case;
        
        case state is
          when idle =>
            tx <= '1';
            
        case state is
          when idle =>
            tx <= '0';
            
        case state is
          when idle =>
            tx <= '1';
            
            
        
      end if;
  	end process;
end architecture;