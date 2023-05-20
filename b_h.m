function [b_h] = b_h(V)
    
    b_h = 1./(1+exp(-(V+35)/10));


end
