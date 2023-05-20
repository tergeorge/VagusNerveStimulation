function [a_n] = a_n(V)
    
    a_n = 0.01*(V+55)./(1-exp(-(V+55)/10));


end

