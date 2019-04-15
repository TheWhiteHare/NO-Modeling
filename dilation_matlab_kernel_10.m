function [dilation] = dilation_matlab_kernel_10(c, t, NO_Mult, stim_duration, NO_sens, basalGC, Hz, radius,pfHgb,Hct)
% HOME = pwd;
cd('C:\Users\wdh130\Documents\NO-Modeling-Data\Vasomotion')

delay = 6; %kernel size
% delay = 15; %kernel size

if t <= 0
    try
        delete NO_history_temp3.csv
    catch 
    end
else
%dlmwrite('NO_history.csv',[time concentration],'precision','%.4f');
end

dlmwrite('NO_history_temp3.csv',[t c],'-append','precision','%.4f');

if (t-delay)<=0
    dilation = 0;
else
    A = 6.5; %doesn't matter
    a1 = 8.91;
    b1 = 3.7;
     
%     A = 6.5; %doesn't matter
%     a1 = 6;
%     b1 = 1.2;

    x = linspace(0,delay,length([-delay:0.01:0]));
    
    kernel_g = A.*((x).^(a1-1).*b1.^(a1).*exp(-b1.*(x))./gamma(a1));
    kernel = kernel_g/sum(kernel_g);
    
    
    NOh = csvread('NO_history_temp3.csv');
    [a, unique_index] = unique(NOh(:,1));
    time = NOh(unique_index,1);
    concentration = NOh(unique_index,2)
    
    concentration_interp = interp1(time',concentration',t + [-delay:0.01:0],'linear','extrap');
    past_c = sum(concentration_interp.*flip(kernel));
    GC_activation = 100/((10^0.95/past_c)^0.8+1);
    GC_activation_baseline = 100/((10^0.95/NOh(1,2))^0.8+1);
    dilation = GC_activation - GC_activation_baseline;
 
% %    
% K = GC_activation_baseline;
% alpha = NO_sens;    
% GC = [0:0.01:100];
% NO_sens_Hill_hold = diff(100*(GC.^alpha)./(K^alpha+GC.^alpha))./0.01; %Hill equation for non-linear relationship between GC activity and vasodilation
% NO_sens_Hill = @(GC_state) interp1(GC(2:end)-0.005,NO_sens_Hill_hold,GC_state);   
% %
    
% if abs(dilation*NO_sens) <= 10^-8
%     dilation = 0
% else
%     dilation = round(dilation*NO_sens,8)
% end


% if t > (delay)
%         ExtraSignal = 19.25*((t-(delay)).^(a1-1).*b1.^(a1).*exp(-b1.*(t-(delay)))./gamma(a1))
%         dilation = dilation + ExtraSignal*2;
% else
% end


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
% -eNOS*test(c)*2*pi*r
% -test(c)*nNOS_per*2*pi*r*(1+(rect2(t/tn)*(NO_Mult-1)))
end
dilation = 30 + round(dilation*NO_sens,6); %negative dilations could cut into the static RBC core so add a small dilation - causes simulation to be run on a 21um vessel instead of a 20um vessel

fileID = fopen([num2str(NO_Mult) 'NO_' num2str(stim_duration) 'NOd_' num2str(NO_sens) 'NOsens_' num2str(basalGC) 'bGC_' num2str(Hz) 'Hz_' num2str(round(radius*2,1)) 'VD_' '6sNOkernel_GammaWith' num2str(pfHgb) 'Hgb_' num2str(round(Hct*100)) '_Hct_RawGamma_dynamic_v24.csv'],'a');
%fileID = fopen([num2str(NO_Mult) 'NO_' num2str(stim_duration) 'NOd_' num2str(NO_sens) 'NOsens_' num2str(basalGC) 'bGC_' num2str(Hz) 'Hz_' num2str(round(radius*2,1)) 'VD_' '6sNOkernel_GammaWith35lowSCD.csv'],'a');
%fileID = fopen([num2str(NO_Mult) 'NO_' num2str(stim_duration) 'NOd_' num2str(NO_sens) 'NOsens_' num2str(basalGC) 'bGC_' num2str(Hz) 'Hz_' num2str(round(radius*2,1)) 'VD_' '6sNOkernel_ExtraPulseNorm60Hgb.csv'],'a');
%fileID = fopen([num2str(NO_Mult) 'NO_' num2str(stim_duration) 'NOd_' num2str(NO_sens) 'NOsens_' num2str(basalGC) 'bGC_' num2str(Hz) 'Hz_' num2str(round(radius*2,1)) 'VD_' '6sNOkernel_GammaBand.csv'],'a');
fprintf(fileID,'%f %f %f\n',[t c dilation]);
fclose(fileID);
% cd(HOME)
end
