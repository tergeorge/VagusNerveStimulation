function [a_m] = a_m(V)
    
    a_m = 0.1.*(V+40)./(1-exp(-(V+40)/10));


end
