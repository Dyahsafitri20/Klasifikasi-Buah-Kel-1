clc; clear; close all; warning off all;

%%% Proses pelatihan citra
% menetapkan lokasi folder data latih
nama_folder = 'data latih';
% membaca file yg ber esktensi .jpg
nama_file = dir(fullfile(nama_folder,'*.jpg'));
%membaca jumlah file .jpg
jumlah_file = numel(nama_file);

% menginisialisasi variabel ciri_latih
ciri_latih = zeros(jumlah_file,4);
% melakukan pengolahan citra terhadapa seluruh file
for n = 1:jumlah_file
    img = imread(fullfile(nama_folder, nama_file(n).name));
    %figure, imshow(img)
    % konversi citra RGB menjadi citra mgrayscale
    img_gray = rgb2gray(img);
    %figure, imshow(img_gray)
    % konversi citra grayscale mnjdi citra biner
    bw = imbinarize(img_gray);
    %figure, imshow(bw)
    % operasi komplemen 
    bw = imcomplement(bw);
    %figure, imshow(bw)
    %operasi morfologi filling holes
    bw = imfill(bw,'holes');
    %figure, imshow(bw)

    %ekstraksi ciri buah
    % melakukan konversi citra rgb menjadi hsv
    HSV = rgb2hsv(img);
    %figure, imshow(HSV)
    % ekstraksi komponen hsv
    H = HSV(:,:,1);
    S = HSV(:,:,2);
    V = HSV(:,:,3);

    % mengubah nilai pixel bg menjadi 0
    H(~bw) = 0;
    S(~bw) = 0; 
    V(~bw) = 0;

    % menghitung nilai rata2 hsv
    Hue = sum(sum(H))/sum(sum(bw));
    Saturation = sum(sum(S))/sum(sum(bw));
    Value = sum(sum(V))/sum(sum(bw));

    % menghitung luas objek
    Luas = sum(sum(bw));
    % mengisi vaiarbel ciri_latih dengan ciri hasil esktaksi
    ciri_latih(n,1) = Hue;
    ciri_latih(n,2) = Saturation;
    ciri_latih(n,3) = Value;
    ciri_latih(n,4) = Luas;
end

% menyusun kelas latih
kelas_latih = cell(jumlah_file,1);
% mengisi nama buah
for k = 1:55
    kelas_latih{k} = 'alpukat';
end

for k = 56:125
    kelas_latih{k} = 'apel';
end

for k = 126:215
    kelas_latih{k} = 'belimbing';
end

for k = 216:375
    kelas_latih{k} = 'buah naga';
end

for k = 376:411
    kelas_latih{k} = 'lemon';
end

for k = 412:452
    kelas_latih{k} = 'nanas';
end

for k = 453:532
    kelas_latih{k} = 'pir';
end

for k = 533:552
    kelas_latih{k} = 'pisang';
end

for k = 553:587
    kelas_latih{k} = 'salak';
end

for k = 588:732
    kelas_latih{k} = 'strawberry';
end

% menggunakan algoritma naive bayes
Mdl = fitcnb(ciri_latih,kelas_latih);

% membaca kelas hasil pelatihan
hasil_latih = predict(Mdl,ciri_latih);

%menghitung akurasi pelatihan
jumlah_benar = 0;
for k = 1:jumlah_file
    if isequal(hasil_latih{k}, kelas_latih{k})
        jumlah_benar = jumlah_benar+1;
    end
end

akurasi_pelatihan = jumlah_benar/jumlah_file*100

%menyimpan naive bayes
save Mdl Mdl

