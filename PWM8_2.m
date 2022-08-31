function [X_Training,y_Training,X_test,y_test]=PWM8_2(X,Y)

fs=173.61;
[X, f]=FFT_signals(X,fs);

indp=find(Y==1); Xp=X(indp,:); yp=Y(indp); Np=size(Xp,1);
indn=find(Y~=1); Xn=X(indn,:); yn=0*Y(indn);

X=[Xp;Xn]; y=[yp;yn];

[Xsp,Xsp0]=Split_classes_samples(X,y);
Xsp_pd = fitdist(Xsp(:),'Normal');
Xsp0_pd = fitdist(Xsp0(:),'Normal');
Xsp_Sigma=Xsp_pd.sigma;     Xsp0_Sigma=Xsp0_pd.sigma;     
Xsp_mu=Xsp_pd.mu;           Xsp0_mu=Xsp0_pd.mu;  
mu0=mean([Xsp_mu, Xsp0_mu]);  sigma0=mean([Xsp_Sigma, Xsp0_Sigma]);
kk=1;
global Levels kk
[Levels, Level_intervals]=Set_levels_Sigma(0.3,24,mu0,sigma0);

Seq= mapping_levels(X,Level_intervals, Levels);
% script_get_QuPWM_features_for_train_test_split_2
[PWMp_Mer1,PWMn_Mer1, PWMp_Mer2,PWMn_Mer2]= Generate_PWM8_matrix(Seq,y);
fPWM_test = Generate_PWM8_features(Seq, PWMp_Mer1, PWMn_Mer1,PWMp_Mer2,PWMn_Mer2);

[m,n] = size(fPWM_test);
P = 0.6;
idx = randperm(m);
X_Training = fPWM_test(idx(1:round(P*m)),:);    y_Training = Y(idx(1:round(P*m)),:); 
X_test = fPWM_test(idx(round(P*m)+1:end),:);    y_test = Y(idx(round(P*m)+1:end),:);

% [yfit0,scores] = predict(Mdl,fPWM_test);
% 
% if class(yfit0)=="cell"
% yfit0=cell2mat(yfit0);
% yfit0=str2num(yfit0);
% end
% 
% yfit0=yfit0-min(yfit0);
% yfit0=yfit0/max(yfit0);
% score=yfit0;
% yfit1=double(yfit0>0.5);
% [accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0,fmeasure,C]=prediction_performance(y_test, yfit1);
% [X,Y,T,AUC] = perfcurve(y_test ,score,1);

end 

