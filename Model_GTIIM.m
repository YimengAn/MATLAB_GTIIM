% Program Name: GTIIM Model (Grey Tetrahedron Integrated Association Model)
% Program Function: Analyze the association degree between two time series
% Data Input: Reference and comparison sequences
% Result Output: 1. GTIIM Association Degree 2. Sequence Relationship Matrix 3. Clustering Graph

clc;
clear all;
format short g;
fprintf(2,'GTIIM Model (Grey Tetrahedron Integrated Association Model):\n')

%% Content One: GTIIM Association Degree Matrix Calculation
%% 1. Data Input
sheetNames = sheetnames("Pollution.xlsx");
pollutants = size(sheetNames,1);

data_degree = [];
for z = 1:pollutants
    Pollution = readtable('Pollution.xlsx',"ReadRowNames",false,"ReadVariableNames",false,...
        "Sheet",sheetNames{z},"Range","B2:Y29"); % Read as table
    % Reference sequence input
    refer = Pollution{end,:};
    data = Pollution{1:end-1,:};
    [object,time] = size(data);
    % Adjustment parameter input
    zeta = 0.1;
    
    %% 2. Constructing Differential Measures
    Delta_d = abs(data(:,2:end) - refer(2:end));
    Delta_t = abs(data(:,2:end) - data(:,1:end-1) - refer(2:end) + refer(1:end-1));
    V_ij = (1/6) * (Delta_d .* Delta_t);
    
    %% 3. Constructing Comprehensive Association Coefficients (garma)
    garma = 1 ./ (1 + zeta * V_ij);
    
    %% 4. Constructing Comprehensive Association Degree (Garma)
    Garma = mean(garma,2);
    data_degree = [data_degree, Garma];
    
end


%% 5. Adjusting Adjustment Parameter zeta
MAX = max(max(data_degree(data_degree>0 & data_degree<1)));
MIN = min(min(data_degree(data_degree>0 & data_degree<1)));
[x1, x2] = find(data_degree == MAX);
[y1, y2] = find(data_degree == MIN);

%% 6. Result Output
disp('association degree for cities in the YRD:');
disp(data_degree);



%% Content Two: Sequence Relationship Matrix Output
%% 1. Data Input
Obj = [1:object]';
Data_degree = [Obj,data_degree];

%% 2. Association Sequence (Order)
order = []; % Object/Index association sequence matrix
Order = []; % Sorted association degree matrix
for z = 1:pollutants
    degree_z = [Data_degree(:,1),Data_degree(:,z+1)];
    order_z = sortrows((degree_z),-2); 
    order1 = (order_z(:,1)); 
    order2 = (order_z(:,2)); 
    
    order = [order,order1];
    Order = [Order,order2];
end

%% 3. Result Output
disp('association sequence for cities in the YRD:');
disp(order);
