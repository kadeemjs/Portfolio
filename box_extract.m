function out_vid = box_extract(input_vid)

    % constants
    num_frames = length(input_vid(1,1,:,:));
    
    %get cordinates of dad in first frame
    img = input_vid(:,:,:,1);
    imshow(img);
    zoom on;
    waitfor(gcf, 'CurrentCharacter', char(13))
    zoom reset
    zoom off
    [c1,r1,but] = ginput(1);
    c1 = int16(c1);
    r1 = int16(r1);
    close all;
    imshow(img);
    zoom on;
    waitfor(gcf, 'CurrentCharacter', char(13))
    zoom reset
    zoom off
    [c2,r2,but] = ginput(1);
    c2 = int16(c2);
    r2 = int16(r2);
    close all;
    out_vid(:,:,:,1) = img(r1:r2,c1:c2,:);
    
    %get cordinates of dad in last frame
    img = input_vid(:,:,:,num_frames);
    imshow(img);
    zoom on;
    waitfor(gcf, 'CurrentCharacter', char(13))
    zoom reset
    zoom off
    [c3,r3,but] = ginput(1);
    c3 = int16(c3);
    r3 = int16(r3);
    close all;
    out_vid(:,:,:,num_frames) = img(r3:(r3+(r2-r1)),c3:(c3+(c2-c1)),:);
    
    % difference in pixels in frames
    d_col = c1-c3;
    d_col_frame = floor(d_col/num_frames);
    d_row = r1-r3;
    d_row_frame = floor(d_row/num_frames);
    
    for i = 2:num_frames-1
        img = input_vid(:,:,:,i);
        c_i = c1 - i*d_col_frame;
        r_i = r1 - i*d_row_frame;
        out_vid(:,:,:,i) = img(r_i:(r_i+(r2-r1)),c_i:(c_i+(c2-c1)),:);
    end
end

