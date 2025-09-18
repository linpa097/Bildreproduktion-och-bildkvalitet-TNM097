function [Output] = Linearize(inputTRC,inputRamp)
   
%Interpolate

%Step to achive linear curve
   step = 0:0.01:1;

   %pchip - Piecewise Cubic Hermite Interpolation
   Output(:,:,1) = interp1(inputTRC(:,:,1), step ,inputRamp(:,:,1),'pchip');
   Output(:,:,2) = interp1(inputTRC(:,:,2), step, inputRamp(:,:,2),'pchip');
   Output(:,:,3) = interp1(inputTRC(:,:,3), step, inputRamp(:,:,3),'pchip');
end