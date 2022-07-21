% Example_5_2.m
%
% This is Example 5.2 from the paper 'Geometric modelling of 
% polycrystalline materials: Laguerre tessellations and periodic 
% semi-discrete optimal transport' by D.P. Bourne, M. Pearce & S.M. Roper.
%
% In this example we monitor the number of Newton iterations and back-tracking steps
% in 100 draws of 100,000 log-normally distributed grain volumes.

clear

%%% Specify box dimensions

bx=[1,1,1];

%%% Specify periodicity

periodic=true;

%%% Specify maximal percentage error

percent_tol=1;

%%% Specify different number of seeds to be considered

n=[1000];
nn=length(n);

%%% Specify number of experiments for each number of seeds
nexp=100;

%%% Log-normal backtracking

% Parameters in log-normal distribution
ln_mean=1;
std_dev=0.35;
sigma=sqrt((log(1+(std_dev/ln_mean)^2)));
mu=-0.5*sigma^2;

disp('Log-normal')
for idx_n=1:nn,
    
    % For each number of cells

    disp(sprintf('Calculating run times for n = %d',n(idx_n)));
    
    % Initial guess is always w=0
    w_0=zeros(n(idx_n),1);
    
    for idx_exp=1:nexp
        % For each experiment
        fprintf('\t Experiment number %d',idx_exp);
        
        % Seed locations
        X=rand(n(idx_n),3);

        % Target Volumes 
        rad=lognrnd(mu,sigma,n(idx_n),1);
        target_vols=(rad.^3)/(prod(bx)*sum(rad.^3));
        
        % Store the X and target_vols in case later interrogation is required
        X_ln{idx_n,idx_exp}=X;
        tv_ln{idx_n,idx_exp}=target_vols;

        % Time the damped Newton method
        tic
        [w,max_percent_err,actual_vols,EXITFLAG,back_track_steps,newton_step_errors,w_steps] = SDOT_damped_Newton_diagnostic(w_0,X,target_vols,bx,periodic,percent_tol);
        t=toc;
        
        fprintf(' : completed in %f\n',t);
        
        % Store the solution for w
        w_ln{idx_n,idx_exp}=w;

        % Store the deails of each Newton iteration and the error after each Newton iteration
        runtime_ln(idx_n,idx_exp)=t;
        back_track_ln{idx_n,idx_exp}=back_track_steps;
        newton_errors_ln{idx_n,idx_exp}=newton_step_errors;
    end

    disp(sprintf('Average run time %f',mean(runtime_ln(idx_n,:)')));
end

%% Plot the results


% Assume that n is a 1 x nn array of cell numbers
% Assume that back_track_ln is an nn x nexp cell array of backtracking information

[nn,nexp]=size(back_track_ln);

for k=1:nn,
    back_track_exp=back_track_ln(k,:);

    % First find maximum number of Newton steps
    newt_steps=cellfun('length',back_track_exp);
    mns=max(newt_steps);
    data=-1*ones(nexp,mns);

    % Extract the data from the back-tracking cell array
    for j=1:nexp,
        data(j,1:length(back_track_exp{j}))=back_track_exp{j};
    end

    % Sort the data for ease of visualisation
    data=sortrows(data);

    % The maximum number of back-tracking steps
    mbs=max(max(data));

    % Make a new figure, one for each number of cells
    figure(k)
    
    % Plot the number of back-tracking steps
    image(1:mns,1:nexp,data,'CDataMapping','scaled')

    % Make a discrete palette
    cmap=jet(mbs+2);
    % Make -1 correspond to white
    cmap(1,:)=[1 1 1];

    
    colormap(cmap);
    cbh=colorbar;
    ch=(mbs)/(mbs+1);
    cbh.Ticks=linspace(0.5*ch, mbs-0.5*ch, mbs+1) ; %Create 8 ticks from zero to 1
    cbh.TickLabels=num2cell(0:mbs);
    cbh.Limits=[0,mbs];
    xlabel('Newton iteration','Interpreter','latex','Fontsize',12)
    ylabel('Experiment number','Interpreter','latex','Fontsize',12)
    xlim([0.5,mns+0.5]);
    ylim([0.5,nexp+0.5]);

    set(gca,'YDir','normal','TickLabelInterpreter','latex','Fontsize',10,'box','off');
    set(gca,'XTickLabelMode','manual');
    set(gca,'XTickLabels',num2cell(1:mns));
    set(gca,'XTickMode','manual');
    set(gca,'XTick',1:mns);
    
    hold on
    for l=1:mns-1,
        plot(0.5+[l l],[0.5,nexp+0.5],'k');
    end

    for l=1:nexp,
        % Number of Newton steps
        ns=sum(data(l,:)>=0);
        plot([0 ns+0.5],0.5+[1 1]*l,'w','LineWidth',0.25);
    end
    hold off

    set(cbh,'TickLabelInterpreter','latex');
    axis square
    
end
