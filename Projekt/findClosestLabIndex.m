function index = findClosestLabIndex(originalLab,databaseLab)

num2 = length(databaseLab);

diff = 0;

    savediff = inf;
    for j = 1:num2
    
        diff = ColorDiff(originalLab(),databaseLab(j,:));

        if(diff < savediff)
            savediff = diff;
            index = j;
        end
    end
