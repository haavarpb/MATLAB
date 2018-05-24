function [I_burned] = addHoughLines(I, hough_lines)
%ADDHOUGHLINES Burns the plots of hough_lines in hough_lines into the image
%I
fig = figure('visible', 'off');
imshow(I);
hold on;
for k = 1:length(hough_lines)
    rho = hough_lines(k).rho;
    theta = hough_lines(k).theta;
    xup = rho/cosd(theta);
    xdown = (rho - size(I, 2)*sind(theta))/cosd(theta);
    yleft = rho/sind(theta);
    yright = (rho - size(I, 1)*cosd(theta))/sind(theta);
    
    % Check if the cut points are valid (different from Inf and -Inf)
    % and plot the line between them
    xy = zeros(2,2);
    j = 1;
    
        if (xup ~= Inf) && (xup ~= -Inf)
            xy(j,:) = [xup, 0];
            j = j+1;
            if j==3
                plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','white');
                    continue
                end
        end
        if (xdown ~= Inf) && (xdown ~= -Inf)
            xy(j,:) = [xdown, size(I,2)];
            j = j+1;
                if j==3
                    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','white');
                    continue
                end
        end
        if (yleft ~= Inf) && (yleft ~= -Inf)
            xy(j,:) = [0, yleft];
            j = j+1;
                if j==3
                    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','white');
                    continue
                end
        end
        if (yright ~= Inf) && (yright ~= -Inf)
            xy(j,:) = [size(I,2), yright];
            j = j+1;
                if j==3
                    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','white');
                    continue
                end
        end
end
hold off;

fig.Children.Units = 'pixels';
image_pos = floor(fig.Children.Position);
frame = getframe(gcf);
frame_image_gray = rgb2gray(frame.cdata);
cut_rows = (size(frame_image_gray, 1) - image_pos(2) - image_pos(4)):(size(frame_image_gray, 1) - image_pos(2) - 1);
cut_cols = (size(frame_image_gray, 2) - image_pos(1) - image_pos(3)):(size(frame_image_gray, 2) - image_pos(1) - 1);
I_burned = frame_image_gray(cut_rows, cut_cols);

end

