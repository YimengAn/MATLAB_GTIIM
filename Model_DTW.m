% Program Name: Dynamic Time Warping model (DTW)
% Data Input: Time series sequences
% Result Output: DTW Distance
% Make sure to define the 'GetMin' and 'GetMinIndex' functions for your code to run successfully.

clc;
clear all;
format short g;
fprintf(2,'Dynamic Time Warping distance:\n')


%% Data Input (the end row is the reference sequence)
sheetNames = sheetnames("Pollution.xlsx");
pollutants = size(sheetNames,1);
% Select research indicators (e.g. sheetNames{1} = AQI)
Pollution = readtable('Pollution.xlsx',"ReadRowNames",false,"ReadVariableNames",false,...
    "Sheet",sheetNames{1},"Range","B2:Y29"); % Read as table

refer = Pollution{end,:};
data = Pollution{1:end-1,:};
[object,time] = size(data); 

%% Calculate DTW distance
DTW_degree=[];
for z = 1:object
    % Generate two time series with significant translation properties
    x = refer;
    y = data(z,:);
    x_len = length(x);
    y_len = length(y);
    plot(1:x_len,x); hold on
    plot(1:y_len,y); hold on
    
    % Compute the distance matrix for each feature point of the two sequences
    distance = zeros(x_len,y_len);
    for i = 1:x_len
        for j=1:y_len
            distance(i,j) = (x(i)-y(j)).^2;
        end
    end
    
    % Calculate the cumulative distance matrix
    DP = zeros(x_len,y_len);
    DP(1,1) = distance(1,1);
    for i=2:x_len
        DP(i,1) = distance(i,1)+DP(i-1,1);
    end
    for j=2:y_len
        DP(1,j) = distance(1,j)+DP(1,j-1);
    end
    for i=2:x_len
        for j=2:y_len
            DP(i,j) = distance(i,j) + GetMin(DP(i-1,j),DP(i,j-1),DP(i-1,j-1));
        end
    end
    
    % Backtrack to find the matching relationship between each feature point
    i = x_len;
    j = y_len;
    while(~((i == 1)&&(j==1)))
        plot([i,j],[x(i),y(j)],'b');hold on 
            % Plot the matching relationship between feature points
        if(i==1)
            index_i = 1;
            index_j = j-1;
        elseif(j==1)
            index_i = i-1;
            index_j = 1;
        else
        [index_i,index_j] = GetMinIndex(DP(i-1,j-1),DP(i-1,j),DP(i,j-1),i,j);
        end
        i = index_i;
        j = index_j;  
    end
    DTW_degree = [DTW_degree,DP(1,time)];
end

% Result Output
disp('DTW_distance:');
disp(DTW_degree);

