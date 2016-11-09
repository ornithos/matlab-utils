function ylimZero(d)
    %ylimZero(d)
    % make either bottom or top y limit zero, leaving other coordinate
    % unaffected.
    %
    % INPUTS:
    % d - the co-ordinate dimension to force
    %
    % eg. ylimZero(1) means ylim([0, currentUpperLimt])
   
    
    h = gca;
    curLim = get(gca, 'YLim');
    switch d
        case 1
            ylim([0, curLim(2)]);
        case 2
            ylim([curLim(1), 0]);
        otherwise
            error('d must be 1 or 2');
    end
    
end

