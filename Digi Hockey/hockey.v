module hockey(

    input clk,
    input rst,
    
    input BTNA,
    input BTNB,
    
    input [1:0] DIRA,
    input [1:0] DIRB,
    
    input [2:0] YA,
    input [2:0] YB,
   
    output reg LEDA,
    output reg LEDB,
    output reg [4:0] LEDX,
    
    output reg [6:0] SSD7,
    output reg [6:0] SSD6,
    output reg [6:0] SSD5,
    output reg [6:0] SSD4, 
    output reg [6:0] SSD3,
    output reg [6:0] SSD2,
    output reg [6:0] SSD1,
    output reg [6:0] SSD0   
    
    );
    
    // you may use additional always blocks or drive SSDs and LEDs in one always block
    

    //Created By Berke Ayyıldızlı, berke.ayyildizli, 31018
    //Kerem Tatari, keremtatari, 29208

    wire [1:0] combined_button; //a combined button signal to check button presses

    parameter //defined paramets for the workings of the code
        IDLE = 4'b0000, //0th state
        DISP = 4'b0001, //1st state
        HIT_B = 4'b0010, //2nd state
        HIT_A = 4'b0011, //3rd state
        SEND_A = 4'b0100, //4th state
        SEND_B = 4'b0101, //5th state
        RESP_A = 4'b0110, //6th state
        RESP_B = 4'b0111, //7th state
        GOAL_A = 4'b1000, //8th state
        GOAL_B = 4'b1001, //9th state
        TheEnd = 4'b1010, //10th state
        timer = 7'b1100100, //100
        zero = 7'b0000001,
        one = 7'b1001111,
        two = 7'b0010010,
        three = 7'b0000110,
        four = 7'b1001100,
        a = 7'b0001000,
        b = 7'b1100000,
        dash = 7'b1111110,
        blank = 7'b1111111,
        lighta = 1'b1,
        lightb = 1'b1,
        offa = 1'b0,
        offb = 1'b0,
        left5 = 5'b10000,
        left4 = 5'b01000,
        left3 = 5'b00100,
        left2 = 5'b00010,
        left1 = 5'b00001,
        ledall = 5'b11111,
        ledoff = 5'b00000,
        light3 = 5'b10101,
        light2 = 5'b01010,
        timer50 = 7'b0110010;
        
    assign combined_button = {BTNA, BTNB};

    reg [3:0] states;
    reg [6:0] counter;

    reg [1:0] dirY;

    reg [1:0] scoreB;
    reg [1:0] scoreA;
    
    reg [2:0] X_COORD;
    reg [2:0] Y_COORD;

    
    reg turn;

    // for state machine and memory elements 
    always @(posedge clk or posedge rst)
    begin

        if (rst) begin

            Y_COORD <= 0;
            X_COORD <= 0;
            counter <= 0;
            turn <= 0;
            scoreA <= 0;
            scoreB <= 0;
            dirY <= 0;
            
            states <= IDLE;
            
        end

        else begin
            
            case (states)

                IDLE: begin
                    
                    if (combined_button == 2'b10) begin
                        
                        turn <= 0;
                        states <= DISP;

                    end

                    else if (combined_button == 2'b01) begin
                        
                        turn <= 1;
                        states <= DISP;
                        
                    end

                    else if ((combined_button == 2'b00) || (combined_button == 2'b11)) begin
                       
                        states <= IDLE;

                    end

                    else begin
                        
                        states <= IDLE;

                    end

                end

                DISP: begin

                    if (counter < timer) begin
                        
                        counter <= counter + 1;
                        states <= DISP;
                        
                    end

                    else begin
                        
                        counter <= 0;
                        
                        if (turn == 1) begin
                            
                            states <= HIT_B;
                            
                        end

                        else begin
                            
                            states <= HIT_A;
                            
                        end

                    end

                end

                HIT_B: begin
                    
                    if ((BTNB == 1) && (YB < 5)) begin
                        
                        X_COORD <= 4;
                        Y_COORD <= YB;
                        dirY <= DIRB;

                        states <= SEND_A;
                        
                    end

                    else begin
                      
                        states <= HIT_B;
                        
                    end

                end

                HIT_A: begin
                    
                    if ((BTNA == 1) && (YA < 5)) begin
                        
                        X_COORD <= 0;
                        Y_COORD <= YA;
                        dirY <= DIRA;

                        states <= SEND_B;
                        
                    end

                    else begin
                        
                        states <= HIT_A;
                        
                    end

                end

                SEND_A: begin
                    
                    if (counter < timer) begin

                        counter <= counter + 1;
                        
                        states <= SEND_A;
                        
                    end

                    else begin
                        
                        counter <= 0;

                        if (dirY == 2'b10) begin

                            if (Y_COORD == 0) begin
                                
                                dirY <= 2'b01;
                                Y_COORD <= Y_COORD + 1;

                                if (X_COORD > 1) begin

                                    X_COORD <= X_COORD - 1;
                                    
                                    states <= SEND_A;
                                    
                                end

                                else begin
                                    
                                    X_COORD <= 0;
                                    
                                    states <= RESP_A;

                                end
                                
                            end

                            else begin

                                Y_COORD <= Y_COORD - 1;

                                if (X_COORD > 1) begin

                                    X_COORD <= X_COORD - 1;
                                    
                                    states <= SEND_A;
                                    
                                end

                                else begin
                                    
                                    X_COORD <= 0;
                                   
                                    states <= RESP_A;

                                end
                                
                            end
                            
                        end

                        else if (dirY == 2'b01) begin

                            if (Y_COORD == 4) begin

                                dirY <= 2'b10;
                                Y_COORD <= Y_COORD - 1;

                                if (X_COORD > 1) begin

                                    X_COORD <= X_COORD - 1;
                                    
                                    states <= SEND_A;
                                    
                                end

                                else begin
                                    
                                    X_COORD <= 0;
                                    
                                    states <= RESP_A;

                                end
               
                            end

                            else begin

                                Y_COORD <= Y_COORD + 1;

                                if (X_COORD > 1) begin

                                    X_COORD <= X_COORD - 1;
                                    
                                    states <= SEND_A;
                                    
                                end

                                else begin
                                    
                                    X_COORD <= 0;
                                   
                                    states <= RESP_A;

                                end
                                
                            end
                            
                        end

                        else if (dirY == 2'b00) begin

                            if (X_COORD > 1) begin

                                X_COORD <= X_COORD - 1;
                                
                                states <= SEND_A;
                                
                            end

                            else begin
                                
                                X_COORD <= 0;
                                
                                states <= RESP_A;

                            end
                            
                        end

                        else begin //NEW PART *****************
                            
                            X_COORD <= 0;

                        end

                    end

                end

                SEND_B: begin
                    
                    if (counter < timer) begin

                        counter <= counter + 1;
                        
                        states <= SEND_B;
                        
                    end

                    else begin
                        
                        counter <= 0;

                        if (dirY == 2'b10) begin

                            if (Y_COORD == 0) begin

                                dirY <= 2'b01;
                                Y_COORD <= Y_COORD + 1;

                                if (X_COORD < 3) begin

                                    X_COORD <= X_COORD + 1;
                                    
                                    states <= SEND_B;
                                    
                                end

                                else begin
                                    
                                    X_COORD <= 4;
                                    
                                    states <= RESP_B;

                                end

                            end

                            else begin

                                Y_COORD <= Y_COORD - 1;

                                if (X_COORD < 3) begin

                                    X_COORD <= X_COORD + 1;
                                    
                                    states <= SEND_B;
                                    
                                end

                                else begin
                                    
                                    X_COORD <= 4;
                                    
                                    states <= RESP_B;

                                end

                            end
                            
                        end

                        else if (dirY == 2'b01) begin

                            if (Y_COORD == 4) begin

                                dirY <= 2'b10;
                                Y_COORD <= Y_COORD - 1;

                                if (X_COORD < 3) begin

                                    X_COORD <= X_COORD + 1;
                                    
                                    states <= SEND_B;
                                    
                                end

                                else begin
                                    
                                    X_COORD <= 4;
                                    
                                    states <= RESP_B;

                                end
  
                            end

                            else begin

                                Y_COORD <= Y_COORD + 1;

                                if (X_COORD < 3) begin

                                    X_COORD <= X_COORD + 1;
                                   
                                    states <= SEND_B;
                                    
                                end

                                else begin
                                    
                                    X_COORD <= 4;
                                    
                                    states <= RESP_B;

                                end

                            end
                            
                        end

                        else if (dirY == 2'b00) begin

                            if (X_COORD < 3) begin

                                X_COORD <= X_COORD + 1;
                               
                                states <= SEND_B;
                                
                            end

                            else begin
                                
                                X_COORD <= 4;
                                
                                states <= RESP_B;

                            end

                        end

                        else begin //NEW PART*********************
                            
                            X_COORD <= 4;

                        end

                    end

                end

                RESP_A: begin
                    
                    if (counter < timer) begin

                        if ((BTNA == 1) && (Y_COORD == YA)) begin

                            X_COORD <= 1;
                            counter <= 0;

                            if (DIRA == 2'b10) begin

                                if (Y_COORD == 0) begin

                                    dirY <= 2'b01;
                                    Y_COORD <= Y_COORD + 1;
                                    
                                    states <= SEND_B;
                                    
                                end

                                else begin
                                    
                                    dirY <= DIRA;
                                    Y_COORD <= Y_COORD - 1;
                                    
                                    states <= SEND_B;

                                end
                                
                            end

                            else if (DIRA == 2'b01) begin

                                if (Y_COORD == 4) begin

                                    dirY <= 2'b10;
                                    Y_COORD <= Y_COORD - 1;
                                    
                                    states <= SEND_B;
                                    
                                end

                                else begin
                                    
                                    dirY <= DIRA;
                                    Y_COORD <= Y_COORD + 1;
                                    
                                    states <= SEND_B;

                                end
                                
                            end

                            else if (DIRA == 2'b00) begin

                                dirY <= DIRA;
                                
                                states <= SEND_B;
                                
                            end

                            else begin //NEW PART******************
                                
                                dirY <= DIRA;

                            end 

                        end

                        else begin
                            
                            counter <= counter + 1;
                            
                            states <= RESP_A;

                        end
                        
                    end

                    else begin
                        
                        counter <= 0;
                        scoreB <= scoreB + 1;
                        
                        states <= GOAL_B;
                    end

                end

                RESP_B: begin

                    if (counter < timer) begin

                        if ((BTNB == 1) && (Y_COORD == YB)) begin

                            X_COORD <= 3;
                            counter <= 0;

                            if (DIRB == 2'b10) begin

                                if (Y_COORD == 0) begin

                                    dirY <= 2'b01;
                                    Y_COORD <= Y_COORD + 1;
                                    
                                    states <= SEND_A;
                                    
                                end

                                else begin
                                    
                                    dirY <= DIRB;
                                    Y_COORD <= Y_COORD - 1;
                                    
                                    states <= SEND_A;

                                end
                                
                            end

                            else if (DIRB == 2'b01) begin

                                if (Y_COORD == 4) begin

                                    dirY <= 2'b10;
                                    Y_COORD <= Y_COORD - 1;
                                   
                                    states <= SEND_A;
                                    
                                end

                                else begin
                                    
                                    dirY <= DIRB;
                                    Y_COORD <= Y_COORD + 1;
                                    
                                    states <= SEND_A;

                                end
                                
                            end

                            else if (DIRB == 2'b00) begin

                                dirY <= DIRB;
                                
                                states <= SEND_A;
                                
                            end

                            else begin //NEW PART***************
                                
                                dirY <= DIRB;

                            end

                        end

                        else begin
                            
                            counter <= counter + 1;
                            
                            states <= RESP_B;

                        end
                        
                    end

                    else begin
                        
                        counter <= 0;
                        scoreA <= scoreA + 1;
                        
                        states <= GOAL_A;
                    end
                    
                end

                GOAL_A: begin
                    
                    if (counter < timer) begin

                        counter <= counter + 1;
                        
                        states <= GOAL_A;
                        
                    end

                    else begin
                        
                        counter <= 0;

                        if (scoreA == 3) begin
                            
                            turn <= 0;
                            states <= TheEnd;
                            
                        end

                        else begin
                            
                            states <= HIT_B;

                        end

                    end

                end


                GOAL_B: begin
                    
                    if (counter < timer) begin

                        counter <= counter + 1;
                        
                        states <= GOAL_B;
                        
                    end

                    else begin
                        
                        counter <= 0;

                        if (scoreB == 3) begin

                            turn <= 1;
                            
                            states <= TheEnd;
                            
                        end

                        else begin
                                
                            states <= HIT_A;

                        end

                    end 

                end

                TheEnd: begin
                
                     if (counter < timer) begin

                        counter <= counter + 1;
                        
                    end
                    
                    else begin
                    
                        counter <= 0;
                    
                    end
                    
                    states <= TheEnd;

                end

                default: begin //NEW PART *************

                    states <= states;
                    
                end

            endcase
            
        end

    end
    
    // for SSDs
    always @ (*) begin
    
                SSD2 = blank;
                SSD1 = blank;
                SSD0 = blank;
                
                SSD3 = blank;
                SSD4 = blank;
                SSD5 = blank;
                SSD6 = blank;
                SSD7 = blank;
    
  
        case (states)

            IDLE: begin
            
                SSD2 = a;
                SSD1 = dash;
                SSD0 = b;
                
                SSD3 = blank;
                SSD4 = blank;
                SSD5 = blank;
                SSD6 = blank;
                SSD7 = blank;
          
            end

            DISP: begin
            
                SSD0 = zero;
                SSD1 = dash;
                SSD2 = zero;
                SSD3 = blank;
                SSD4 = blank;
                SSD5 = blank;
                SSD6 = blank;
                SSD7 = blank;
           
            end

            HIT_B: begin //here we use ssd4 to show YB and YA, meaning the places that the user selects using the first 3 switches
            
                SSD0 = blank;
                SSD1 = blank;
                SSD2 = blank;
            
                if (YB == 0) begin

                    SSD4 = zero;

                end

                else if (YB == 1) begin

                    SSD4 = one;

                end
                
                else if (YB == 2) begin

                    SSD4 = two;

                end

                else if (YB == 3) begin

                    SSD4 = three;

                end

                else if (YB == 4) begin

                    SSD4 = four;

                end

                else begin

                    SSD4 = dash;

                end
                
            end

            HIT_A: begin 
            
                SSD0 = blank;
                SSD1 = blank;
                SSD2 = blank;
                
                if (YA == 0) begin

                    SSD4 = zero;
                    
                end

                else if (YA == 1) begin

                    SSD4 = one;

                end

                else if (YA == 2) begin

                    SSD4 = two;

                end

                else if (YA == 3) begin

                    SSD4 = three;

                end

                else if (YA == 4) begin

                    SSD4 = four;

                end

                else begin

                    SSD4 = dash;

                end
                
            end

            SEND_A: begin
            
                SSD0 = blank;
                
                SSD1 = blank;
                
                SSD2 = blank;

                if (Y_COORD == 0) begin 
                                        
                    SSD4 = zero;
                    
                end

                else if (Y_COORD == 1) begin

                    SSD4 = one;
                    
                end

                else if (Y_COORD == 2) begin

                    SSD4 = two;
                    
                end

                else if (Y_COORD == 3) begin

                    SSD4 = three;
                    
                end

                else if (Y_COORD == 4) begin

                    SSD4 = four;
                    
                end

                else begin
                    
                    SSD4 = blank; //NEW PART****************

                end
                
            end

            SEND_B: begin
            
                SSD0 = blank;
                
                SSD1 = blank;
                
                SSD2 = blank;

                if (Y_COORD == 0) begin

                    SSD4 = zero;
                    
                end

                else if (Y_COORD == 1) begin

                    SSD4 = one;
                    
                end

                else if (Y_COORD == 2) begin

                    SSD4 = two;
                    
                end

                else if (Y_COORD == 3) begin

                    SSD4 = three;
                    
                end

                else if (Y_COORD == 4) begin

                    SSD4 = four;
                    
                end

                else begin//NEW PART**************
                    
                    SSD4 = blank;

                end
                
            end

            RESP_A: begin
            
                SSD0 = blank;
                
                SSD1 = blank;
                
                SSD2 = blank;
                
                if (Y_COORD == 0) begin

                    SSD4 = zero;
                    
                end

                else if (Y_COORD == 1) begin

                    SSD4 = one;
                    
                end

                else if (Y_COORD == 2) begin

                    SSD4 = two;
                    
                end

                else if (Y_COORD == 3) begin

                    SSD4 = three;
                    
                end

                else if (Y_COORD == 4) begin

                    SSD4 = four;
                    
                end

                else begin //NEW PART***************
                    
                    SSD4 = blank;

                end
                
            end

            RESP_B: begin
            
                SSD0 = blank;
                
                SSD1 = blank;
                
                SSD2 = blank;
                
                if (Y_COORD == 0) begin

                    SSD4 = zero;
                    
                end

                else if (Y_COORD == 1) begin

                    SSD4 = one;
                    
                end

                else if (Y_COORD == 2) begin

                    SSD4 = two;
                    
                end

                else if (Y_COORD == 3) begin

                    SSD4 = three;
                    
                end

                else if (Y_COORD == 4) begin

                    SSD4 = four;
                    
                end

                else begin//NEW PART************
                    
                    SSD4 = blank;

                end
                
            end

            GOAL_A: begin
            
                SSD0 = blank;
                
                SSD1 = blank;
                
                SSD2 = blank;
                
                SSD4 = blank;

                //WHEN A IS 1 ///////////////////////////////////////////////
                
                if(scoreA == 1 && scoreB == 0)begin //A-B = 1-0

                    SSD0 = zero;
                    SSD1 = dash;
                    SSD2 = one;
                    SSD4 = blank;
                
                end
                
                else if(scoreA == 1 && scoreB == 1)begin //A-B = 1-1
                
                    SSD0 = one;
                    SSD1 = dash;
                    SSD2 = one;
                    SSD4 = blank;
                
                end

                else if(scoreA == 1 && scoreB == 2)begin //A-B = 1-2
                
                    SSD0 = two;
                    SSD1 = dash;
                    SSD2 = one;
                    SSD4 = blank;
                
                end

                else if(scoreA == 1 && scoreB == 3)begin //A-B = 1-3
                
                    SSD0 = three;
                    SSD1 = dash;
                    SSD2 = one;
                    SSD4 = blank;
                
                end

                //WHEN A IS 2 ///////////////////////////////////////////////////

                else if(scoreA == 2 && scoreB == 0)begin //A-B = 2-0
                
                    SSD0 = zero;
                    SSD1 = dash;
                    SSD2 = two;
                    SSD4 = blank;
                
                end

                else if(scoreA == 2 && scoreB == 1)begin //A-B = 2-1
                
                    SSD0 = one;
                    SSD1 = dash;
                    SSD2 = two;
                    SSD4 = blank;
                
                end

                else if(scoreA == 2 && scoreB == 2)begin //A-B = 2-2
                
                    SSD0 = two;
                    SSD1 = dash;
                    SSD2 = two;
                    SSD4 = blank;
                
                end

                else if(scoreA == 2 && scoreB == 3)begin //A-B = 2-3
                
                    SSD0 = three;
                    SSD1 = dash;
                    SSD2 = two;
                    SSD4 = blank;
                
                end

                //WHEN A IS 3 ///////////////////////////////////////////////////

                else if(scoreA == 3 && scoreB == 0)begin //A-B = 3-0
                
                    SSD0 = zero;
                    SSD1 = dash;
                    SSD2 = three;
                    SSD4 = blank;
                
                end

                else if(scoreA == 3 && scoreB == 1)begin //A-B = 3-1
                
                    SSD0 = one;
                    SSD1 = dash;
                    SSD2 = three;
                    SSD4 = blank;
                
                end

                else if(scoreA == 3 && scoreB == 2)begin //A-B = 3-2
                
                    SSD0 = two;
                    SSD1 = dash;
                    SSD2 = three;
                    SSD4 = blank;
                
                end

                else if(scoreA == 3 && scoreB == 3)begin //A-B = 3-3
                
                    SSD0 = three;
                    SSD1 = dash;
                    SSD2 = three;
                    SSD4 = blank;
                
                end

                else begin //NEW PART**************
                    
                    SSD0 = blank;
                    SSD1 = blank;
                    SSD2 = blank;
                    SSD4 = blank;

                end
              
            end

            GOAL_B: begin
                
                SSD0 = blank;
                
                SSD1 = blank;
                
                SSD2 = blank;
                
                SSD4 = blank;
                
                //WHEN B IS 1 ///////////////////////////////////////////////
                    
                if(scoreB == 1 && scoreA == 0)begin //B-A = 1-0

                    SSD0 = one;
                    SSD1 = dash;
                    SSD2 = zero;
                    SSD4 = blank;
                
                end
                    
                else if(scoreB == 1 && scoreA == 1)begin //B-A = 1-1
                
                    SSD0 = one;
                    SSD1 = dash;
                    SSD2 = one;
                    SSD4 = blank;
                
                end

                else if(scoreB == 1 && scoreA == 2)begin //B-A = 1-2
                
                    SSD0 = one;
                    SSD1 = dash;
                    SSD2 = two;
                    SSD4 = blank;
                
                end

                else if(scoreB == 1 && scoreA == 3)begin //B-A = 1-3
                
                    SSD0 = one;
                    SSD1 = dash;
                    SSD2 = three;
                    SSD4 = blank;
                
                end

                //WHEN B IS 2 ///////////////////////////////////////////////////

                else if(scoreB == 2 && scoreA == 0)begin //B-A = 2-0
                
                    SSD0 = two;
                    SSD1 = dash;
                    SSD2 = zero;
                    SSD4 = blank;
                
                end

                else if(scoreB == 2 && scoreA == 1)begin //B-A = 2-1
                
                    SSD0 = two;
                    SSD1 = dash;
                    SSD2 = one;
                    SSD4 = blank;
                
                end

                else if(scoreB == 2 && scoreA == 2)begin //B-A = 2-2
                
                    SSD0 = two;
                    SSD1 = dash;
                    SSD2 = two;
                    SSD4 = blank;
                
                end

                else if(scoreB == 2 && scoreA == 3)begin //B-A = 2-3
                
                    SSD0 = two;
                    SSD1 = dash;
                    SSD2 = three;
                    SSD4 = blank;
                
                end

                //WHEN B IS 3 ///////////////////////////////////////////////////

                else if(scoreB == 3 && scoreA == 0)begin //B-A = 3-0
                
                    SSD0 = three;
                    SSD1 = dash;
                    SSD2 = zero;
                    SSD4 = blank;
                
                end

                else if(scoreB == 3 && scoreA == 1)begin //B-A = 3-1
                
                    SSD0 = three;
                    SSD1 = dash;
                    SSD2 = one;
                    SSD4 = blank;
                
                end

                else if(scoreB == 3 && scoreA == 2)begin //B-A = 3-2
                
                    SSD0 = three;
                    SSD1 = dash;
                    SSD2 = two;
                    SSD4 = blank;
                
                end

                else if(scoreB == 3 && scoreA == 3)begin //B-A = 3-3
                
                    SSD0 = three;
                    SSD1 = dash;
                    SSD2 = three;
                    SSD4 = blank;
                
                end

                else begin //NEW PART*****************
                    
                    SSD0 = blank;
                    SSD1 = blank;
                    SSD2 = blank;
                    SSD4 = blank;

                end
                
            end

            TheEnd: begin
            
                if(scoreA == 3)begin

                    if(scoreB == 0)begin
                    
                        SSD0 = zero;

                        SSD1 = dash;

                        SSD2 = three;
                        
                        SSD4 = a;
                
                    end
                    
                    else if(scoreB == 1)begin
                    
                        SSD0 = one;

                        SSD1 = dash;

                        SSD2 = three;
                            
                        SSD4 = a;
                    
                    end
                    
                    else if(scoreB == 2)begin
                
                        SSD0 = two;

                        SSD1 = dash;

                        SSD2 = three;
                        
                        SSD4 = a;
                
                    end

                    else begin//NEW PART****************
                    
                        SSD0 = blank;
                        SSD1 = blank;
                        SSD2 = blank;
                        SSD4 = blank;
        
                    end
            
                end

                else if(scoreB == 3)begin
             
                    if(scoreA == 0)begin
                    
                        SSD0 = three;
    
                        SSD1 = dash;
    
                        SSD2 = zero;
                                
                        SSD4 = b;
                        
                    end
                            
                    else if(scoreA == 1)begin
                        
                        SSD0 = three;
    
                        SSD1 = dash;
    
                        SSD2 = one;
                                
                        SSD4 = b;
                        
                    end
                            
                    else if(scoreA == 2)begin
                        
                        SSD0 = three;
    
                        SSD1 = dash;
    
                        SSD2 = two;
                                
                        SSD4 = b;
                                
                    end

                    else begin //NEW PART***************
                    
                        SSD0 = blank;
                        SSD1 = blank;
                        SSD2 = blank;
                        SSD4 = blank; 

                    end
                 
                end

                else begin //NEW PART******************
                    
                    SSD0 = blank;
                    SSD1 = blank;
                    SSD2 = blank;
                    SSD4 = blank;

                end
                
            end

            default: begin
                
                SSD2 = blank;
                SSD1 = blank;
                SSD0 = blank;
                
                SSD3 = blank;
                SSD4 = blank;
                SSD5 = blank;
                SSD6 = blank;
                SSD7 = blank; //NEW PART***************************

            end

        endcase
  
    end
    
    //for LEDs
    always @ (*) begin
    
                LEDX = ledoff;
                
                LEDA = offa;
                LEDB = offb;
    
        case (states)

            IDLE: begin
            
                LEDA = lighta;
                LEDB = lightb;
                
                LEDX = ledoff;

            end

            DISP: begin
            
                LEDX = ledall;
                LEDA = offa;
                LEDB = offb;
                
            end

            HIT_B: begin
            
                LEDA = offa;
                LEDB = lightb;
                LEDX = ledoff;
                
            end

            HIT_A: begin
            
                LEDA = lighta;
                LEDB = offb;
                LEDX = ledoff;
            
            end

            SEND_A: begin
            
                LEDA = offa;
                LEDB = offb;
                LEDX = ledoff;
                
                if (X_COORD == 0)begin
                
                    LEDX = left5;
                
                end

                else if(X_COORD == 1)begin
                        
                    LEDX = ledoff;
                    LEDX = left4;
                
                end

                else if(X_COORD == 2)begin
                
                    LEDX = ledoff;
                    LEDX = left3;
                        
                end

                else if(X_COORD == 3)begin
                
                    LEDX = ledoff;
                    LEDX = left2;
                        
                end

                else if(X_COORD == 4)begin
                
                    LEDX = ledoff;
                    LEDX = left1;
                        
                end   
                
                else begin //NEW PART************
                    
                    LEDX = ledoff;

                end

            end

            SEND_B: begin
            
                LEDA = offa;
                LEDB = offb;
                LEDX = ledoff;
                
                if (X_COORD == 0)begin
                
                    LEDX = left5;
                
                end

                else if(X_COORD == 1)begin
                        
                    LEDX = ledoff;
                    LEDX = left4;
                
                end

                else if(X_COORD == 2)begin
                
                    LEDX = ledoff;
                    LEDX = left3;
                        
                end

                else if(X_COORD == 3)begin
                
                    LEDX = ledoff;
                    LEDX = left2;
                        
                end

                else if(X_COORD == 4)begin
                
                    LEDX = ledoff;
                    LEDX = left1;
                        
                end 

                else begin//NEW PART*************
                    
                    LEDX = ledoff;

                end
               
            end

            RESP_A: begin
                
                LEDX = ledoff;
                LEDX = left5;
                LEDA = lighta;
                
            end

            RESP_B: begin
            
                LEDX = ledoff;
                LEDX = left1;
                LEDB = lightb;
                
            end

            GOAL_A: begin
            
                LEDX = ledoff;
                LEDX = ledall;
                
            end

            GOAL_B: begin
            
                LEDX = ledoff;
                LEDX = ledall;
                
            end

            TheEnd: begin
            
                LEDA = offa;
                LEDB = offb;
            
                if(counter < timer50)begin
                
                    LEDX = ledoff;
               
                    LEDX = light3;
                    
                end
                    
                else if(counter > timer50 && counter < timer)begin
                
                    LEDX = ledoff;
               
                    LEDX = light2;
             
                end

                else begin//NEW PART*************
                    
                    LEDX = ledoff;

                end
               
            end

            default: begin //NEW PART****************
                
                LEDX = ledoff;
                
                LEDA = offa;
                LEDB = offb;

            end
            
        endcase
        
    end
    
endmodule