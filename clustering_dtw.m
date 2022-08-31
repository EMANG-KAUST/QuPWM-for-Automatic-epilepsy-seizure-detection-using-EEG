function [Xp1,Xn1,KP,KN,PWM_P,PWM_N]=clustering_dtw(Xp, Xn, cent,Level_intervals, Levels)
    [idxn,cn,sumdn,dn] = kmedoids(Xn,cent,'Distance',@dtwf);
    [idxp,cp,sumdp,dp] = kmedoids(Xp,cent,'Distance',@dtwf);
    for i=1:cent
        KN(i,:)=mean(Xn(idxn==i,:));
        KP(i,:)=mean(Xp(idxp==i,:));
    end
    Xp1= mapping_levels(KP,Level_intervals, Levels);
    Xn1= mapping_levels(KN,Level_intervals, Levels);
    PWM_P = Generate_PWM_matrix(Xp1, Levels);
    PWM_N = Generate_PWM_matrix(Xn1, Levels); 
end