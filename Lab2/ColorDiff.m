function diff = ColorDiff(reference,estimate)

[L,A,B] = xyz2lab(reference(1,:), reference(2,:), reference(3,:));
[L2,A2,B2] = xyz2lab(estimate(1,:), estimate(2,:), estimate(3,:));

diff = sqrt((L - L2).^2 + (A - A2).^2 + (B - B2).^2);

end