clear;
vidObj = VideoReader('background_vid.mp4');
% CREATING EPI IMAGE
vid = read(vidObj, [1 Inf]);
mid = 540;
for i=17:186
    epi_im1(i-16,:,:) = vid(mid,:,:,i); % mid is the midpoint of the rows
end
figure
imshow(epi_im1)
%%
% Object Video
sample_size = 3;
dad_vidObj = VideoReader('object_vid.mp4');
obj_vid = read(dad_vidObj, [1 Inf]);
obj_vid1 = obj_vid(280:970,:,:,:);
obj_vid2 = obj_vid1(:,:,:,132:197);
obj_vid3 = obj_vid2(1:sample_size:691,1:sample_size:1920,:,:);
for i=1:dad_vidObj.NumberOfFrames
    obj_epi(i,:,:) = obj_vid(540,:,:,i); % mid is the midpoint of the rows
end
% figure
% imshow(obj_epi);
% v = VideoWriter('new_obj_vid.mp4','MPEG-4');
% open(v);
% writeVideo(v,obj_vid3);
% close(v);

%%
% Order Hold
back_vidObj = VideoReader('background_vid.mp4');
back_vid = read(back_vidObj, [1 Inf]);
back_vid = back_vid(:,:,:,17:186);
% v = VideoWriter('background_vid1.mp4','MPEG-4');
% open(v);
% writeVideo(v,back_vid);
% close(v);

obj_vid4 = box_extract(obj_vid3);
obj_vid5 = obj_vid4(:,:,:,1:end);
obj_num_frames = length(obj_vid5(1,1,:,:));
for i=1:obj_num_frames
    for j=1+3*(i-1):170
        hold_obj_vid(:,:,:,j) = obj_vid5(:,:,:,i);
    end
end

v = VideoWriter('hold_obj_vid.mp4','MPEG-4');
open(v);
writeVideo(v,hold_obj_vid);
close(v);

%%
% Insert into video

% Measure slope of wire cutters in EPI image (epi_im1)
% User determines two points
    imshow(epi_im1);
    zoom on;
    waitfor(gcf, 'CurrentCharacter', char(13))
    zoom reset
    zoom off
    [c1,r1,but] = ginput(1);
    c1 = int16(c1);
    r1 = int16(r1);
    close all;
    imshow(epi_im1);
    zoom on;
    waitfor(gcf, 'CurrentCharacter', char(13))
    zoom reset
    zoom off
    [c2,r2,but] = ginput(1);
    c2 = int16(c2);
    r2 = int16(r2);
    close all;
    pixels_per_frame = (c2-c1)/(r2-r1); %Determine the number of pixels moved per frame
    
 % User selects starting point of DAD board (corresponds to top right
 % corner of DAD board) in first frame of video
 
    imshow(back_vid(:,:,:,1));
    zoom on;
    waitfor(gcf, 'CurrentCharacter', char(13))
    zoom reset
    zoom off
    [c1,r1,but] = ginput(1);
    c1 = int16(c1);
    r1 = int16(r1);
    close all;
    
 %%
 % Go through each frame in back_vid and add the corresponding frame of the
 % DAD board at the selected location
 num_frames = length(back_vid(1,1,:,:));
 dad_rows = length(obj_vid5(:,1,:,1));
 dad_cols = length(obj_vid5(1,:,:,1));
 vid_w_object = back_vid;
    for i = 1:num_frames
        vid_w_object((r1:r1+dad_rows-1)+40 + floor(i/5),(c1-dad_cols:c1-1)+pixels_per_frame*i,:,i) = hold_obj_vid(:,:,:,i);
   % Fix the row movement later
    end
    
v = VideoWriter('vid_w_object.mp4','MPEG-4');
open(v);
writeVideo(v,vid_w_object);
close(v);

% DAD board is not behind an object between frames 55 and 144
vid_w_some_object = vid_w_object;
% for i=55:144
%     vid_w_some_object(:,:,:,i) = vid_w_object(:,:,:,i);
% end

% Add the DAD board in the beginning
for i = 1:54
    vid_w_some_object(:,(((c1-dad_cols):(c1-1)-double(uint16(3*i)))+pixels_per_frame*i-130),:,i) = back_vid(:,(((c1-dad_cols):(c1-1)-double(uint16(3*i)))+pixels_per_frame*i-130),:,i);
% Fix the row movement later
end

vid_w_some_object(:,:,:,55:115) = vid_w_object(:,:,:,55:115);

% Add the DAD board in the end
for i = 115:145
    vid_w_some_object(:,((c1-1)+pixels_per_frame*i-14*(i-115)+10):1920,:,i) = back_vid(:,((c1-1)+pixels_per_frame*i-14*(i-115)+10):1920,:,i);
% Fix the row movement later
end

for i = 115:145
    vid_w_some_object(r1:r1+40,((c1-1)+pixels_per_frame*i-14*(i-115)+10):1920,:,i) = vid_w_object(r1:r1+40,((c1-1)+pixels_per_frame*i-14*(i-115)+10):1920,:,i);
% Fix the row movement later
end

vid_w_some_object(:,:,:,146:end) = vid_w_object(:,:,:,146:end);

% Add the DAD board back in after it passes the battery
for i = 132:num_frames
    vid_w_some_object(:,((c1-1-15*(i-132)):c1-1)+pixels_per_frame*i,:,i) = vid_w_object(:,((c1-1-15*(i-132)):c1-1)+pixels_per_frame*i,:,i);
% Fix the row movement later
end

v = VideoWriter('vid_w_some_object.mp4','MPEG-4');
open(v);
writeVideo(v,vid_w_some_object);
close(v);

%% Downsample for quality
down_vid = vid_w_some_object(:,:,:,1:2:end);

v = VideoWriter('down_vid.mp4','MPEG-4');
open(v);
writeVideo(v,down_vid);
close(v);

%% Interpolate the frames
clear
down_vid_obj = VideoReader('down_vid.mp4');
down_vid = read(down_vid_obj, [1 Inf]);
num_frames = length(down_vid(1,1,:,:));
for i=1:num_frames
    down_vid_2(:,:,:,2*i-1) = down_vid(:,:,:,i); 
    down_vid_2(:,:,:,2*i) = down_vid(:,:,:,i); 
end
v = VideoWriter('interp_vid.mp4','MPEG-4');
open(v);
writeVideo(v,down_vid_2);
close(v);