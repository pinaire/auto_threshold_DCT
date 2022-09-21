
%auto-threshold periodic noise estimation with discrete cosine transform
%by Alex Pinaire

%calculates a DCT frequency threshold to separate signal from noise
%this version was made for a 2d image

tic

%data input
I = imread('pallass.tiff');
I=im2double(I);
[x,y] = size(I);

%add periodic noise
X = linspace(0,1,x);
Y = linspace(0,1,y);
[XX, YY] = meshgrid(Y, X);

c1=32;
c2=10;
noisy1 = I + 0.25*cos(c1*pi*XX);
noisy2 = noisy1 + 0.25*sin(c2*pi*(XX+YY));

%discrete cosign transform of noisy data
trans = dct2(noisy2);
trans = round(trans);

%unique frequencies and counts
frequencies = unique(trans);
for fc = 1:length(frequencies)
    val = frequencies(fc);
    count = sum(trans(:) == val); 
    counts(fc) = count;
end


%considers the upper fraction of frequencies with high counts noise
%threshold estimation with (count combinations)^(1/tf)
tf=4;

%binonimal coefficient or combinations (n=counts, k=2)
N = nchoosek(length(counts),2)/2;
NN=round(N^(1/tf));
frethre = abs(frequencies(NN));%frequency threshold
transfo = trans;

%passing frequencies above threshold
for fcv=1:length(counts)
    fre=abs(frequencies(fcv));
    cou=counts(fcv);

    if fre > frethre
        freqs(fcv)=fre;
        cnts(fcv)=cou;
    end    
end


for fcv=1:length(counts)
    frequency=abs(freqs(fcv));
    transfo(abs(trans)==frequency)=0;
end

%inverse DCT transform
KSS = idct2(transfo);
toc

figure(1)
imshowpair(I, KSS, 'montage')
title('(left) ORIGINAL IMAGE and DENOISED IMAGE (right)')
figure(2)
imshowpair(noisy2, KSS, 'montage')
title('(left) NOISY IMAGE and DENOISED IMAGE (right)')


