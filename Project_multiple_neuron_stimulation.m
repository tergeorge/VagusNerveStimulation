%%%%Stimulation plots for the two regions lectrodes are placed in
no_nodes = 101;
nodes = [1:no_nodes];
mid_pt = ((no_nodes-1)/2)+1;
I_stim = -1000;
dur = 10;
dt = 0.001;
ipi = 100;
pulse_width = 500;
time = (0:dt:dur);
I = I_input(I_stim,dur,dt,ipi,pulse_width);

%%%%Region 1 stimulation an plots
V_tot = electrod1_stim(I_stim,ipi,pulse_width,dur,dt);
figure(1);
plot(time,V_tot(:,(no_nodes-1)/2));
title('Action potential at center node - region 1');
xlabel('Time(ms)');
ylabel('Voltage (mV)');
    
figure(2);
id=[500,1000,1500,2000,2500];
plot(nodes(1:end),V_tot(id,1:end));
title('Propagation of AP across nodes for different timestamps - region 1');
xlabel('dist from central node (cm)');
ylabel('Voltage (mV)');
legend({'500us','1000us','1500us','2000us','2500us'});  

%%%%Region 2 stimulation an plots
V_tot = V_tot = electrod2_stim(I_stim,ipi,pulse_width,dur,dt);
V_tot = electrod1_stim(I_stim,ipi,pulse_width,dur,dt);
figure(1);
plot(time,V_tot(:,(no_nodes-1)/2));
title('Action potential at center node - region 2');
xlabel('Time(ms)');
ylabel('Voltage (mV)');
    
figure(2);
id=[500,1000,1500,2000,2500];
plot(nodes(1:end),V_tot(id,1:end));
title('Propagation of AP across nodes for different timestamps - region 2');
xlabel('dist from central node (cm)');
ylabel('Voltage (mV)');
legend({'500us','1000us','1500us','2000us','2500us'});  
% h = animatedline;
% %axis([0 4*pi -1 1])
% % t = time(1:100);
% % ecg = [];
% % for j = 1:1000
% %     if(rem(j,2))
% %         ec = get_ecg(t,90,100);
% %     else
% %         ec = get_ecg(t,100,90);
% %     end
% %     ecg = [ecg,ec];
% % end
% x = (1:1000);
% for k = 1:length(ecg)
%         y = ecg(:,k);
%         addpoints(h,x(:,k),y);drawnow;axis([x(:,k) x(:,k+100) 0 3]);drawnow;
%     end