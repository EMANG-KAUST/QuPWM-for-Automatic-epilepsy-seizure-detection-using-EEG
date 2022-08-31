%% ####################   Classification paramter ############################
% This script sets the classification paramter to classify X,y data

%% ###########################################################################
%  Author:
%  Abderrazak Chahid (abderrazak.chahid@gmail.com)
% Done: Jan,  2019
%
%% For test purpose, use small data set by rndom sampling
FFT_specter='TimeSerie_';

%% get balanced data for training
if Balanced==1
    if exist('Xn')==0
        indp=find(y0==1); Xp=X0(indp,:); 
        indn=find(y0==0); Xn=X0(indn,:); 
    end
        
    Nn=size(Xn,1);  Np=size(Xp,1);  yp=ones(Np,1); yn=0*ones(Nn,1);
    Ndata=min(Nn,Np);
    
    X=[Xp(1:Ndata,:);Xn(1:Ndata,:)];
    y=[yp(1:Ndata,:);yn(1:Ndata,:) ];
    
    
    downSample=1;
    s = RandStream('mlfg6331_64'); Rndm_idx=randsample(s,Nn,Nn,false);
    Idx=1:Nn;
    Idx_random=Idx(Rndm_idx(1:Ndata));
end

%% Applay FFT to the Data
if EN_FFT==1
    [X, f]=FFT_signals(X,fs);FFT_specter='FFT_';
    fprintf(' --> Apply FFT transform to the time series datset \n ')
end

if Normalization == 1
    X= zscore(X,0,2);
end
%% Display
Bi_Elctr(CHs)=1; Conf_Elctr=bi2de(Bi_Elctr);
Electrode_list=CHs;

d_clf='--> Epeliptic seizure Classification  :' ;
d_data20=string(strcat('- Dataset: :  ',num2str(size(X,1)),' Samples. Each has   ',{' '},num2str(size(X,2)),' points;'));
fprintf('%s \n %s \n',d_clf,d_data20);
 