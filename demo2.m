clc
clear all
close all

frameLength=800;
Step=frameLength;
chan=[1,306];
Balanced=0;
clustering=0;
Normalization=0;
problem=7;%1:A-E, 2:B-E, 3:C-E, 4:D-E, 5:AB-E, 6:CD-E, 7-ABCD-E
DatasetFilenames='data2.mat';
fs=173.61;
[X,y]=generate_data(DatasetFilenames,frameLength,Step,fs,Normalization,Balanced,problem);
 
%% Split training 70% and testing 30% data
rand_pos = randperm(size(X,1));
X=X(rand_pos,:); %Shuffle EEG
y=y(rand_pos,:); %Shuffle labels
indp=find(y==1); Xp=X(indp,:); yp=y(indp); Np=size(Xp,1);
indn=find(y~=1); Xn=X(indn,:); yn=0*y(indn);

[m,~] = size(Xp) ;
[n,~] = size(Xn) ;
P = 0.70 ;

Training_X=[Xp(1:round(P*m),:);Xn(1:round(P*n),:)];
Testing_X=[Xp(round(P*m)+1:end,:);Xn(round(P*n)+1:end,:)];
Training_y=[yp(1:round(P*m),:);yn(1:round(P*n),:)];
Testing_y=[yp(round(P*m)+1:end,:);yn(round(P*n)+1:end,:)];
%% Train and validate model
[Comp_results_Table,Mdl_SVM_mPWM, QuPWM_str,M1,k1,M2,k2] = modelGeneration2(Training_X,...
    Training_y,frameLength,Step,chan, fs,Balanced,clustering, Normalization);
%% Test model obtained
[M]=testing_features_model(Testing_X,Testing_y,Normalization,fs,...
    QuPWM_str.Mdl,Mdl_SVM_mPWM.Mdl,QuPWM_str.Level_intervals,...
    QuPWM_str.Levels,Mdl_SVM_mPWM.Level_intervals,Mdl_SVM_mPWM.Levels,...
    QuPWM_str.PWM_P,QuPWM_str.PWM_N,Mdl_SVM_mPWM.PWM_P,Mdl_SVM_mPWM.PWM_N);
