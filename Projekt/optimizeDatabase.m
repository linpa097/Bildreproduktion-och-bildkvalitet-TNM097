function [] = optimizeDatabase(orgFolder, reduceNumber, optimizedFolder)
%Optimize the database-Reduce images with close Lab-value

filepaths = dir(fullfile(orgFolder, '*.jpg'));

%Number of images in the folder
numFiles = numel(filepaths);
%numFiles = 30;


%Save all images in a array
%cell-Can save images of different dimensions
originalImages = cell(1, numFiles);

%Matrix to save all rgb-values for each image
ImageColorAvg = zeros(numFiles, 3);


for i = 1:numFiles
 filename = fullfile(orgFolder, filepaths(i).name);
 originalImages{i} = im2double(imread(filename));

 %Reshape every image to three columns, each row representing rgb-values
   reshaped_images = reshape(originalImages{i}, [], 3);
    
   %Average value for each color channel for every image
    ImageColorAvg(i, :) = mean(reshaped_images);
end

%Convert all rgb to lab
ImageColorAvg_Lab = rgb2lab(ImageColorAvg);


dE = zeros(numFiles,numFiles);

%Jämför alla lab värden med varandra
for i = 1:numFiles
    for j = 1:numFiles
        if i == j
            continue
        end
    dE(i,j) = ColorDiff(ImageColorAvg_Lab(i,:),ImageColorAvg_Lab(j,:));

    end
end



ColorDiff_threshold = 5;
similar_images = cell(1, numFiles);

%Hitta index för de bilder som är lika varandra
for i = 1:numFiles
    %Dupletter kommer fortfarande med
    similar_images{i} = find(dE(i, :) < ColorDiff_threshold);
end


%Similar images består av nummer eller arrays
%Arrays om fler bilder är lika varandra
%sort funktionen sorterar sedan efter längd
%dvs om det är e
% n array blir det längre length än ett nummer och hamnar
%längre bak

%Sortera listan med liknande bilder
[~, index] = sort(cellfun('length', similar_images));



%Spara bilderna i ny mapp
newFolderPath = fullfile(optimizedFolder);

%Antal bilder i nya mappen = reducenumber

for i = 1:reduceNumber
     [~, filename, ext] = fileparts(filepaths(index(i)).name);
     %disp("Name" + filename)
   imwrite(originalImages{index(i)}, fullfile(newFolderPath, [filename, ext]))
end


