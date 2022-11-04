clc; clear; close all; warning off all;

%%% Proses pengujian citra
% menetapkan lokasi folder data uji
nama_folder = 'data uji';
% membaca file yg ber esktensi .jpg
nama_file = dir(fullfile(nama_folder,'*.jpg'));
%membaca jumlah file .jpg
jumlah_file = numel(nama_file);

% menginisialisasi variabel ciri_uji
ciri_uji = zeros(jumlah_file,4);
% melakukan pengolahan citra terhadap seluruh file
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
    ciri_uji(n,1) = Hue;
    ciri_uji(n,2) = Saturation;
    ciri_uji(n,3) = Value;
    ciri_uji(n,4) = Luas;
end

% menyusun kelas uji
kelas_uji = cell(jumlah_file,1);
% mengisi nama buah
for k = 1:19
    kelas_uji{k} = 'alpukat';
end

for k = 20:39
    kelas_uji{k} = 'apel';
end

for k = 40:69
    kelas_uji{k} = 'belimbing';
end

for k = 70:89
    kelas_uji{k} = 'buah naga';
end

for k = 90:104
    kelas_uji{k} = 'lemon';
end

for k = 105:124
    kelas_uji{k} = 'nanas';
end

for k = 125:144
    kelas_uji{k} = 'pir';
end

for k = 145:152
    kelas_uji{k} = 'pisang';
end

for k = 153:172
    kelas_uji{k} = 'salak';
end

for k = 173:192
    kelas_uji{k} = 'strawberry';
end

%memanggil naive bayes hasilpengujian
load Mdl

% membaca kelas hasil pengujian
hasil_uji = predict(Mdl,ciri_uji);

%menghitung akurasi pengujian
jumlah_benar = 0;
for k = 1:jumlah_file
    if isequal(hasil_uji{k}, kelas_uji{k})
        jumlah_benar = jumlah_benar+1;
    end
end

akurasi_pelatihan = jumlah_benar/jumlah_file*100

%menyimpan naive bayes
%save Mdl Mdl

