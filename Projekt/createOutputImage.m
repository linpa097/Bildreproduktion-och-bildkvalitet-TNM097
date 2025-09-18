function [resizedImage, originalImage, MosaicImage] = createOutputImage(originalImage, database, format)



if nargin < 3
    format = "";
end

resizedImage = resizeInputImage(originalImage, format);

% Konvertera databasen till Lab färgrymd
dataBaseLab = Database_rgb2lab(database);
disp("Dina bilder har konverterats från RGB till Lab");

filepaths = dir(fullfile(database, '*.jpg'));  % Hämta alla bilder i mappen
numFiles = numel(filepaths);  % Antal bilder i databasen
Images = cell(numFiles, 1);  % Cell-array för att lagra bilder

% Antal rader och kolumner för mosaiken
numRows = 160;  
numCols = 160;  

% Läs in och förbearbeta alla bilder i databasen (resize en gång)
subImageHeight = floor(size(resizedImage, 1) / (numRows)); %Delbildens höjd
subImageWidth = floor(size(resizedImage, 2) / (numCols)); %Delbildens bredd

for i = 1:numFiles
    filename = fullfile(database, filepaths(i).name);  % Filväg
    Images{i} = im2double(imread(filename));  % Läs in varje bild till cell-array
    % Förbearbeta och lagra den skalade bilden
    Images{i} = imresize(Images{i}, [subImageHeight, subImageWidth], 'bilinear');
end



% Skapa en tom bild för mosaiken
MosaicImage = zeros(size(resizedImage));  % En bild med samma storlek som originalet

fprintf("Den nya bilden börjar skapas...\n")

% Dela upp originalbilden i små sektioner och hitta närmaste bild från databasen
for row = 1:numRows
    for col = 1:numCols
        % Bestäm området för den aktuella sektionen i originalbilden
        rowStart = (row - 1) * subImageHeight + 1;
        rowEnd = row * subImageHeight;
        colStart = (col - 1) * subImageWidth + 1;
        colEnd = col * subImageWidth;
        
        % Extrahera subbild från originalbilden
        subImage = resizedImage(rowStart:rowEnd, colStart:colEnd, :);
        
        % Konvertera subbilden till CIELAB
        subLab = Input_rgb2lab(subImage, 1);
        
        % Hitta den närmaste bilden i databasen baserat på CIELAB
        index = findClosestLabIndex(subLab, dataBaseLab);
        
        % Hämta den förbearbetade bilden från databasen
        closestImageResized = Images{index};
        
        % Placera den skalade bilden i mosaiken
        MosaicImage(rowStart:rowEnd, colStart:colEnd, :) = closestImageResized;
    end
    fprintf('Rad %d av %d klar. Progress: %.2f%%\n', row, numRows, (row / numRows) * 100);
end

% Skapa en figur för alla bilder
figure;

% Visa den första bilden
subplot(1, 3, 1);  % Dela upp figuren i 1 rad och 3 kolumner
imshow(originalImage);

% Visa den andra bilden
subplot(1, 3, 2);  % Dela upp figuren i 1 rad och 3 kolumner
imshow(resizedImage);

% Visa den tredje bilden
subplot(1, 3, 3);  % Dela upp figuren i 1 rad och 3 kolumner
imshow(MosaicImage);

end
