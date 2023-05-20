function [a_h] = a_h(V)
    
    a_h = 0.07.*exp(-(V+65)/20);


end

