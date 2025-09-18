function diff = ColorDiff2(reference,estimate)
%XYZ2CIELAB Summary of this function goes here
%   Detailed explanation goes here

L = reference(:,:,1);
A = reference(:,:,2);
B = reference(:,:,3);

L2 = estimate(:,:,1);
A2 = estimate(:,:,2);
B2 = estimate(:,:,3);

diff = sqrt((L - L2).^2 + (A - A2).^2 + (B - B2).^2);

end