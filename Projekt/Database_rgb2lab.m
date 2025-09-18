function lab = Database_rgb2lab(folder)

disp("Bilderna i databasen konverteras från RGB till Lab")
filepaths = dir(fullfile(folder, '*.jpg'));

%Number of images in the optimized folder
numFiles = numel(filepaths);
opts = statset('MaxIter', 100);

%Save all images in a array
%cell-Can save images of different dimensions

lab = zeros(numFiles,3);

for i = 1:numFiles
    % Läs in filen
    filename = fullfile(folder, filepaths(i).name);
    image = imread(filename);
    
    % Omvandla till rgbMatrix
    rgbMatrix = im2double(reshape(image, [], 3));
    
    rgb = mean(rgbMatrix, 1);

    
    % Konvertera till lab
    lab(i, :) = rgb2lab(rgb);
    
  
    
    
    
    
    
    
    
    
    
    %-------------------------------------Progressn utskrift------------------------------------%
       % Om du vill skriva ut andra meddelanden utöver progress:
    if i == 1
        disp('Startar bearbetning av bilder...');
    end

    % Beräkna progress i procent
    progress = (i / numFiles) * 100;  % Procent
    
    % Uppdatera progress var 10% (om progressen är ett heltal delbart med 10)
    if mod(progress, 10) == 0
        % Skriv över samma rad med \r för att uppdatera progress
        fprintf('\rProgress: %.2f%%   ', progress);  % Extra mellanslag för att säkerställa att gamla texten raderas
    end
    
    % Om det är sista filen
    if i == numFiles
        fprintf('\n');  % Går till nästa rad när loopen är klar
        disp('Bearbetning klar!');
    end
  %----------------------------------------------------------------------------------------%



end



end