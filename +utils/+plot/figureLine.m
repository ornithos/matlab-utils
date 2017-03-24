function figureLine(m, c, varargin)
    %figureLine(m, c)
    % Draw line y = mx + c 
    % in the current axes. Will maintain limits currently shown
    %
    % INPUTS:
    % m - the gradient of the line
    % c - the intercept of the line
    %
    % eg. figureLine(1,0) will draw diagonal line y = x.
   
    
    h = gca;
    curYLim = get(gca, 'YLim');
    curXLim = get(gca, 'XLim');
    
    origHoldStatus = ishold;
    hold on;
    
    x1 = curXLim(1);
    x2 = curXLim(2);
    
    y1 = x1*m + c;
    y2 = x2*m + c;
    
    if m > 0
        if y1 < curYLim(1)
            x1 = (curYLim(1)-c)/m;
            y1 = x1*m + c;
        end
        if y2 > curYLim(2)
            x2 = (curYLim(2)-c)/m;
            y2 = x2*m + c;
        end
    else
        if y2 < curYLim(1)
            x2 = (curYLim(1)-c)/m;
            y2 = x2*m + c;
        end
        if y1 > curYLim(2)
            x1 = (curYLim(2)-c)/m;
            y1 = x1*m + c;
        end
    end
        
    plot([x1,x2], [y1,y2], varargin{:});
    if origHoldStatus == 0
        hold off
    end
end

