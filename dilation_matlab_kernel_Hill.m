function [dilation] = dilation_matlab_kernel_4(c, t, NO_Mult, stim_duration, NO_sens, basalGC, Hz, radius)
HOME = pwd;
cd('C:\Users\wdh130\Documents\MATLAB\NOFeedbackData')

delay = 6; %kernel size
% delay = 15; %kernel size

if t <= 0
    try
        delete NO_history_temp2.csv
    catch 
    end
else
%dlmwrite('NO_history.csv',[time concentration],'precision','%.4f');
end

dlmwrite('NO_history_temp2.csv',[t c],'-append','precision','%.4f');

if (t-delay)<=0
    dilation = 0;
else
    A = 6.5; %doesn't matter
    a1 = 8.91;
    b1 = 3.7;
%     
%     A = 6.5; %doesn't matter
%     a1 = 6;
%     b1 = 1.2;

    x = linspace(0,delay,length([-delay:0.01:0]));
    
    kernel_g = A.*((x).^(a1-1).*b1.^(a1).*exp(-b1.*(x))./gamma(a1));
    kernel = kernel_g/sum(kernel_g);
    
    NOh = csvread('NO_history_temp2.csv');
    [a, unique_index] = unique(NOh(:,1));
    time = NOh(unique_index,1);
    concentration = NOh(unique_index,2)
    
    concentration_interp = interp1(time',concentration',t + [-delay:0.01:0],'linear','extrap');
    past_c = sum(concentration_interp.*flip(kernel));
    GC_activation = 100/((10^0.95/past_c)^0.8+1);
    GC_activation_baseline = 100/((10^0.95/NOh(1,2))^0.8+1);

    
K = GC_activation_baseline;
alpha = NO_sens;    
NO_sens_Hill = @(GC) 100*(GC.^alpha)./(K^alpha+GC.^alpha); %Hill equation for non-linear relationship between GC activity and vasodilation
    
dilation = NO_sens_Hill(GC_activation) - 50;

if abs(NO_sens_Hill(GC_activation)-50) <= 10^-8
    dilation = 0
else
    dilation = round(NO_sens_Hill(GC_activation)-50,8)
end

if t > (delay)
    ExtraSignal = 19.25*((t-(delay)).^(a1-1).*b1.^(a1).*exp(-b1.*(t-(delay)))./gamma(a1))
    dilation = dilation + ExtraSignal*1;
else
end

% if t > (delay+9)
%         ExtraSignal = 19.25*((t-(delay+9)).^(a1-1).*b1.^(a1).*exp(-b1.*(t-(delay+9)))./gamma(a1))
%         dilation = dilation + ExtraSignal*2;
% elseif t > (delay)
%         ExtraSignal = 19.25*((t-(delay)).^(a1-1).*b1.^(a1).*exp(-b1.*(t-(delay)))./gamma(a1))
%         dilation = dilation + ExtraSignal*2;
% else
% end

% if t > (delay+basalGC)
% ExtraSignal = 19.25*((t-(delay+basalGC)).^(a1-1).*b1.^(a1).*exp(-b1.*(t-(delay+basalGC)))./gamma(a1))
% dilation = dilation + ExtraSignal*2;
% else
% end


end

fileID = fopen([num2str(NO_Mult) 'NO_' num2str(stim_duration) 'NOd_' num2str(NO_sens) 'NOsens_' num2str(basalGC) 'bGC_' num2str(Hz) 'Hz_' num2str(round(radius*2,1)) 'VD_' '6sNOkernel_SpontaneousOscillations_10D_Hill.csv'],'a');
fprintf(fileID,'%f %f %f\n',[t c dilation]);
fclose(fileID);
cd(HOME)
end
