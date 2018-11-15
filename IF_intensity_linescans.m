function [K1In, K1Out, K2In, K2Out, K1Tub, K2Tub]=intensity_linescans_V3(K1coord,K2coord,T1coord,T2coord, in,out,width,Image_stack)

%Draws linescans based off of both tubulin and kinetochore markers

numpoints=2*ceil(width);


K1x = K1coord( 1 );
K2x = K2coord( 1 );
T1x = T1coord( 1 );
T2x = T2coord( 1 );
K1y = K1coord( 2 );
K2y = K2coord( 2 );
T1y = T1coord( 2 );
T2y = T2coord( 2 );
K1z = K1coord( 3 );
K2z = K2coord( 3 );
T1z = T1coord( 3 );
T2z = T2coord( 3 );

xorientationcheck=K1x-K2x<0;
yorientationcheck=K1y-K2y<0;
vertcheck_k=K1x==K2x;
horzcheck_k=K1y==K2y;
vertcheck_t1= T1x==K1x;
horzcheck_t1= T1y==K1y;
vertcheck_t2= T2x==K2x;
horzcheck_t2= T2y==K2y;

%checks the orientation of kinetochores in x so we know which way
%to assign in and out of points. If orientationcheck=1, the pair
%goes from left to right.

Linedist=sqrt((K1x-K2x)^2+(K1y-K2y)^2);

perIn=in/Linedist;

%Finds the percentage of total line lengths, to be used for
%weighting averages


InX1=((2-2*perIn)*K1x+(2*perIn)*K2x)/2;
InX2=((2-2*perIn)*K2x+(2*perIn)*K1x)/2;
InY1=((2-2*perIn)*K1y+(2*perIn)*K2y)/2;
InY2=((2-2*perIn)*K2y+(2*perIn)*K1y)/2;
x=[K2x,K1x];
y=[K2y,K1y];
m=(diff(y)/diff(x));
%find slope of line
b=K1y-m*K1x;
% finds y intercept
minv=-1/m;

%find perpendicular line slope
%          if xorientationcheck==1 && horzcheck==0
%             OutX1=K1x-out/(1+m^2)^0.5;
%             OutX2=K2x+out/(1+m^2)^0.5;
%             InX1=K1x+in/(1+m^2)^0.5;
%             InX2=K2x-in/(1+m^2)^0.5;
%             finds the coordinates of the points  along the line that
%             will be used to draw tubulin linescans if K1 is left of K2
%          elseif xorientationcheck==0 && horzcheck==0
%             OutX1=K1x+out/(1+m^2)^0.5;
%             OutX2=K2x-out/(1+m^2)^0.5;
%             InX1=K1x-in/(1+m^2)^0.5;
%             InX2=K2x+in/(1+m^2)^0.5;
%          elseif xorientationcheck==1 && horzcheck==1
%              OutX1=K1x-out;
%
%             finds the coordinates of the points  along the line that
%             will be used to draw tubulin linescans if K1 is right of K2
%         end
%
%     OutY1=m*OutX1+b;
%     OutY2=m*OutX2+b;
%     InY1=m*InX1+b;
%     InY2=m*InX2+b;
%Finds the y's using slope-intercept form.

%%%%%%%%% Inner lines %%%%%%%%

vertcheck = vertcheck_k;
horzcheck = horzcheck_k;

if vertcheck==0 && horzcheck==0
    XPerps(1,:)=[InX1-(width/2)/(1+minv^2)^0.5 InX1+(width/2)/(1+minv^2)^0.5];
    XPerps(2,:)=[InX2-(width/2)/(1+minv^2)^0.5 InX2+(width/2)/(1+minv^2)^0.5];
    %Finds x coordinates of perpendicular lines going a certain distance
    %from the out and in points
    clear bperps
    bperps(1,:)=InY1-minv*InX1;
    bperps(2,:)=InY2-minv*InX2;
    bperps=horzcat(bperps,bperps);
    %Finds the y-intercepts of those perpendicular lines
    YPerps=XPerps.*minv+bperps;
elseif vertcheck==1
    
    XPerps(1,:)=[InX1-width/2 InX1+width/2];
    XPerps(2,:)=[InX2-width/2 InX2+width/2];
    YPerps(1,1:2)=InY1;
    YPerps(2,1:2)=InY2;
    
    
elseif horzcheck==1
    

    YPerps(1,:)=[InY1-width/2 InY1+width/2];
    YPerps(2,:)=[InY2-width/2 InY2+width/2];
    XPerps(1,1:2)=InX1;
    XPerps(2,1:2)=InX2;
end

%Finds the y points to go with those x points

k1_image = Image_stack(:,:, 1, K1z);

k2_image = Image_stack(:,:, 1, K2z);


Inline1=improfile(k1_image,XPerps(1,:),YPerps(1,:),numpoints);
Inline2=improfile(k2_image,XPerps(2,:),YPerps(2,:),numpoints);

K1In=sum(Inline1);
K2In=sum(Inline2);

in_endpoints_1 = [XPerps(1,:); YPerps(1,:)];
in_endpoints_2 = [XPerps(2,:); YPerps(2,:)];

%%%%%%%%% Tubulin 1 %%%%%%%%

vertcheck = vertcheck_t1;
horzcheck = horzcheck_t1;

x=[T1x,K1x];
y=[T1y,K1y];
m=(diff(y)/diff(x));
%find slope of line
b=T1y-m*T1x;
% finds y intercept
minv=-1/m;

if vertcheck==0 && horzcheck==0
    XPerps=[T1x-(width/2)/(1+minv^2)^0.5 T1x+(width/2)/(1+minv^2)^0.5];
    
    %Finds x coordinates of perpendicular lines going a certain distance
    %from the out and in points
    clear bperps
    bperps=T1y-minv*T1x;
    
    bperps=horzcat(bperps,bperps);
    %Finds the y-intercepts of those perpendicular lines
    YPerps=XPerps.*minv+bperps;
elseif vertcheck==1
    
    XPerps=[T1x-width/2 T1x+width/2];
    
    YPerps=[T1y T1y];
    
    
    
elseif horzcheck==1
    
    
    YPerps=[T1y-width/2 T1y+width/2];
    
    XPerps=[T1x T1x];
    
end

t1_image = Image_stack(:,:, 1, T1z);

Outline1=improfile(t1_image,XPerps(1,:),YPerps(1,:),numpoints);

K1Out=sum(Outline1);

out_endpoints_1 = [XPerps(1,:); YPerps(1,:)];

%%%%%%%%% Tubulin 2 %%%%%%%%

vertcheck = vertcheck_t2;
horzcheck = horzcheck_t2;

x=[T2x,K2x];
y=[T2y,K2y];
m=(diff(y)/diff(x));
%find slope of line
b=T2y-m*T2x;
% finds y intercept
minv=-1/m;

if vertcheck==0 && horzcheck==0
    XPerps=[T2x-(width/2)/(1+minv^2)^0.5 T2x+(width/2)/(1+minv^2)^0.5];
    
    %Finds x coordinates of perpendicular lines going a certain distance
    %from the out and in points
    clear bperps
    bperps=T2y-minv*T2x;
    
    bperps=horzcat(bperps,bperps);
    %Finds the y-intercepts of those perpendicular lines
    YPerps=XPerps.*minv+bperps;
elseif vertcheck==1
    
    XPerps=[T2x-width/2 T2x+width/2];
    
    YPerps=[T2y T2y];
    
    
    
elseif horzcheck==1
    
    
    YPerps=[T2y-width/2 T2y+width/2];
    
    XPerps=[T2x T2x];
    
end

t2_image = Image_stack(:,:, 1, T2z);

Outline2=improfile(t2_image,XPerps(1,:),YPerps(1,:),numpoints);

K2Out=sum(Outline2);

out_endpoints_2 = [XPerps(1,:); YPerps(1,:)];


K1Tub=sum(Outline1)-sum(Inline1);
K2Tub=sum(Outline2)-sum(Inline2);
disp('done')


