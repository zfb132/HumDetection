fs=8000;
fs1=[180 220 260 300 340 380];
time1=fs*[1/2 1/2 1/2 1/2 1/2 1/2];
N=length(time1);
y=zeros(1,N);
n=1;
for i=1:N
    t=1/fs:1/fs:time1(i)/fs;
    y(n:n+time1(i)-1)=sin(2*pi*fs1(i)*t);
    n=n+time1(i);
end
sound(y,8000);