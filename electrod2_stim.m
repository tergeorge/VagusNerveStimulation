function [V_tot] = electrod2_stim(I_stim,ipi,pulse_width,dur,dt)

    

    %%%%Region 2 neurons - have varying distances from the electrode
    %%%%Neurons have larger diameter and difficult to stimulate require
    %%%%higher I_stimulus
    %%%Final AP is the addition of AP's from three neurons

    I = I_input(I_stim,dur,dt,ipi,pulse_width);

    %%%Neuron 1
    z = 0.1;%%cm
    del_x = 0.1; %%cm
    dia = 0.0001; %%%cm
    %figure();plot(I);
    [V_tot1,I_ionic1] = stimulate_neuron(z, del_x, I,dia,dur,dt);

    %%%%Neuron 2
    z = 0.2;%%cm
    del_x = 0.1; %%cm
    dia = 0.0001; %%%cm
    %figure();plot(I);
    [V_tot2,I_ionic2] = stimulate_neuron(z, del_x, I,dia,dur,dt);

    %%%%Neuron 3
    z = 0.3;%%cm
    del_x = 0.1; %%cm
    dia = 0.0001; %%%cm
    %figure();plot(I);
    [V_tot3,I_ionic3] = stimulate_neuron(z, del_x, I,dia,dur,dt);

    V_tot = V_tot1 + V_tot2+V_tot3;

end