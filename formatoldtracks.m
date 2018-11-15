function newtracks=formatoldtracks(data)

numkin=max(data(:,1));
newtracks=[];
for i=1:2:numkin
    k1=data(data(:,1)==i,:);
    k2=data(data(:,1)==i+1,:);
    newtracks=[newtracks; ones(size(k1,1),1)*((i+1)/2) k1(:,2)/.210 k1(:,3)/.210 k2(:,2)/.210 k2(:,3)/.210 k1(:,4)];
end