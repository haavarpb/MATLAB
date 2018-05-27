function [filled, pipe_width] = fillPipe(pipe_edges, hough_lines)
%FILLPIPE fills a pipe given as a two element structure given by
%houghlines()

dir = [hough_lines.theta];
len = [hough_lines.rho];

farthest_index = find(len == max(len)); % Finds the index of the greatest line
shortest_index = find(len == min(len));
pipe_width = len(farthest_index) - len(shortest_index);
pipe_center_line = len(farthest_index) - pipe_width/2;

fill_location = floor([pipe_center_line*sind(dir(farthest_index)) ... % Y pos
                        pipe_center_line*cosd(dir(farthest_index)) ] + 1); % X pos (+ 1 to shift into matrix indeces
             
filled = imfill(pipe_edges, fill_location);

end