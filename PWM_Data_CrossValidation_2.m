%% PWM_Data_CrossValidation
%% Apply Leave One Out CV with PWM features using diffferent classifers
% X: The data  sample
% y  The Class
% clf: The calssifier:{'nbayes','logisticRegression','SVM','','',''}
% function [accuracy1,sz_fPWM]= Classify_LeaveOut_PWM(X,y,clf)
function [sz_fPWM, Avg_Accuracy,Avg_sensitivity,Avg_specificity,Avg_precision,Avg_gmean,Avg_f1score,Avg_AUC,Mdl_op]=PWM_Data_CrossValidation_2(X, y,CV_type_list, K,type_clf_list,clustering)

global Levels Level_intervals  y_PatientID L 


if strcmp(CV_type_list,'LOO')==1
    C = cvpartition(y, 'LeaveOut');
    
    fprintf('------------------------------------------------------------------\n')
    fprintf('            Leave-One-Out Cross Validation using %s           \n',type_clf_list )
    fprintf('------------------------------------------------------------------\n')

elseif strcmp(CV_type_list,'KFold')==1
    C = cvpartition(y, 'KFold',K);
    
    fprintf('------------------------------------------------------------------\n')
    fprintf('            The %d-Folds Cross Validation using %s           \n',K,type_clf_list )
    fprintf('------------------------------------------------------------------\n')

else
    fprintf('\n --> Error: undefined Cross-Validation : %s',CV_type_list);

end

Sen_max=0;
for num_fold = 1:C.NumTestSets
    clearvars  PWM_* XP Xn
    
    trIdx = C.training(num_fold);                                            teIdx = C.test(num_fold);
    
    X_train= X(trIdx,:);                                                     X_test= X(teIdx,:); 
    y_train= y(trIdx);                                                       y_test= y(teIdx);
    
    %% Get the positive and negative training samples to build PWM matrices
    Xp=X_train(y_train==1,:);   Np=size(Xp, 1);
    Xn=X_train(y_train==0,:);   Nn=size(Xn, 1);
    
    if abs(Np-Nn)>2
        fprintf('Non balanced training data\n\n')
    else
        fprintf('Balanced training data\n\n')
    end
    
    %% Build the PWM matrices
    if clustering==1
        cent=10;  
        [Xp1,Xn1,KP,KN,PWM_P,PWM_N]=clustering_dtw(Xp, Xn, cent,Level_intervals, Levels);
        %% Quantization
        Xp= mapping_levels(Xp,Level_intervals, Levels);
        Xn= mapping_levels(Xn,Level_intervals, Levels);
    else
        %% Quantization
        Xp= mapping_levels(Xp,Level_intervals, Levels);
        Xn= mapping_levels(Xn,Level_intervals, Levels);
        PWM_P = Generate_PWM_matrix(Xp, Levels);
        PWM_N = Generate_PWM_matrix(Xn, Levels); 
    end

    %% PWM features generation 
    X_train_levels=[Xp;Xn];                                                 X_test_levels= mapping_levels(X_test, Level_intervals, Levels);
    fPWM_train= Generate_PWM_features(X_train_levels, PWM_P, PWM_N);        fPWM_test= Generate_PWM_features(X_test_levels, PWM_P, PWM_N);

        [Mdl,Accuracy(num_fold),sensitivity(num_fold),specificity(num_fold),precision(num_fold),gmean(num_fold),f1score(num_fold),AUC(num_fold),ytrue,yfit]=Classify_Data_2(type_clf_list, fPWM_train, y_train, fPWM_test, y_test);
      
        %% best model
        if sensitivity(num_fold)>Sen_max%Accuracy(num_fold)>Sen_max%sensitivity(num_fold)>Sen_max
            Mdl_op.Mdl=Mdl;
            Mdl_op.PWM_P=PWM_P;
            Mdl_op.PWM_N=PWM_N;
            Mdl_op.Level_intervals=Level_intervals;
            Mdl_op.Levels=Levels;
            Sen_max=sensitivity(num_fold);%Accuracy(num_fold)%sensitivity(num_fold)
        
        end
        
 subjects_names=join(unique(y_PatientID),"");
 path_python=strcat('./python/mat/PWM2/',subjects_names,'/',num2str(L));
 if exist(path_python)~=7, mkdir(path_python); end
 save(strcat(path_python,'/dataset_MEG',subjects_names,'L',num2str(L),'_fold',num2str(num_fold),'.mat'),'fPWM_train', 'y_train', 'fPWM_test', 'y_test','Accuracy')
 
end

%% Average Accuracy 
Avg_Accuracy = sum(Accuracy)/C.NumTestSets;
Avg_sensitivity = sum(sensitivity)/C.NumTestSets;
Avg_specificity = sum(specificity)/C.NumTestSets;
Avg_precision = sum(precision)/C.NumTestSets;
Avg_f1score = sum(f1score)/C.NumTestSets;
Avg_gmean = sum(gmean)/C.NumTestSets;
Avg_AUC=sum(AUC)/C.NumTestSets;
sz_fPWM=size(fPWM_train,2);


if exist('Mdl_op')==0
    Mdl_op=[];
end
end

