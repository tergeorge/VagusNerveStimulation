%%%%%Stimulation current pulse generation function
%%%%I_stim - Stimulus amplitude
%%%%ipi - inter pulse interval
%%%%pulse_width - pulse_width
function [I] = I_input(I_stim,dur,dt,ipi,pulse_width)
    
    %I_stim = -400; %%uA
    t_stim = (0:dt:dur);
    I = zeros(size(t_stim,2),1);
    st_pt = 1000;
    I(st_pt:st_pt+pulse_width) = I_stim;
    I(st_pt+pulse_width+ipi:st_pt+2*pulse_width+ipi) = -I_stim;
    
end

