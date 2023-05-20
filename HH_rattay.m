%%%%Hodkin huxley -rattay model
function [Vn_t,In_t,time] = HH_rattay(dia_const,cm,del_x,Ve_nodes,dt,dur,gk_bar,gna_bar,gl_bar,I)
    
    %%Setting initial values for HH
    E_k = -77;
    E_na = 50;
    E_l = -54.4;
    V_m = -65;
    no_nodes = size(Ve_nodes,2);
    Vn_in = zeros(1,no_nodes);
    Vn_in(1:end) =V_m;
    V_res = V_m;
    V_in = V_m;
    
    %%%%initial probabilities
    m_in  = a_m(V_in)./(a_m(V_in) + b_m(V_in));
    n_in  = a_n(V_in)./(a_n(V_in) + b_n(V_in));
    h_in  = a_h(V_in)./(a_h(V_in) + b_h(V_in));
    
    V=Vn_in;
    n = n_in;
    m = m_in;
    h = h_in;
    Vn_t = [];
    In_t = [];
    time = [];
    no_sam = dur*1000 +1;
    Ve_b = zeros(no_sam,no_nodes);
    Vi_b = zeros(no_sam,no_nodes);
    m_all = zeros(no_sam,no_nodes);
    m_all(1,:) = m_in;
    n_all = zeros(no_sam,no_nodes);
    n_all(1,:) = m_in;
    h_all = zeros(no_sam,no_nodes);
    h_all(1,:) = m_in;
    tracker = 1;
    for t = 0:dt:dur
        
        
        %%%%HH model Ionic current
        g_na = gna_bar .* h .* (m.^3);
        g_k = gk_bar .* (n.^4);
        g_l = gl_bar;
        
        I_na = g_na .*(V - E_na);%%%
        I_k = g_k.*(V - E_k);
        I_l = g_l.*(V - E_l);


        dn = ((a_n(V).*(1-n)) - (b_n(V).*n)).*dt;
        dm = ((a_m(V).*(1-m)) - (b_m(V).*m)).*dt;
        dh = ((a_h(V).*(1-h)) - (b_h(V).*h)).*dt;

        m = m+dm;
        n = n+dn;
        h = h+dh;
        m_all(tracker+1,:) = m;
        n_all(tracker+1,:) = n;
        h_all(tracker+1,:) = h;
        I_i = I_na + I_k + I_l;
        
        
        %%%%Rattay model for dVn
        
        for i = 2:no_nodes-1
           Vi_b(tracker,i) = (V(i-1) - (2*V(i)) + V(i+1))./(del_x^2);
           Ve_b(tracker,i) =  (Ve_nodes(tracker,i-1) - (2*Ve_nodes(tracker,i)) + Ve_nodes(tracker,i+1))./(del_x^2);            
        end
        dV = dt.*((dia_const*(Vi_b(tracker,:) + Ve_b(tracker,:))) - I_i)./cm;
        V =V+dV;
        Vn_t = [Vn_t;V];
        time = [time;t];
        In_t = [In_t;I_i];
        tracker = tracker +1;

    end
    
end

