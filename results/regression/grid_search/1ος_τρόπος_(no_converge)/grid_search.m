%% Clear
clear all; close all; clc; warning off;
dir = [pwd '\grid_search\'];
tic

%% Load Data
data = importdata('superconductivity.csv');
data = data.data;

%% Preprocess
[trnData,valData,chkData] = split_scale(data,1);

%% Features selection with Relief algorithm
disp('Feature selection (Relief algorithm)...');
shuffledData = [trnData;valData;chkData];
[ranks, ~] = relieff(shuffledData(:, 1:end - 1), shuffledData(:, end),100, 'method','regression'); % 100 nearest neighbours

%% Values 2 check for features and radiuses
features_arr = [2 11 19 31]; % number of features
radii = [0.15 0.35 0.55 0.75 0.95; 
        0.15 0.35 0.55 0.75 0.95; 
        0.15 0.35 0.55 0.75 0.95; 
        0.15 0.35 0.55 0.75 0.95]; 
rules_arr = NaN*ones(length(features_arr),length(radii));  % holds number of rules for each model  
error_arr = inf*ones(length(features_arr), length(radii)); % holds mean model error for each model
count = 1; % iterates for every model 

%% Grid Search Algorithm
disp('Grid Search...')
for f = 1 : length(features_arr)
    for r = 1 : length(radii)
        
        c = cvpartition(trnData(:, end), 'KFold', 5); % 5-Folds Cross Validation by default 80-20 trn and chk
        MSE = zeros(c.NumTestSets, 1); % error for model count
        fis = genfis2(trnData(:, ranks(1:features_arr(f))), trnData(:, end), radii(f, r));
        rules_arr(f, r) = length(fis.rule); % no of rules
        
        if (rules_arr(f, r) == 1 || rules_arr(f,r) > 100) % if there is only one rule we cannot create a fis, so continue to next values
            continue; % or more than 100, continue, for speed reason
        end
        
        disp(' ');
        disp(['TSK Model ', num2str(count), ' / ', num2str(length(features_arr)*length(radii))]);
        disp(['Number of features: ',num2str(features_arr(f))]);
        disp(['Radius : ',num2str(radii(f,r))]) ;
        disp(['Number of rules : ',num2str(rules_arr(f,r))]) ;
        fprintf('Fold: ');
        
        for i = 1 : c.NumTestSets % 5 Folds
            fprintf(' %1.0f ',i);
            trnIdx = c.training(i); % find training idx
            chkIdx = c.test(i); %find check idx
            trnDataCV = trnData(trnIdx,[ranks(1:features_arr(f)), end]); % 80% of the trnData as training data by default, take just features_arr(f) features
            chkDataCV = trnData(chkIdx,[ranks(1:features_arr(f)), end]); % 20% of the trnData as check data by default, take just features_arr(f) features            
            anfis_opt = anfisOptions('InitialFis',fis,'EpochNumber',100, 'DisplayANFISInformation',0,'DisplayErrorValues',0,'DisplayStepSize',0,'DisplayFinalResults',0,'ValidationData',[chkDataCV(:,1:end-1) chkDataCV(:,end)]); % use validation data to avoid overfitting            
            [trnFIS, trnError, ~, chkFIS, chkError] = anfis([trnDataCV(:,1:end-1) trnDataCV(:,end)], anfis_opt); % tune FIS
            y_pred = evalfis(valData(:, ranks(1:features_arr(f))), chkFIS); % calculate output
            y = valData(:, end); % real output
            MSE(i) = (norm(y-y_pred))^2/length(y); % MSE
        end
        disp(' ');
        disp(['MSE = ',num2str(mean(MSE))]);
        error_arr(f, r) = mean(MSE); % calculate mean error of the 5 folds - this is model's error   
        count = count + 1;
    end
end
save('error_arr.mat','error_arr');
disp('Grid Search finished.');

%% 2D Plot of All Model Errors
figure;
sgtitle('2D Plot of All Model Errors');
for i=1:length(features_arr)
    subplot(2,2,i);
    bar(error_arr(i,:))
    xticklabels(string(radii'));
    xlabel('radii');
    ylabel('MSE'); 
    legend([num2str(features_arr(i)),' features'])
end
saveas(gcf,[dir 'mean_model_errors_2D.png'])

%% 3D Plot of All Model Errors
figure;
bar3(error_arr);
ylabel('Number of Features');
yticklabels(string(features_arr));
xticklabels(string(radii'));
xlabel('radii');
zlabel('MSE');
title('3D Plot of All Model Errors');
saveas(gcf,[dir 'mean_model_errors_3D.png'])

%% Find optimal model
disp('Optimal model...')
idx = min(error_arr(:)); % set minimum after we observe matrix error_arr
[row,col] = find(error_arr==idx); 
optNumFeatures = features_arr(row);        % number of features of optimal model
optNumRad = radii(row,col);           % number of rules of optimal model
featureIdx = sort(ranks(1:optNumFeatures));
disp('Optimum Model Found:');
disp(['Number of Features : ',num2str(optNumFeatures)]);
disp(['Radius : ',num2str(optNumRad)]) ; 
save('opt_model.mat','optNumFeatures','optNumRad','featureIdx') % save optimum model