% %% Problem 1 Edge detection

clear
clc
close all


%% can detect rice grains

noise = [0:0.1:1];
for ii = 1:length(noise)

I1 = imread('rice.png');
I1_noise = I1+uint8(rand(size(I1)).*256.*noise(ii));
I2 = adapthisteq(I1_noise);
I3 = wiener2(I2,[5 5]); 
bw1 = im2bw(I3, graythresh(I3));
% bw2 = imfill(bw1, 'holes');
% bw3 = imopen(bw2, strel('disk',2));
% bw4 = bwareaopen(bw3, 100); 
bw4_perim = bwperim(bw1);
[rice_image{ii}, num] = bwlabel(bw4_perim);

rice_count(ii) = num;
end

figure(100), plot(noise,rice_count,'k')
xlabel('fraction of noise')
ylabel('number of rice grains detected')

figure
for ii = 1:9
   subplot(3,3,ii) 
    imshow(rice_image{ii})
    title(['original: noise = ' num2str(noise(ii)*100) '%'])
end

%% improve with imfill, imopen, bwareopen

noise = [0:0.1:1];
for ii = 1:length(noise)

I1 = imread('rice.png');
I1_noise = I1+uint8(rand(size(I1)).*256.*noise(ii));
%I1_noise = medfilt2(I1_noise);
I2 = adapthisteq(I1_noise);
I3 = wiener2(I2,[5 5]); 
bw1 = im2bw(I3, graythresh(I3));
bw2 = imfill(bw1, 'holes');
bw3 = imopen(bw2, strel('disk',2));
bw4 = bwareaopen(bw3, 100); 
bw4_perim = bwperim(bw4);
[rice_image2{ii}, num] = bwlabel(bw4_perim);
rice_count(ii) = num;
end
figure(100), hold on, plot(noise,rice_count,'r')

figure
for ii = 1:9
   subplot(3,3,ii) 
    imshow(rice_image2{ii})
    title(['fill/open: noise = ' num2str(noise(ii)*100) '%'])
end

%% improve further with median filter


noise = [0:0.1:1];
for ii = 1:length(noise)

I1 = imread('rice.png');
I1_noise = I1+uint8(rand(size(I1)).*256.*noise(ii));
I1_noise = medfilt2(I1_noise);
I2 = adapthisteq(I1_noise);
I3 = wiener2(I2,[5 5]); 
bw1 = im2bw(I3, graythresh(I3));
bw2 = imfill(bw1, 'holes');
bw3 = imopen(bw2, strel('disk',2));
bw4 = bwareaopen(bw3, 100); 
bw4_perim = bwperim(bw4);
[rice_image2{ii}, num] = bwlabel(bw4_perim);
rice_count(ii) = num;
end
figure(100), hold on, plot(noise,rice_count,'m')
legend('original','imfill/bwopen/bwareopen','imfill/bwopen/bwareopen + median filter')
set(gca,'YScale','log')

figure
for ii = 1:9
   subplot(3,3,ii) 
    imshow(rice_image2{ii})
    title(['median: noise = ' num2str(noise(ii)*100) '%'])
end

%%
for noise = [0];

I1 = imread('rice.png');
I1_noise = I1+uint8(rand(size(I1)).*256.*noise);
I2 = adapthisteq(I1_noise);
I3 = wiener2(I2,[5 5]); 
bw1 = im2bw(I3, graythresh(I3));
bw2 = imfill(bw1, 'holes');
bw3 = imopen(bw2, strel('disk',2));
bw4 = bwareaopen(bw3, 100); 
bw4_perim = bwperim(bw4);
[L, num] = bwlabel(bw4_perim);

image_index = {I1, I1_noise ,I2, I3, bw1, bw2, bw3, bw4, L};
title_index = {'Original','Noise','Remove Background','Remove Noise','Black & White','fill in holes','fill in indents','remove small objects',['count = ' num2str(num)]};
figure
for ii = 1:9
   subplot(3,3,ii)
   imshow(image_index{ii})
   title(title_index{ii})
end
end

