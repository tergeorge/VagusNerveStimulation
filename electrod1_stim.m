function [V_tot] = electrod1_stim(I_stim,ipi,pulse_width,dur,dt)

    %%%%Region 1 neurons - have varying distances from the electrode
    %%%%Neruons have larger diameter and are easier to stimulate and have
    %%%%lower stimulus threshold
    %%%Final AP is the addition of AP's from two neurons
    I = I_input(I_stim,dur,dt,ipi,pulse_width);

    %%%Neuron 1
    z = 0.1;%%cm
    del_x = 0.1; %%cm
    dia = 0.001; %%%cm
    %figure();plot(I);
    [V_tot1,I_ionic1] = stimulate_neuron(z, del_x, I,dia,dur,dt);

    %%%%Neuron 2
    z = 0.2;%%cm
    del_x = 0.1; %%cm
    dia = 0.001; %%%cm
    %figure();plot(I);
    [V_tot2,I_ionic2] = stimulate_neuron(z, del_x, I,dia,dur,dt);

    V_tot = V_tot1 + V_tot2;

end

