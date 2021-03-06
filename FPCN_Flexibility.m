function [Flexibility_index]=FPCN_Flexibility(Vectors_Across, Vectors_Within)

%computes the task-related flexibility of FPCN FC patterns by comparing the similarity of FC patterns within and across conditions
%run script seprately for FPCNa and FPCNb
%Input:
    %Vectors_Across: For each subject, it should be a set of FPCNa OR FPCNb vectors, where row is condition and column is the vector of FC values.
    %Vectors_Within: For each subject, it should be a set of FPCNa OR FPCNb vectors, where row is condition, and column is
    %the vector of FC values, and the 3rd dimension is 1st half data vs 2nd half data.
%Output:
    %Flexibility_index, which is the average within condition similarity - average between condition similarity

%% Compute across condition similarity          
            
vector_set={2:6 3:6 4:6 5:6 6}; %these numbers are based on having 6 conditions
all_correlations=[];

%This next part takes the vector for a given condition (e.g., i = 1 is condition 1) and compares it to the remaining
%conditions, one at a time (e.g., the conditions in vector_set{1}, that is, conditions 2-6). When i = 2, this is compared to vector set 2 (i.e., conditions 3-6), etc.

for i=1:5
    %r_values=[];
    r=[];
    for j = 1:length(vector_set{i})
        Vec_Corr=corrcoef(Vectors_Across(i,:),Vectors_Across(vector_set{i}(j),:)); % correlation between vectors for current pair of conditions
        r(j)=Vec_Corr(2); %holds correlations for a given condition vs all other conditions
    end    
       all_correlations=horzcat(all_correlations,r); % hold all correlations (all conditions against each other) 
    clear r_values
end
 
Z_r=.5.*log((1+all_correlations)./(1-all_correlations)); %Fisher transform correlations
across_similarity=nanmean(Z_r); %compute average similarity


%% Compute within-condition similarity
                    
for i = 1:6 % each condition
    Vec_Corr=corrcoef(Vectors_Within(i,:,1),Vectors_Within(i,:,2));%correlation between early period and late period vectors for a given condition
    r(i)=Vec_Corr(2); %store correlations
end

Z_r=.5.*log((1+r)./(1-r)); %Fisher transform correlations
within_similarity=nanmean(Z_r); %compute average similarity
                
                
 %% Compute flexibility index
 
 Flexibility_index=within_similarity-across_similarity;
end

 
 
 
                    
               
                
                
            