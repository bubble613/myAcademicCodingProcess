xn = [1 1 1 1 ];            		%输入时域序列向量 xn = R4(n)
Xk16 = fft(xn, 16);         		% 计算xn的16点fft
Xk32 = fft(xn, 32);         		% 计算xn的32点fft

% 以下为绘图部分
k = 0 : 15; 
wk = 2*k/16;            			%计算16点DFT对应的采样点频率
subplot(2,2,1);     
stem(wk, abs(Xk16), '.');      		%绘制16点DFT的幅频特性图
title('（a）16点DFT的幅频特性图');  
 xlabel('w/π');    
 ylabel(' 幅度 ');

subplot(2,2,3);     
stem(wk, angle(Xk16), '.');     	%绘制16点DFT的相频特性图
line([0,2], [0,0]);     
title('（b）16点DFT的相频特性图');
xlabel('w/π');    
ylabel(' 相位 ');
axis([0 , 2, -3.5 ,3.5]);

k = 0 : 31; 
wk = 2*k/32;                        %计算32点DFT对应的采样点频率
subplot(2,2,2);     
stem(wk, abs(Xk32), '.');           %绘制32点DFT的幅频特性图
title('（c）32点DFT的幅频特性图');   
xlabel('w/π');    
ylabel(' 幅度 ');

subplot(2,2,4);     
stem(wk, angle(Xk32), '.');     	%绘制32点DFT的相频特性图
line([0,2], [0,0]);     
title('（d）32点DFT的相频特性图');
xlabel('w/π');    
ylabel(' 相位 ');
axis([0 , 2, -3.5 ,3.5]);