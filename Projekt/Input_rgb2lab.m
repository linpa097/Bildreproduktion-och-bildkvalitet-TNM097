function lab = Input_rgb2lab(img, num)


    % Gör om bilden till double [0,1] och omstrukturera till en Nx3 matris
    inputImageMatrix = im2double(reshape(img, [], 3));

    if num == 1
        % Om vi bara vill ha genomsnittliga färgen, använd medelvärde (SNABBARE ÄN kmeans)
        rgb = mean(inputImageMatrix, 1);
    else
        % Annars, använd k-means för att hitta de dominerande färgerna
        opts = statset('MaxIter', 100);
        [~, rgb] = kmeans(inputImageMatrix, num, 'Options', opts)
    end

    % Konvertera RGB till LAB
    lab = rgb2lab(rgb);
end