function [gmin] = buscarminimo(ftla)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
tmin=100;
o=0;
for t=20:-.1:.5
   for a=15:-.1:1
   gatraso=zpk(-(1/t),-(1/a*t),1);
   ft=feedback(gatraso*ftla,1);
   info=stepinfo(ft);
   o = o + 1;
   if info.SettlingMin >= .75
       o;
       info.SettlingTime
       if info.Overshoot<20
           info.Overshoot;
           
           if info.SettlingTime<tmin
           tmin=info.SettlingTime
           gmin=gatraso;
           
           end
       end   
   end
   end
end

ft=feedback(ftla*gmin,1);
stepinfo(ft)
end

