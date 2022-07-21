function h=plotErrors(errordata)

% h=plotErrors(errordata)
% This function calculates a cumulative number distribution of a distribution of errors
%
% Input arguments:
%  errordata : a vector containing the errors
%
% Output arguments:
%
%  h : figure handle


    cdx=errordata;
    cdy=length(errordata):-1:1;
    
    %    [cdx,cdy]=cdnum(errordata);
    %    cdy=cdy(end)+1-cdy;
    h=figure;
    plot(cdx,cdy,'b','LineWidth',2);
    xlim([0,max(errordata)])
    set(gca,'YScale','log','yminortick','on','tickdir','in');
    xlabel('Percentage error','FontSize',14,'interpreter','latex');
    ylabel('Number of grains','Fontsize',14,'interpreter','latex');
end

