clear all; close all; clc; format compact; warning off; tic
dir = [pwd '\TSK_model_4\'];

%% Load dataset
data = importdata('airfoil_self_noise.csv');
data = data.data;

%% %% Preprocess
[trnData,valData,chkData]=split_scale(data,1); 

%% FIS with grid partition
fis=genfis1(trnData,3,'gbellmf',"linear"); 
plotMFs(fis);                                
saveas(gcf,[dir 'MFs.png'])                 
epochs = 100;                               
[trnFIS,trnError,~,chkFIS, chkError]=anfis(trnData,fis,[epochs NaN NaN NaN NaN],[],valData,1); 
plotMFs(chkFIS)                             
saveas(gcf,[dir 'MFs_trn.png'])             

%% Learning curve: error VS epochs
figure;
plot(1:length(trnError),trnError,1:length(trnError),chkError);
title('Learning Curve');
legend('Traning Error', 'Check Error');
xlabel('# of Epochs');
ylabel('MSE');
saveas(gcf,[dir 'learning_curve.png'])

%% Prediction error
y_hat = evalfis(chkData(:,1:end-1),chkFIS);  % estimated from trained FIS
y = chkData(:,end);                          % real values from data (check set)

figure;
plot(1:length(y),y,'*r',1:length(y),y_hat, '.b');
legend('Reference Outputs','ANFIS Outputs');
saveas(gcf,[dir 'ref_vs_anfis_output.png'])

figure;
plot(y - y_hat);
title('Prediction Errors');
saveas(gcf,[dir 'prediction_error.png'])

%% MSE, RMSE, Rsq, NMSE, NDEI
MSE = mean((y - y_hat).^2);
RMSE = sqrt(MSE);

SSres = sum( (y - y_hat).^2 );
SStot = sum( (y - mean(y)).^2 );
Rsq = 1 - SSres / SStot;

NMSE = (sum( (y - y_hat).^2 )/length(y)) / var(y);
NDEI = sqrt(NMSE);

metrics_name = {'MSE';'RMSE';'R2';'NMSE';'NDEI'};
metrics_value = [MSE;RMSE;Rsq;NMSE;NDEI];
metrics_table = table(metrics_name,metrics_value);
writetable(metrics_table,[dir 'metrics.txt'])
disp('TSK Model 4');
disp(metrics_table)
toc