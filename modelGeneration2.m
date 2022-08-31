function [Comp_results_Table, Mdl_SVM_mPWM, QuPWM_str,M_op1,K_op1,M_op2,K_op2] = modelGeneration2(X,y,frameLength,Step,chanRange,fs,Balanced,clustering,Normalization)

global y_PatientID max_TR_samples_per_class Balanced filename clustering
y_PatientID="Sub_UCI";
%% ###########################################################################
% input data and resuts  folders
data_Source='./Input_data/EEG-UCI/';
List_Data_files = dir(strcat(data_Source,'*.mat'));
CHs=1;Bi_Elctr=1;noisy_file='EEG-seizure';L_max=-1;Frame_Step=-1;y_PatientID="Sub_UCI";patient_k=1;suff="-";
Path_classification='/Result-EEG-classifiaction/';
Path_classification=char(strcat('./Projects-Results/',Path_classification));

%% Cross Validation parameters
global type_clf_list feature_type 
K=5;
CV_type_list=string({'KFold'});
type_clf_list=string({'LR'});
max_TR_samples_per_class=3000;


%% this loop applies the classification to number of files in the  <data_Source>  folder

if exist(Path_classification)~=7, mkdir(Path_classification); end

Comp_results_aLL = table;                     % Table to save result    
    
        X0=X;y0=y; y_PatientID0=y_PatientID;

                global Negative_sample_ratio_TS Negative_sample_ratio_TR Normalization

                for Negative_sample_ratio_TS=-1%[1  -1];
                    for Negative_sample_ratio_TR=-1%[1  3];

                        %% Apply the QuPWM feature extraction method
                             QuPWM_Feature_extraction_and_Classification_2
                             
                        %% Save partially Obtained results 
                        Comp_results_Table
                        Comp_results_aLL=[Comp_results_aLL;Comp_results_Table];    
                    end
                end

Comp_results_aLL
%% Save Obtained results on all the dataset
filename_results=strcat(Path_classification,num2str(size(List_Data_files,1)),feature_type,'Dataset_',FFT_specter,join(CV_type_list),'_',join(type_clf_list),'_On',string(datetime('now','Format','yyyy-MM-dd''T''HHmmss')))
save(strcat(filename_results,'.mat'),'Comp_results_aLL','List_Data_files','data_Source','Comp_results_Table')                                                                                                                    
% Excel sheet
writetable(Comp_results_Table,strcat(filename_results,'.xlsx'))

fprintf('\n################  The End ################\n\n')
                                   
end
