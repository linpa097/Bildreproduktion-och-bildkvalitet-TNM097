function diff = ColorDiffImages(reference,estimate)
%   Detailed explanation goes here

reference = rgb2lab(reference);
estimate = rgb2lab(estimate);

L = reference(:,:,1);
A = reference(:,:,2);
B = reference(:,:,3);

L2 = estimate(:,:,1);
A2 = estimate(:,:,2);
B2 = estimate(:,:,3);

diff = sqrt((L - L2).^2 + (A - A2).^2 + (B - B2).^2);
diff = mean(diff(:));
end