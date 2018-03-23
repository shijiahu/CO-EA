function m = distancexy(cus,indi1,indi2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%   求两点之间的距离
    if indi2 == 0 
        m = sqrt((cus.xc(indi1)-35)^2+(cus.yc(indi1)-35)^2);
    else
        m = sqrt((cus.xc(indi1)-cus.xc(indi2))^2+(cus.yc(indi1)-cus.yc(indi2))^2);
    end
end

