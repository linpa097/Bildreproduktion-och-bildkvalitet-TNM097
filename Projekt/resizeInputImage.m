function resizedImage = resizeInputImage(inputImage,resolution)
    %Skala om bilden
    
    %nargin - Number of arguments

   %Kolla om användaren vill ha en specifikt format
   if nargin < 2
       resolution = "";
   end
    
outputstring = "";
[height,width] = size(inputImage);
maxDimension = 320;

%%Skala ner eller upp
if height > maxDimension || width > maxDimension
    outputstring = "Din bild skalas ner ";
    resizedImage = imresize(inputImage, [maxDimension,maxDimension], 'bilinear');
else
    outputstring = "Din bild skalas upp vilket kan försämra upplösningen "
     resizedImage = imresize(inputImage, [maxDimension,maxDimension], 'bilinear');
end



%Ändra resolution
if resolution == "Landscape"
    resizedImage = imresize(inputImage, [maxDimension/2,maxDimension], 'bilinear');
    outputstring = outputstring + "och anpassas till formatet Landscape";
else if resolution == "Portrait"
    resizedImage = imresize(inputImage, [maxDimension,maxDimension/2], 'bilinear');
    outputstring = outputstring + "och anpassas till formatet Portrait";
else
    resizedImage = imresize(inputImage, [maxDimension,maxDimension], 'bilinear');
    outputstring = outputstring + "och skalas till ett kvadratiskt format";
end

disp(outputstring);


end