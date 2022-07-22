function mycolours=generateGrainColours(f)
%
% mycolours=generateGrainColours(f)
% This function generates colours based on a vector of inputs in f, using the current colormap
%
% The input argument is
%      f   : an N x 1 array of values
%
% The return argument is
%      mycolours : an N x 3 array of color values (each row is an RGB triplet)    
    
    cm = colormap; % returns the current color map
    Nc=size(cm,1); % number of colours in the color map 


    if(abs(max(f)-min(f))<2*eps)
        colorID=Nc*ones(size(f));
    else

        f=(f-min(f))/(max(f)-min(f));
        colorID=max(1,ceil(f*Nc));
    end

    mycolours=cm(colorID,:);

end