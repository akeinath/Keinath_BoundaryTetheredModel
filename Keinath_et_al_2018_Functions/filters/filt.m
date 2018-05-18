function x = filt(x,rect)
    x(x<rect(1,1)) = rect(1,2);
    x(x>rect(2,1)) = rect(2,2);
end