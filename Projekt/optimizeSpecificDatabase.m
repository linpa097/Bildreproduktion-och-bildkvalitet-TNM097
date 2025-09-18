function [] = optimizeSpecificDatabase(inputImage, orgFolder, reduceNumber, optimizedFolder)
% optimizeSpecificDatabase
% Väljer ut reduceNumber bilder från orgFolder baserat på inputbildens färger.
%
% inputImage       - Inmatningsbilden (RGB)
% orgFolder        - Mapp med databasinbilder (t.ex. *.jpg)
% reduceNumber     - Önskat antal utvalda bilder
% optimizedFolder  - Mapp där de utvalda bilderna sparas
%
% OBS: Antalet färger som extraheras från inputbilden styrs av variabeln n_colors
% och är oberoende av reduceNumber.

%% Steg 1: Kvantisera inputbildens färger
n_colors = 50;  % Bestäm hur många färger som ska extraheras från inputbilden
[indexed_img, cmap] = rgb2ind(inputImage, colors);
%figure;
%imshow(indexed_img, cmap);
%title("Indexed Reference Image");

% Konvertera paletten från RGB till Lab
map_LAB = rgb2lab(cmap);

%% Steg 2: Extrahera representativt Lab-värde för varje bild i databasen
filepaths = dir(fullfile(orgFolder, '*.jpg')); % Anpassa filändelse vid behov
numFiles = numel(filepaths);
labValues = zeros(numFiles, 3);
databaseImages = cell(numFiles, 1);

for i = 1:numFiles
    filename = fullfile(orgFolder, filepaths(i).name);
    img = im2double(imread(filename));
    databaseImages{i} = img;
    
    % Beräkna medelfärgen (RGB) och konvertera sedan till Lab
    avgRGB = mean(reshape(img, [], 3), 1);
    labValues(i, :) = rgb2lab(avgRGB);
end

%% Steg 3: Matcha varje kvantiserad färg med närmaste bild
closestImagesIndices = zeros(n_colors, 1);
for i = 1:n_colors
    % Beräkna euklidiskt avstånd i Lab mellan den i:te färgen och alla databasinbilder
    colorDist = sqrt(sum((labValues - map_LAB(i, :)).^2, 2));
    [~, minIdx] = min(colorDist);
    closestImagesIndices(i) = minIdx;
end

%% Steg 4: Säkerställ att exakt reduceNumber unika bilder väljs
% Ta bort dubbletter och bevara ordningen (första träffen räknas)
uniqueIndices = unique(closestImagesIndices, 'stable');

% Om antalet unika matchningar är färre än reduceNumber, lägg till övriga bilder (i ordning)
if numel(uniqueIndices) < reduceNumber
    extraNeeded = reduceNumber - numel(uniqueIndices);
    allIndices = (1:numFiles)';
    remaining = setdiff(allIndices, uniqueIndices, 'stable');
    uniqueIndices = [uniqueIndices; remaining(1:extraNeeded)];
else
    uniqueIndices = uniqueIndices(1:reduceNumber);
end

%% Steg 5: Spara de utvalda bilderna
for i = 1:length(uniqueIndices)
    idx = uniqueIndices(i);
    [~, name, ext] = fileparts(filepaths(idx).name);
    outPath = fullfile(optimizedFolder, [name, ext]);
    imwrite(databaseImages{idx}, outPath);
end

fprintf('Antalet utvalda bilder: %d\n', numel(uniqueIndices));

end
