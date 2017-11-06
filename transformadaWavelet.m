clear all;close all;clc 
[M,N,imagen, archivo,directorio]=abrir_imagen; 
imagenGris = rgb2gray(imagen); % Convierte a niveles de gris (uint8) da un valor entre 0 y 256 

b=double(imagenGris); 
b=b/max(max(b)); 

imshow(b);title('Imagen Original') ; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%% PRIMERA ETAPA DEL FILTRO WAVELET%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%filtros de la familia de DEUBECHIES 
%Daubechies: 'db1' or 'haar', 'db2', ... ,'db45' 
[h1,h2] = wfilters('db1','d') 


%convoluciono los coeficientes del filtro con la matriz de la imagen 
bh1=filter2(h1,b); %Filtro permite suabizar la Image 
bh2=filter2(h2,b); %filtro permite resaltar los bordes 
figure; 
subplot(1,2,1); imshow(bh1/max(max(bh1)));title('Filtro Pasa Bajo');%fitro pasa baja 
subplot(1,2,2); imshow(bh2+0.5);title('Filtro Pasa Alto');%fitro pasa baja 

%%%%%%%%%%%%%%%%%%%%%% SEGUNDA ETAPA DEL FILTRO WAVELET%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
figure; 
[F C]=size(bh1)%dimension de la imagen 
bh1m=bh1(:,1:2:C);% aplicamos Down sampler por colunna a la imagen del filtro pasa bajo 
bh2m=bh2(:,1:2:C);% aplicamos Down sampler por colunna a la imagen del filtro pasa Alto 

subplot(1,2,1); imshow(bh1m/max(max(bh1m))); title(' Down sampler coluna imagen FPB '); 
subplot(1,2,2); imshow(bh2m+0.5);title(' Down sampler coluna imagen FPA '); 

%Tenemos dos imagenes filtro PB y PA, y cada una con el Down Sampler, se 
%le aplica a cada una el filtro 

bh1mh1=filter2(h1',bh1m); % Imagen FPB se le aplica FPB, gemerando una nueva imagen FPB 
bh1mh2=filter2(h2',bh1m); % Imagen FPB se le aplica FPA, gemerando una nueva imagen FPA 
bh2mh1=filter2(h1',bh2m); % Imagen FPA se le aplica FPB, gemerando una nueva imagen FPB 
bh2mh2=filter2(h2',bh2m); % Imagen FPA se le aplica FPA, gemerando una nueva imagen FPA 

bLL=bh1mh1(1:2:F,:);% aplicamos Down sampler por fila a la imagen del filtro PB 
bLH=bh1mh2(1:2:F,:);% aplicamos Down sampler por fila a la imagen del filtro PA 
bHL=bh2mh1(1:2:F,:);% aplicamos Down sampler por fila a la imagen del filtro pasa bajo 
bHH=bh2mh2(1:2:F,:);% aplicamos Down sampler por fila a la imagen del filtro pasa bajo 

figure 
subplot(2,2,1);imshow(bLL/max(max(bLL))); title(' LL '); 
subplot(2,2,2);imshow(bLH+0.5); title(' LH '); 
subplot(2,2,3);imshow(bHL+0.5); title(' HL'); 
subplot(2,2,4);imshow(bHH+0.5); title(' HH '); 

%%%%%%%%%%%%%%%%%%%%%% TRANSFORMADA WAVELET INVERSA %%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

[fil col]=size(bLL) 

bLLin=zeros(2*fil,col); 
bLLin(1:2:2*fil,1:col)=bLL; 

bLHin=zeros(2*fil,col); 
bLHin(1:2:2*fil,1:col)=bLH; 

bHLin=zeros(2*fil,col); 
bHLin(1:2:2*fil,1:col)=bHL; 

bHHin=zeros(2*fil,col); 
bHHin(1:2:2*fil,1:col)=bHH; 

figure; 
imshow(bLLin/max(max(bLLin))) 

% h1=[-1/sqrt(2),-1/sqrt(2)]; %filtro pasa bajo(h1: coeficientes del filtro PB) 
h2=[-1/sqrt(2),1/sqrt(2)]; %filtro pasa alto (h2: coeficientes del filtro PA) 

bL1=filter2(h1',bLLin)+filter2(h2',bLHin); 
bH1=filter2(h1',bHLin)+filter2(h2',bHHin); 

bLin=zeros(2*fil,2*col);bLin(1:2*fil,1:2:2*col)=bL1; 
bHin=zeros(2*fil,2*col);bHin(1:2*fil,1:2:2*col)=bH1; 

br=filter2(h1,bLin)+filter2(h2,bHin); 

figure;imshow(br/max(max(br))); 
figure;imshow(abs(b(2:2*fil,2:2*col)-br(1:2*fil-1,1:2*col-1))); 

figure; imhist(b);title('Histograma de la Imagen Original'); 
figure; 
subplot(2,2,1); imhist(bLL/max(max(bLL)));title('Histograma de la Imagen Original'); 
subplot(2,2,2); imhist(bLH+.5);title('Histograma de la Imagen Original'); 
subplot(2,2,3); imhist(bHL+.5);title('Histograma de la Imagen Original'); 
subplot(2,2,4); imhist(bHH+.5);title('Histograma de la Imagen Original'); 

bLHa=round(bLH*10)/10; 
bHLa=round(bHL*10)/10; 
bHHa=round(bHH*10)/10; 
figure; 

subplot(2,2,1); imhist(bLL/max(max(bLL)));title('Histograma de la Imagen Original'); 
subplot(2,2,2); imhist(bLHa+.5);title('Histograma de la Imagen Original'); 
subplot(2,2,3); imhist(bHLa+.5);title('Histograma de la Imagen Original'); 
subplot(2,2,4); imhist(bHHa+.5);title('Histograma de la Imagen Original');