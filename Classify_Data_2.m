%% Classify_Data
function [Mdl,accuracy,sensitivity,specificity,precision,gmean,f1score,AUC,ytrue,yfit,score]= Classify_Data_2(type_clf, X_train, y_train, X_test, y_test)


switch type_clf
    case 'LR'
        [Mdl,accuracy,sensitivity,specificity,precision,gmean,f1score,AUC,ytrue,yfit,score]= LR_classifier(X_train, y_train, X_test, y_test);

    case 'SVM'
        [Mdl,accuracy,sensitivity,specificity,precision,gmean,f1score,AUC,ytrue,yfit,score]= SVM_classifier(X_train, y_train, X_test, y_test);
end


function [CompactSVMModel,accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0,AUC,y_test,yfit,score]= SVM_classifier(X_train, y_train, X_test, y_test)
global feature_type

CVSVMModel=fitcsvm(X_train,y_train,'Holdout',0.1);%SVM

CompactSVMModel = CVSVMModel.Trained{1}; % Extract trained, compact classifier
[yfit,scores] = predict(CompactSVMModel,X_test);
if class(yfit)=="cell"
yfit=cell2mat(yfit);
yfit=str2num(yfit);
end
yfit(yfit>=0.5)=1;
yfit(yfit<0.5)=0;

[accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0]=prediction_performance(y_test , yfit);

%% Compute the ROC curve
score=scores(:,2);
[~,~,~,AUC] = perfcurve(y_test ,score,1);
%% Plot the ROC curve.
% figure;
% plot(X,Y)
% xlabel('False Positive Rate (FPR)') 
% ylabel('True Positive Rate (TPR)')
% title('ROC')
% legend(strcat(feature_type(1:end-1), {''},' AUC=',num2str(AUC),' - SVM'))
% set(gca,'fontsize',16)
% grid on

function [CompactSVMModel,accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0,AUC,y_test,yfit,score]= LR_classifier(X_train, y_train, X_test, y_test)
global feature_type

% CVSVMModel=fitcsvm(X_train,y_train,'Holdout',0.1);%SVM

CompactSVMModel=fitglm(X_train, y_train,'linear','Distribution','binomial','link', 'logit');%Logistic regression

% CompactSVMModel = CVSVMModel.Trained{1}; % Extract trained, compact classifier
[yfit,scores] = predict(CompactSVMModel,X_test);
if class(yfit)=="cell"
yfit=cell2mat(yfit);
yfit=str2num(yfit);
end
yfit(yfit>=0.5)=1;
yfit(yfit<0.5)=0;

[accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0]=prediction_performance(y_test , yfit);

%% Compute the ROC curve
score=scores(:,2);
[~,~,~,AUC] = perfcurve(y_test ,score,1);
%% Plot the ROC curve.
% figure;
% plot(X,Y)
% xlabel('False Positive Rate (FPR)') 
% ylabel('True Positive Rate (TPR)')
% title('ROC')
% legend(strcat(feature_type(1:end-1), {''},' AUC=',num2str(AUC),' - SVM'))
% set(gca,'fontsize',16)
% grid on


