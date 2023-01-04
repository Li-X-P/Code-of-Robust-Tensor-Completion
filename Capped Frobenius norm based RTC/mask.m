function  Omega_array = mask()
Omega_array = ones(256,256,3);
% 
% for a = 80 : 85
%     for i = 80-a+80:256
%         Omega_array(i-a+1,i,1:3)=0;
%     end
% end

for a = 40 : 45
    for i = a:256 -a+40
        Omega_array(i-a+1,i,1:3)=0;
    end
end

for a = 80 : 85
    for i = a:256 -a+80
        Omega_array(i-a+1,i,1:3)=0;
    end
end

for a = 120 : 125
    for i = a:256 -a+120
        Omega_array(i-a+1,i,1:3)=0;
    end
end

for a = 160 : 165
    for i = a:256 -a+160
        Omega_array(i-a+1,i,1:3)=0;
    end
end

for a = 200 : 205
    for i = a:256 -a+200
        Omega_array(i-a+1,i,1:3)=0;
    end
end

for a = 240 : 245
    for i = a:256 -a+240
        Omega_array(i-a+1,i,1:3)=0;
    end
end



for a = 1 : 5
    for i = a:256 -a+1
        Omega_array(i,i-a+1,1:3)=0;
    end
end

for a = 40 : 45
    for i = a:256 -a+40
        Omega_array(i,i-a+1,1:3)=0;
    end
end

for a = 80 : 85
    for i = a:256 -a+80
        Omega_array(i,i-a+1,1:3)=0;
    end
end
for a = 120 : 125
    for i = a:256 -a+120
        Omega_array(i,i-a+1,1:3)=0;
    end
end
for a = 160 : 165
    for i = a:256 -a+160
        Omega_array(i,i-a+1,1:3)=0;
    end
end

for a = 200 : 205
    for i = a:256 -a+200
        Omega_array(i,i-a+1,1:3)=0;
    end
end

for a = 240 : 245
    for i = a:256 -a+240
        Omega_array(i,i-a+1,1:3)=0;
    end
end
% imshow(Omega_array);
end


