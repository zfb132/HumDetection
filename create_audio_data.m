function [yinResult,result,speed]=create_audio_data(y,fs,T,hobject)
y=resample(y,8000,fs);
fs=8000;
snd=y;
[time_yin, yinResult] = yin_estimator(snd',fs, 'use_classification');
%[time_ceps, f0_est_ceps] = cepstrum(snd',fs, 'use_classification');
%[time_ml, f0_est_ml] = max_likelihood(snd',fs,'use_classification');
temp=yinResult;


% abs(current - min(current:current+100)) < 60 ? 把这100个都置为current
% for i=1:length(f0_est_yin)-100
%     if(abs(f0_est_yin(i)-min(f0_est_yin(i:i+100)))>100)
%         for t=1:100
%             f0_est_yin(i:i+t)=f0_est_yin(i);
%         end
%     end
% end
for i=1:length(yinResult)-1
    if(abs(yinResult(i+1)-yinResult(i))>60)
        yinResult(i+1)=yinResult(i);
    end
end
% figure;
n=linspace(0,T,length(yinResult));
plot(hobject,n, yinResult);grid on;

% title('YIN算法及其改进');xlabel('时间t/s');ylabel('频率f/Hz');
%figure;
% plot(time_yin, temp);grid on;hold on;%蓝色
% title('YIN算法及其改进');xlabel('时间t/s');ylabel('频率f/Hz');
% plot(time_yin, yinResult,'--');grid on;hold on;%蓝色
% legend('YIN基音检测算法','平滑处理的基音算法');
% line([0,11],[371,371]);
% line([0,11],[340,340]);

% index存储每个点属于哪个音
% index(2,1)是指第二个音（即re）在语音中的出现的第一次的位置


% index=0;
% count=zeros(1,7);
% for i = 1:length(yinResult)-1
%     offset=yinResult(i)-246;
%     if(offset>0&&offset<=32)
%         count(1)=count(1)+1;
%         index(1,count(1))=i;
%     else
%         if(offset>32&&offset<=66)
%             count(2)=count(2)+1;
%             index(2,count(2))=i;
%         else
%             if(offset>66&&offset<=98)
%                 count(3)=count(3)+1;
%                 index(3,count(3))=i;
%             else
%                 if(offset>98&&offset<=125)
%                     count(4)=count(4)+1;
%                     index(4,count(4))=i;
%                 else
%                     if(offset>125&&offset<=170)
%                         count(5)=count(5)+1;
%                         index(5,count(5))=i;
%                     else
%                         if(offset>170&&offset<=221)
%                             count(6)=count(6)+1;
%                             index(6,count(6))=i;  
%                         else
%                             if(offset>221&&offset<=275)
%                                 count(7)=count(7)+1;
%                                 index(7,count(7))=i;  
%                             end
%                         end
%                     end
%                 end
%             end
%         end
%     end
% end
% disp('1');
% len=zeros(7);
% seg=0;
% % seg(2,1)就是第二个音的第一段的开始索引
% % 如index(2,:)内容为：2000,2001，...,3998,7880,7881,7882，...，9784;
% % 那么seg(2,1)即为1，index(2,:)中的第seg(2,2)个数即为7880
% for i=1:7
%     countf=0;
%     len=length(find(index(i,:)>0));
%     % 说明这个音存在
%     if(len>=10)
%         seg(i,1)=1;
%         for t=1:len-1
%             if(index(i,t+1)-index(i,t)>1)
%                 % 说明两段之间不连续，伺候的数据会保持此状况
%                 countf=countf+1;
%                 %记录下一段的开始位置
%                 seg(i,countf)=t+1;
%             end
%         end
%     end
% end
% % seglen用来记录每个音的长度
% % seglen(2,1)是指在前面seg(2,1)的基础上，因为seg(2,1)存的是在index(2,:)中的索引
% % seglen(2,1)存的是每一小段的长度，与seg对应
% seglen=zeros(7,length(seg(1,:)));
% for i=1:7
%     % 当此音有数据时（至少有一段）
%     if(seg(i,1)~=0)
%         m=length(find(seg(i,:)>0));
%         % 当长度为1时直接下一个i
%         if(m==1)
%             seglen(i,1)=length(find(index(i,:)>0));
%             continue;
%         end
%         % 前m-1段的长度
%         for t=1:m-1
%             seglen(i,t)=seg(i,t+1)-seg(i,t);
%         end
%         % 最后一段的长度等于index(i,:)的长度减去前几个的长度
%         seglen(i,m)=length(find(index(i,:)>0))-sum(seglen(i,1:m-1));
%     end
% end
% % 结果返回：第一列存放
% % 认为只有一个
% % for i=1:length(find(seg))
% % do=[seg(1,:);seglen(1,:)];
% % re=[seg(2,:);seglen(2,:)];
% % mi=[seg(3,:);seglen(3,:)];
% % fa=[seg(4,:);seglen(4,:)];
% % so=[seg(5,:);seglen(5,:)];
% % la=[seg(6,:);seglen(6,:)];
% % xi=[seg(7,:);seglen(7,:)];
% if(index(1,seg(1,1))>index(2,seg(2,1))&&index(1,seg(1,1))>index(3,seg(3,1))...
%     &&index(1,seg(1,1))>index(4,seg(4,1))&&index(1,seg(1,1))>index(5,seg(5,1))...
%     &&index(1,seg(1,1))>index(6,seg(6,1)))&&index(1,seg(1,1))>index(7,seg(7,1))
% 
% end
result=[1,2,3,4,5,6,7];speed=1;

% f0_est_yin=temp;
% [psor,lsor] = findpeaks(f0_est_yin,time_yin,'MinPeakDistance',0.2,'MinPeakHeight',40);
% [psor1,lsor1] = findpeaks(-f0_est_yin,time_yin,'MinPeakDistance',0.2);
% for i=1:length(lsor)
%     index=lsor(i);
%     f0_est_yin(index)=f0_est_yin(index-1);
% end
% plot(lsor,psor,'*','color','R');    plot(lsor1,-psor1,'*','color','R'); 



%[data,index]=max(psor);
%plot(lsor(index),f0_est_yin(lsor(index)),'*','color','R');     
%plot(time_ceps, f0_est_ceps);grid on; hold on;%红色
%plot(time_ml, f0_est_ml);grid on;hold on;%橙色



% %matlab script to combine n audio files together
% 
% close all, clc;
% 
% parentpath = fileparts(pwd);
% soundpath = strcat(parentpath,'/Cello.arco.ff.sulC.stereo/');
% 
% filename = 'Cello.arco.ff.sulC.';
% sound = {'A3.stereo.aif', 'C3.stereo.aif','D3.stereo.aif','Gb2.stereo.aif'};
% 
% snd = [];
% len = [];
% for n = 1:length(sound)
%     [x,fs] = audioread(strcat(soundpath, filename, sound{n}));
%     len(n) = length(x);
%     snd = [snd;x(:,1)];
% end
% 
% f = [220*ones(1,len(1)), 130.81 * ones(1,len(2)), 146.83 * ones(1,len(3)), 92.5 * ones(1,len(4))];
% 
% %check which parts are silent
% flength = round(0.025*fs);
% nframes = ceil(length(snd)/flength);
% snd = [snd; zeros(nframes*flength - length(snd), 1)];
% f = [f, zeros(1,nframes*flength - length(f))];
% f0 = zeros(nframes,flength);
% snd_frames = zeros(nframes, flength);
% start = 1;
% 
% for i = 1:nframes
%     snd_frames(i,:) = snd(start:start + flength - 1);
%     f0(i,:) = f(start) * ones(1,flength);
%     start = start+flength;
% end
% f0 = silent_frame_classification(snd_frames,f0);
% f0 = reshape(f0',1,nframes*flength);
% 
%      
% %create ground truth labels
% t = (0:length(snd)-1)/fs;
% %add noise of a particular snr to signal
% snr = 5;
% noise = (mean(abs(snd)))*(10^(-snr/20)) * 0.1*randn(1,length(t))';
% %snd = snd + noise;
% %soundsc(snd, fs);
% 
% 
% [time_yin, f0_est_yin] = yin_estimator(snd',fs, 'use_classification');
% [time_ceps, f0_est_ceps] = cepstrum(snd',fs, 'use_classification');
% [time_ml, f0_est_ml] = max_likelihood(snd',fs,'use_classification');
% 
% figure;
% plot(time_yin, f0_est_yin);grid on;hold on;
% plot(time_ceps, f0_est_ceps);grid on; hold on;
% plot(time_ml, f0_est_ml);grid on;hold on;
% plot((0:length(f0)-1)/fs, f0);grid on; hold off;
% axis([0 length(snd)/fs 0 1000]);
% xlabel('time in seconds');ylabel('Frequency in Hz');
% legend('Estimated f0 - yin','Estimated f0 - cepstrum','Estimated f0 - max likelihood','Ground truth');
end
