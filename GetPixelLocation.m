I = imread('checker1.jpg');
imshow(I);
zoom on;
waitfor(gcf, 'CurrentCharacter', char(13))
zoom reset
zoom off
[c1,r1,but] = ginput(1);
c1 = int16(c1);
r1 = int16(r1);
close all;
imshow(I);
zoom on;
waitfor(gcf, 'CurrentCharacter', char(13))
zoom reset
zoom off
[c2,r2,but] = ginput(1);
c2 = int16(c2);
close all;
slope = (double(c2)-double(c1))/(double(r2)-double(r1))
r2 = int16(r2);

vid_obj2 = 0;
vid_obj2(:,:,:,:) = vid_obj1(280:970,:,:,:);













