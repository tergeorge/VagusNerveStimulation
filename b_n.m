function [b_n] = b_n(V)
    
    b_n = 0.125.*exp(-(V+65)/80);


end

