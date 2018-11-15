function [data]=NEBDBGSIR(imframes,bounds,num)
close all
disp('Background!')
%function to track kinetochores after FRAP experiments. Data is the table
%containing (numkin (set in parent script FrapTrack),x,y,z,tfrap)
frame=bounds(1);
img=getMulticolorImage(imframes,2,frame);
numframes=size(imframes,3);
dimensions=get(0,'screensize');
width=dimensions(3);
height=dimensions(4);
figure('Position',[width-width,height-.75*height,width,.75*height])
imagesc(img)



frames=bounds(1):bounds(2);

numframes=length(frames);

    disp('Click on the Pole in each frame. Press "X" to leave, press "F" to mark the frame of FRAP')
    button=1;
    kin1Check='n';
    tryAgainCheck='n';
    clear K1x;
    clear K1y;
    while kin1Check=='n'
        for i=1:numframes
            imgtosee=getMulticolorImage(imframes,2,frames(i));
            figure(1)
            imagesc(imgtosee)
            disp(['frame ' num2str(frames(i))])
            [xp,yp,button] = ginput(1);
            if button==120 
                finish=i-1;
                break 
            elseif button==102
                button=1
                FRAP=i;
                [xp,yp,button] = ginput(1);
                
            end
            
            K1x(i)=xp;
            K1y(i)=yp;
            %framenum(i-(frame-1))=i;
        end
  
kin1Check=input('Are you happy with this Kinetochore tracking? y/n','s');
    if kin1Check=='n'
                        tryAgainCheck=input('Would you like to try again? y/n','s');
                    end

                    if kin1Check=='n'&&tryAgainCheck=='n'
                        kin1Check='y';
                        clear K1x;
                        clear K1y;
                    end
    end
    
     %%%%%% Kinetochore 2 %%%%%%%%
    kin2Check='n';
    tryAgainCheck='n';
    
    while kin2Check=='n'
        for i=1:numframes
            imgtosee=getMulticolorImage(imframes,2,frames(i));
            figure(1)
            imagesc(imgtosee)
            hold on
            %circle(K1x(i-(frame-1)), K1y(i-(frame-1)),3);
            hold off
            disp(['frame ' num2str((frames(i)))])
            [xp,yp,button] = ginput(1);
            if button==120 
                finish=i-1;
                break 
            elseif button==102
                button=1
                FRAP=i;
                [xp,yp,button] = ginput(1);
                
            end
            
            K2x(i)=xp;
            K2y(i)=yp;
            %framenum(i-(frame-1))=i;
        end
    kin2Check=input('Are you happy with this Kinetochore tracking? y/n','s');
    if kin2Check=='n'
                        tryAgainCheck=input('Would you like to try again? y/n','s');
                    end

                    if kin2Check=='n'&&tryAgainCheck=='n'
                        kin2Check='y';
                        clear K2x;
                        clear K2y;
                    end
    end
            %disp (finish)
%movie=input('what movie number? ');
temp1=ones(length(K1x),1)*num;

data=[temp1 K1x' K1y' K2x' K2y' frames'];
