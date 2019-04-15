function [dilation] = dilation_matlab_kernel_2(c, t, NO_Mult, stim_duration, NO_sens, basalGC, Hz, radius)
HOME = pwd;
cd('C:\Users\wdh130\Documents\NO-Modeling-Data')

delay = 6; %kernel size

if t <= 0
    try
        delete NO_history_temp.csv
    catch 
    end
else
%dlmwrite('NO_history.csv',[time concentration],'precision','%.4f');
end

dlmwrite('NO_history_temp.csv',[t c],'-append','precision','%.4f');

if (t-delay)<=0
    dilation = 0;
else
    A = 6.5; %doesn't matter
    a1 = 8.91;
    b1 = 3.7;

    x = linspace(0,delay,length([-delay:0.01:0]));
    
    kernel_g = A.*((x).^(a1-1).*b1.^(a1).*exp(-b1.*(x))./gamma(a1));
    kernel = kernel_g/sum(kernel_g);
    
    NOh = csvread('NO_history_temp.csv');
    [a, unique_index] = unique(NOh(:,1));
    time = NOh(unique_index,1);
    concentration = NOh(unique_index,2)
    
    concentration_interp = interp1(time',concentration',t + [-delay:0.01:0],'linear','extrap');
    past_c = sum(concentration_interp.*flip(kernel));
    GC_activation = 100/((10^0.95/past_c)^0.8+1);
    GC_activation_baseline = 100/((10^0.95/NOh(1,2))^0.8+1);
    dilation = GC_activation - GC_activation_baseline;
    
if abs(dilation*NO_sens) <= 10^-7
    dilation = 0
else
    dilation = round(dilation*NO_sens,6)
end

end

fileID = fopen([num2str(NO_Mult) 'NO_' num2str(stim_duration) 'NOd_' num2str(NO_sens) 'NOsens_' num2str(basalGC) 'bGC_' num2str(Hz) 'Hz_' num2str(round(radius*2,1)) 'VD_' '6sNOkernel_v2.csv'],'a');
fprintf(fileID,'%f %f %f\n',[t c dilation]);
fclose(fileID);
cd(HOME)
end
