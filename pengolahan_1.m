clc; clear; close all; warning off all;

% memanggil menu
[nama_file, nama_folder] = uigetfile('*.jpg');

if ~isequal (nama_file,0)
    img = imread(fullfile(nama_folder, nama_file));
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
    ciri_uji(1,1) = Hue;
    ciri_uji(1,2) = Saturation;
    ciri_uji(1,3) = Value;
    ciri_uji(1,4) = Luas;

    %memanggil naive bayes hasilpengujian
    load Mdl

% membaca kelas hasil pengujian
hasil_uji = predict(Mdl,ciri_uji);

%meanmpilkan citra asli dan kelas keluaran
figure, imshow(img)
title({['Nama file:',nama_file], ['Kelas Keluaran:', hasil_uji{1}]})
else
    return
end