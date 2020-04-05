clear;

%ファイルの読み込み
filename = '14_34_20check.txt';
data = readmatrix(filename,'NumHeaderLines',1,'Delimiter','\t'); %筋電データ
filename = '14_34_20para.txt'; 
paradt = readmatrix(filename,'Delimiter','\t'); %各パラメータ
t = data(1:end,1);          %時間
t_max = data(end,1);        %測定時間
ch1 = data(1:end,2);
ch2 = data(1:end,3);
ch3 = data(1:end,4);
ch4 = data(1:end,5);
fs = paradt(2,2);           %サンプリング周波数
ch1_offset = paradt(3,2);   %ch1のオフセット
ch2_offset = paradt(4,2);   %ch2のオフセット
ch3_offset = paradt(5,2);   %ch3のオフセット
ch4_offset = paradt(6,2);   %ch4のオフセット
ch1_max = max(ch1);
ch2_max = max(ch2);
ch3_max = max(ch3);
ch4_max = max(ch4);
f = t / t_max * fs;         %周波数
deg = 2;                    %フィルタの次数
fc_low = 1.5;               %バンドパスフィルタの低域カットオフ周波数
fc_high = 100;              %バンドパスフィルタの高域カットオフ周波数
fc_low2 = 1;                %ローパスフィルタのカットオフ周波数


%測定データのグラフ出力
figure;
subplot(2,2,1);
plot(t,ch1);
xlabel('Time t[s]');
title('CH1');
subplot(2,2,2);
plot(t,ch2);
xlabel('Time t[s]');
title('CH2');
subplot(2,2,3);
plot(t,ch3);
xlabel('Time t[s]');
title('CH3');
subplot(2,2,4);
plot(t,ch4);
xlabel('Time t[s]');
title('CH4');

%各データのFFT
ch1_fft = abs(fft(ch1));
ch2_fft = abs(fft(ch2));
ch3_fft = abs(fft(ch3));
ch4_fft = abs(fft(ch4));

subplot(2,2,1);
plot(f,ch1_fft);
xlabel('Frequency f[Hz]');
title('CH1');
subplot(2,2,2);
plot(f,ch2_fft);
xlabel('Frequency f[Hz]');
title('CH2');
subplot(2,2,3);
plot(f,ch3_fft);
xlabel('Frequency f[Hz]');
title('CH3');
subplot(2,2,4);
plot(f,ch4_fft);
xlabel('Frequency f[Hz]');
title('CH4');

%バンドパス(1.5～100Hz)
[b,a] = butter(deg,[fc_low fc_high]/(fs/2),'bandpass');
ch1_band = filter(b,a,ch1);
ch2_band = filter(b,a,ch2);
ch3_band = filter(b,a,ch3);
ch4_band = filter(b,a,ch4);
ch1_fft = abs(fft(ch1_band));
ch2_fft = abs(fft(ch2_band));
ch3_fft = abs(fft(ch3_band));
ch4_fft = abs(fft(ch4_band));

subplot(2,2,1);
plot(f,ch1_fft);
xlabel('Frequency f[Hz]');
title('CH1');
subplot(2,2,2);
plot(f,ch2_fft);
xlabel('Frequency f[Hz]');
title('CH2');
subplot(2,2,3);
plot(f,ch3_fft);
xlabel('Frequency f[Hz]');
title('CH3');
subplot(2,2,4);
plot(f,ch4_fft);
xlabel('Frequency f[Hz]');
title('CH4');

%全波整流
ch1_abs = abs(ch1);
ch2_abs = abs(ch2);
ch3_abs = abs(ch3);
ch4_abs = abs(ch4);

subplot(2,2,1);
plot(t,ch1_abs);
xlabel('Time t[s]');
title('CH1');
subplot(2,2,2);
plot(t,ch2_abs);
xlabel('Time t[s]');
title('CH2');
subplot(2,2,3);
plot(t,ch3_abs);
xlabel('Time t[s]');
title('CH3');
subplot(2,2,4);
plot(t,ch4_abs);
xlabel('Time t[s]');
title('CH4');
sgtitle('全波整流');

%ローパス(1Hz)
[b, a] = butter(deg, fc_low2/(fs/2));
ch1_low = filter(b,a,ch1_abs);
ch2_low = filter(b,a,ch2_abs);
ch3_low = filter(b,a,ch3_abs);
ch4_low = filter(b,a,ch4_abs);

%オフセット除去
ch1 = ch1_low - ch1_offset;
ch2 = ch2_low - ch2_offset;
ch3 = ch3_low - ch3_offset;
ch4 = ch4_low - ch4_offset;

subplot(2,2,1);
plot(t,ch1);
ylim([0,Inf]);
xlabel('Time t[s]');
title('CH1');
subplot(2,2,2);
plot(t,ch2);
ylim([0,Inf]);
xlabel('Time t[s]');
title('CH2');
subplot(2,2,3);
plot(t,ch3);
ylim([0,Inf]);
xlabel('Time t[s]');
title('CH3');
subplot(2,2,4);
plot(t,ch4);
ylim([0,Inf]);
xlabel('Time t[s]');
title('CH4');
sgtitle('オフセット除去');

%正規化
ch1 = ch1 / ch1_max;
ch2 = ch2 / ch2_max;
ch3 = ch3 / ch3_max;
ch4 = ch4 / ch4_max;

figure;
subplot(2,2,1);
plot(t,ch1);
ylim([0,Inf]);
xlabel('Time t[s]');
title('CH1');
subplot(2,2,2);
plot(t,ch2);
ylim([0,Inf]);
xlabel('Time t[s]');
title('CH2');
subplot(2,2,3);
plot(t,ch3);
ylim([0,Inf]);
xlabel('Time t[s]');
title('CH3');
subplot(2,2,4);
plot(t,ch4);
ylim([0,Inf]);
xlabel('Time t[s]');
title('CH4');
sgtitle('正規化');