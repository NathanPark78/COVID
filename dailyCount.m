function [a, b] = dailyCount(c,d)
%preallocate for countries
a = zeros(1,375);
b = zeros(1,375);            
a(1)=c(1);
b(1)=d(1);

%count function
for i = 2:length(c)
    a(i)=c(i) - c(i-1);
    b(i)=d(i) - d(i-1);
    if a(i) < 0
        a(i) = 0;
    elseif b(i) < 0
        b(i) = 0;
    end                
end