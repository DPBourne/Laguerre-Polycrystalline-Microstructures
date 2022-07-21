
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

%%% Specify whether the microstructure is simulated or not

singlephase=true;
dualphase=false;
lognormal=false;

%%% Single phase run times

if(singlephase)
    disp('Single phase')
    for idx_n=1:nn
        % For each number of cells

        disp(sprintf('Calculating run times for n = %d',n(idx_n)));
        
        % Initial guess is always w=0
        w_0=zeros(n(idx_n),1);
        
        for idx_exp=1:nexp
            fprintf('\t Experiment number %d',idx_exp);
            % For each experiment
            [X,target_vols]=nPhase(n(idx_n),1,bx);

            % Store the X and target_vols
            X_sp{idx_n,idx_exp}=X;
            tv_sp{idx_n,idx_exp}=target_vols;

            tic
            [w,max_percent_err,actual_vols,EXITFLAG] = SDOT_damped_Newton(w_0,X,target_vols,bx,periodic,percent_tol);
            t=toc;

            fprintf(' : completed in %f\n',t);
            % Store the solution for w
            w_sp{idx_n,idx_exp}=w;

            runtime_sp(idx_n,idx_exp)=t;
        end

        disp(sprintf('Average run time %f',mean(runtime_sp(idx_n,:)')));        
    end
end

%%% Dual phase run times

if(dualphase)
    % Set a size ratio
    r=5;

    % Set a fraction of seeds that are the smaller phase
    f=0.5;

    disp('Dual phase');

    for idx_n=1:nn,
        % For each number of cells

        disp(sprintf('Calculating run times for n = %d',n(idx_n)));
        
        % Initial guess is always w=0
        w_0=zeros(n(idx_n),1);
        
        for idx_exp=1:nexp
            fprintf('\t Experiment number %d',idx_exp);
            % For each experiment

            pn=round(n(idx_n)*[f 1-f]);
            vr=[1 r];
            
            [X,target_vols]=nPhase(pn,vr,bx);

            % Store the X and target_vols
            X_dp{idx_n,idx_exp}=X;
            tv_dp{idx_n,idx_exp}=target_vols;

            tic
            [w,max_percent_err,actual_vols,EXITFLAG] = SDOT_damped_Newton(w_0,X,target_vols,bx,periodic,percent_tol);
            t=toc;

            fprintf(' : completed in %f\n',t);
            % Store the solution for w
            w_dp{idx_n,idx_exp}=w;

            runtime_dp(idx_n,idx_exp)=t;
        end
        
        disp(sprintf('Average run time %f',mean(runtime_dp(idx_n,:)')));
        
    end
end

%%% Log-normal distribution run times

if(lognormal)
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
            
            fprintf('\t Experiment number %d',idx_exp);
            % For each experiment

            % Seed locations
            X=rand(n(idx_n),3);

            % Target Volumes 
            rad=lognrnd(mu,sigma,n(idx_n),1);
            target_vols=(rad.^3)/(prod(bx)*sum(rad.^3));
            
            % Store the X and target_vols
            X_ln{idx_n,idx_exp}=X;
            tv_ln{idx_n,idx_exp}=target_vols;

            tic
            [w,max_percent_err,actual_vols,EXITFLAG] = SDOT_damped_Newton(w_0,X,target_vols,bx,periodic,percent_tol);
            t=toc;

            
            fprintf(' : completed in %f\n',t);
            % Store the solution for w
            w_ln{idx_n,idx_exp}=w;

            runtime_ln(idx_n,idx_exp)=t;
        end

        disp(sprintf('Average run time %f',mean(runtime_ln(idx_n,:)')));
        
    end

end