function [M,fPWM,fmPWM]=testing_features_model(EEG,Y,Normalization,fs,Mdl1,Mdl2,Level_intervals,Levels,Level_intervals2,Levels2,PWM_P,PWM_N,PWMp_Mer1,PWMn_Mer1)
[EEG, f]=FFT_signals(EEG,fs);
if Normalization==1
EEG= zscore(EEG,0,2);
end

indp=find(Y==1); Xp=EEG(indp,:); yp=Y(indp); 
indn=find(Y~=1); Xn=EEG(indn,:); yn=0*Y(indn);

% build the dataset
X=[Xp;Xn]; y=[yp;yn];
%% PWM 
X= mapping_levels(X,Level_intervals, Levels);

fPWM= Generate_PWM_features(X, PWM_P, PWM_N);
[yfit0,scores] = predict(Mdl1,fPWM);
yfit0(yfit0>=0.5)=1;
yfit0(yfit0<0.5)=0;
score=scores(:,2);
[~,~,~,AUC] = perfcurve(y ,score,1);
[accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0]=prediction_performance(y, yfit0);
M(1,:)=[accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0,AUC];
%% mPWM quantization
X=[Xp;Xn]; y=[yp;yn];
Seq= mapping_levels(X,Level_intervals2, Levels2);
[PWMp_Mer1,PWMn_Mer1, PWMp_Mer2,PWMn_Mer2,PWMp_Mer3,PWMn_Mer3]= Generate_PWM8_matrix(Seq,y);
fmPWM = Generate_PWM8_features(Seq, PWMp_Mer1, PWMn_Mer1,[],[],[],[]);
% subplot(1,2,1),plot(PWMp_Mer1)
% subplot(1,2,2),plot(PWMn_Mer1)
[yfit,scores] = predict(Mdl2,fmPWM);
yfit(yfit>=0.5)=1;
yfit(yfit<0.5)=0;
score=scores(:,2);
[~,~,~,AUC2] = perfcurve(y ,score,1);
[accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0]=prediction_performance(y, yfit);
M(2,:)=[accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0,AUC2];

end 

