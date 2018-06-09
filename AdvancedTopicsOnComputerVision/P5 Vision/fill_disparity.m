function [dispmap] = fill_disparity(dispmap)
for row = 1:size(dispmap, 1)
    current_fill = 0;
    for col = 1:size(dispmap, 2)
        if dispmap(row, col) ~= current_fill && dispmap(row,col) ~= 0
            current_fill = dispmap(row,col);
        end
        dispmap(row, col) = current_fill;
    end
end
end