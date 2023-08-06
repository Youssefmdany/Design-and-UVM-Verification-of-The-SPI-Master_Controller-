


module SPI_Master
  #(parameter SPI_MODE = 0,
    parameter CLKS_PER_HALF_BIT = 3) //divider
  (
   // Control & Data Signals,
   input        i_Rst,     // Reset
   input        i_Clk,       // Clock
   
   // TX (MOSI) Signals
   input [7:0]  i_TX_Byte,        // Byte to be transmited on MOSI
   input        i_TX_Valid,          // Data Valid Pulse for i_TX_Byte
   output logic   o_TX_Ready,       // Transmit Ready for next byte
   
   // RX (MISO) Signals
   output logic       o_RX_Valid,     // Data Valid pulse for o_RX_Byte
   output logic [7:0] o_RX_Byte,   // Byte to be received on MISO

   // SPI Signals
   output logic  SCLK,
   input         MISO,
   output logic  MOSI
   );

	
  logic w_CPOL;     // Clock polarity
  logic w_CPHA;     // Clock phase

  logic [$clog2(CLKS_PER_HALF_BIT*2)-1:0] l_SPI_Clk_Count;
  logic l_SPI_Clk;
  logic [4:0] l_SPI_Clk_Edges;
  logic l_Leading_Edge;
  logic l_Trailing_Edge;
  logic       l_TX_Valid;
  logic [7:0] l_TX_Byte;
  logic [2:0] l_RX_Bit_Count;
  logic [2:0] l_TX_Bit_Count;

  
  
  // CPOL: Clock Polarity
  // CPOL=0 means that clock idles at 0, leading edge is rising edge.
  // CPOL=1 means that clock idles at 1, leading edge is falling edge.
  assign w_CPOL  = (SPI_MODE == 2) | (SPI_MODE == 3);

  
  // CPHA: Clock Phase
  // CPHA=0 means the "out" side changes the data on trailing edge of clock
  //              the "in" side captures data on leading edge of clock
  // CPHA=1 means the "out" side changes the data on leading edge of clock
  //              the "in" side captures data on the trailing edge of clock
  assign w_CPHA  = (SPI_MODE == 1) | (SPI_MODE == 3);



  
  
  
  // Generate the SPI CLK
  always_ff @(posedge i_Clk or posedge i_Rst)
  begin
    if (i_Rst)
    begin
      o_TX_Ready      <= 1'b0;
      l_SPI_Clk_Edges <= 0;
      l_Leading_Edge  <= 1'b0;
      l_Trailing_Edge <= 1'b0;
      l_SPI_Clk       <= w_CPOL; // assign default state to idle state
      l_SPI_Clk_Count <= 0;
    end
    else
    begin

      // Default assignments
      l_Leading_Edge  <= 1'b0;
      l_Trailing_Edge <= 1'b0;
      
      if (i_TX_Valid)
      begin
        o_TX_Ready      <= 1'b0;
        l_SPI_Clk_Edges <= 16;  // Total # edges in one byte ALWAYS 16
      end
      else if (l_SPI_Clk_Edges > 0)
      begin
        o_TX_Ready <= 1'b0;
        
        if (l_SPI_Clk_Count == CLKS_PER_HALF_BIT*2-1)  //the second half of period
        begin
          l_SPI_Clk_Edges <= l_SPI_Clk_Edges - 1'b1;
          l_Trailing_Edge <= 1'b1;
          l_SPI_Clk_Count <= 0;
          l_SPI_Clk       <= ~l_SPI_Clk;
        end
        else if (l_SPI_Clk_Count == CLKS_PER_HALF_BIT-1) //the first half of period
        begin
          l_SPI_Clk_Edges <= l_SPI_Clk_Edges - 1'b1;
          l_Leading_Edge  <= 1'b1;
          l_SPI_Clk_Count <= l_SPI_Clk_Count + 1'b1;
          l_SPI_Clk       <= ~l_SPI_Clk;
        end
        else
        begin
          l_SPI_Clk_Count <= l_SPI_Clk_Count + 1'b1;
        end
      end  
      else
      begin
        o_TX_Ready <= 1'b1;
      end
      
      
    end 
  end




  
  

  always_ff @(posedge i_Clk or posedge i_Rst)
  begin
    if (i_Rst)
    begin
      l_TX_Byte <= 8'h00;
      l_TX_Valid<= 1'b0;
    end
    else
      begin
        l_TX_Valid <= i_TX_Valid; // 1 clock cycle delay
        if (i_TX_Valid)
        begin
          l_TX_Byte <= i_TX_Byte;
        end
      end 
  end


  
  
  
  
  
  //Generate MOSI data
  
  always_ff @(posedge i_Clk or posedge i_Rst)
  begin
    if (i_Rst)
    begin
      MOSI     <= 1'b0;
      l_TX_Bit_Count <= 3'b111; // send MSb first
    end
    else
    begin
      // If ready is high, reset bit counts to default value
      if (o_TX_Ready)
      begin
        l_TX_Bit_Count <= 3'b111;
      end
      // Catch the case where we start transaction and CPHA = 0
      else if (l_TX_Valid & ~w_CPHA)
      begin
        MOSI           <= l_TX_Byte[3'b111];
        l_TX_Bit_Count <= 3'b110;
      end
      else if ((l_Leading_Edge & w_CPHA) | (l_Trailing_Edge & ~w_CPHA)) // if Leading or Trailing edge it detected
      begin
        l_TX_Bit_Count <= l_TX_Bit_Count - 1'b1;
        MOSI           <= l_TX_Byte[l_TX_Bit_Count];
      end
      
      if(l_TX_Bit_Count==3'b111 & l_Trailing_Edge)   MOSI<= 1'b0;
      
    end
  end


  
  
  
  
  
  
  // Read in MISO data.
  always_ff @(posedge i_Clk or posedge i_Rst)
  begin
    if (i_Rst)
    begin
      o_RX_Byte      <= 8'h00;
      o_RX_Valid        <= 1'b0;
      l_RX_Bit_Count <= 3'b111;
    end
    else
    begin

	 
      o_RX_Valid   <= 1'b0;

      if (o_TX_Ready) // Check if ready is high, reset bit count to default value
      begin
        l_RX_Bit_Count <= 3'b111;
      end
      else if ((l_Leading_Edge & ~w_CPHA) | (l_Trailing_Edge & w_CPHA)) // if Leading or Trailing edge it detected
      begin
        o_RX_Byte[l_RX_Bit_Count] <= MISO;  // Sample data
        l_RX_Bit_Count            <= l_RX_Bit_Count - 1'b1;
        if (l_RX_Bit_Count == 3'b000)
        begin
          o_RX_Valid   <= 1'b1;   // process is done
        end
      end
    end
  end
  
  
  
  
  
  //Add clock delay
  
  always_ff @(posedge i_Clk or posedge i_Rst)
  begin
    if (i_Rst)
    begin
      SCLK  <= w_CPOL;
    end
    else
      begin
      SCLK <= l_SPI_Clk;
      end 
  end 
  

  
  
  
endmodule 