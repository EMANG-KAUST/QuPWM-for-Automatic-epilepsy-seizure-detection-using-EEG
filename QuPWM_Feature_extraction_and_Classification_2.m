   
%% ###############   Biomedical signals classification 2019 ############################
% This script detects epileptic spikes bases on Quantization based Position Weight Matrices (QuPWM)

%% ###########################################################################
%  Author:
%  Abderrazak Chahid (abderrazak.chahid@gmail.com)
% Done: Dec,  2018
%
%% ###########################################################################
warning('off');
global kk y clustering Normalization

%% ###########################################################################
beta=0;EN_starplus=0;

if exist('Comp_results_Table','var') == 0 , Comp_results_Table = table;  end                   % Table to save results

for EN_FFT=1
        X=X0;y=y0; y_PatientID=y_PatientID0;
        global y_patient
        y_patient=y_PatientID;     
    
   %% Feature generation  & Classification
            Obtain_FFT                 

    %% ### PWM-based Classification 
         list_M=[6,8,12];
         list_k=[3,6];

    %% PWM-based features
        tic
             PWM2_Classification_2;
        Time_PWM2=toc

    %% PWM8-based features
        kk=1;
        clustering=0;
        tic
           PWM8_Classification_2;
        Time_PWM8=toc

%     end
end
 
fprintf('\n################  Data classification Round is done  ################\n\n')
