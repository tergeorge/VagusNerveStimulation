%%%%%Stimulates a single neuron with given parameters
%%%z - Distane from the electrode
%%%del_x - length of nodes of ranvier
%%% I - Stimulation current
%%%dia - diameter of the axon - varying for different neurons
%%%%dur - duation of simulation of neuron
%%%%dt - intervals
function [V_tot,I_ionic] = stimulate_neuron(z, del_x, I,dia,dur,dt)

    no_nodes = 101;
    nodes = [1:no_nodes];
    mid_pt = ((no_nodes-1)/2)+1;
    L = 0.00025; %%cm
    rho_e  = 0.3; %%ohm cm
    rho_i = 0.055; %%%ohm cm
    %dt = 0.001; %%microsecs

    %%%%Generating Ve for all nodes
    x_nodes = zeros(1,no_nodes);
    x_nodes(nodes(mid_pt:end)) = (nodes(mid_pt:end)-mid_pt) * del_x;
    x_nodes(nodes(1:mid_pt)) = -(mid_pt - nodes(1:mid_pt)) * del_x;
    x_nodes(mid_pt) = 0;

    r_nodes = sqrt(x_nodes.^2 + z^2);

    Ve_nodes = (rho_e/(4*pi)).*I./r_nodes;
    %figure();plot(Ve_nodes(1058,:));
    
    gl_bar = 3;
    gk_bar = 360;
    gna_bar = 1200;
    cm =1;
    dia_const = (dia * del_x)/(4*rho_i*L);
    
    %%%%Calling HH-Rattay model
   [V_tot,I_ionic,time] = HH_rattay(dia_const,cm,del_x,Ve_nodes,dt,dur,gk_bar,gna_bar,gl_bar,I);
end

