%a=input('Do you want to read in a STK files (s) or a TIF stacks (t)?','s');
numColors=2;
a='s';
clear imframes;
clear t1;
clear globalPoleX;
clear globalPoleY;

for j=1:numColors
    if a=='s'
        if numColors>1
            if j==1
                disp('Choose red/magenta image')
            elseif j==2
                disp('Choose green image')
            elseif j==3
                disp('Choose blue image')
            end
        end
        stk1 = FNtiffread;               %open the TIF stack
        temp1 = [stk1.MM_stack];
        num_frames=size(stk1,2);
        t1_ms = temp1(4,:);
        t1_ms=t1_ms-t1_ms(1);%set time to start at 0
        t1(:,j) = t1_ms'./1000;             % time in seconds
        %if j==1
         %   filename=input('Enter a filename to use as a prefix.','s')
        %end
        clear temp1;
        clear t1_ms;

        %put all the frames into a single matrix
        for i=1:num_frames
            imframes(:,:,i,j)=double(stk1(i).data);
            %i
        end
        clear stk1;
    elseif a=='t'
        if j==1
            num_frames=input('How many frames?');
            frameTime=input('How much time between frames?');
            t1=frameTime*[0:num_frames-1]';

        end
        if numColors>1
            if j==1
                disp('Choose red image')
            elseif j==2
                disp('Choose green image')
            elseif j==3
                disp('Choose blue image')
            end
        end
        [filename, pathname]=uigetfile({'*.tif;*.TIF'},'TIF file to load');
        cd(pathname);
        for i=1:num_frames
            imframes(:,:,i,j)=double(imread(filename,i));
        end
    else
        disp('Learn to read!')
    end
end

param.xdim=size(imframes,1);
param.ydim=size(imframes,2);
param.zdim=size(imframes,3);
total_pix=param.xdim*param.ydim*param.zdim;
num_frames=param.zdim;

figure(1)
index = 1;
imageToDisplay=getMulticolorImage(imframes,numColors,index);
hframe = subplot('Position', [.15 .05 .7 .7]);
imagesc(imageToDisplay);
if numColors==1
	colormap(gray)
end

t1=t1(:,1);

MadMax=imframes(:,:,:,2);
TubMax=imframes(:,:,:,1);



