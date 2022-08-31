    %% Quantization
    fprintf('\n ---> Quantization')
    if clustering==1
        Seq_train= mapping_levels(X_train_k,Level_intervals, Levels);
        Seq_train2= mapping_levels(X_train,Level_intervals, Levels);

    else
        Seq_train= mapping_levels(X_train,Level_intervals, Levels);
    end
    Seq_test= mapping_levels(X_test,Level_intervals, Levels);

    %% Build the PWM matrices   Mers1 Mer2
   fprintf('\n ---> Build the PWM matrices   Mers1, Mers2')
   
   if clustering==1
   [PWMp_Mer1,PWMn_Mer1, PWMp_Mer2,PWMn_Mer2,PWMp_Mer3,PWMn_Mer3]= Generate_PWM8_matrix(Seq_train,y_train_k);
   else
   [PWMp_Mer1,PWMn_Mer1, PWMp_Mer2,PWMn_Mer2,PWMp_Mer3,PWMn_Mer3]= Generate_PWM8_matrix(Seq_train,y_train);
   end
    %% Generate PWM features using   Mers1 Mer2

    fprintf('\n ---> Generate PWM features using PWMs: Mers1, Mers2')
    if clustering==1
        fPWM_train= Generate_PWM8_features(Seq_train2, PWMp_Mer1, PWMn_Mer1,PWMp_Mer2,PWMn_Mer2,PWMp_Mer3,PWMn_Mer3);       
    else
        fPWM_train= Generate_PWM8_features(Seq_train, PWMp_Mer1, PWMn_Mer1,PWMp_Mer2,PWMn_Mer2,PWMp_Mer3,PWMn_Mer3);       
    end
    fPWM_test = Generate_PWM8_features(Seq_test,  PWMp_Mer1, PWMn_Mer1,PWMp_Mer2,PWMn_Mer2,PWMp_Mer3,PWMn_Mer3);
    