%  程序名称: Pearson correlation coefficient
%  程序功能: 计算两组序列间的皮尔逊相关系数
%  数据输入：各数组序列
%  结果输出：Pearson 相关系数
clc,clear all;
format short g;
fprintf(2,'Pearson_cc：\n')



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 内容一：TCGR关联度矩阵计算 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  1. 数据输入
data_degree=[];
sheetNames = sheetnames("AQI.xls");
object = 28    % object = 研究对象个数

%1.1 数据输入（第一行为参照序列）
data = readtable('AQI.xls',"ReadRowNames",false,"ReadVariableNames",false,"Sheet",sheetNames{28},"Range","C2:Z29"); % 读入table
data = data{:,:}; % table 转 matrix
[m,n] = size(data); % m=m1+1，n=n1

data_standard = [];
      for i = 1:m
          max_i = max(data(i,:));                              
          min_i = min(data(i,:));
          for j = 1:n
              data_standard(i,j) = (max_i-data(i,j))/(max_i-min_i);
              %data_standard(i,j) = (data(i,j)-min_i)/(max_i-min_i);
          end
      end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  内容二：Pearson 相关系数 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Per = [];
P_value = [];
for s = 1:m-1
    [rho,pval] = corr(data(1,:)',data(s+1,:)','Type','Pearson');
    Per = [Per;rho];
    P_value = [P_value;pval];    
end

% 结果输出
disp('Pearson_cc:');
disp(P_value);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  内容三：距离度量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Che = pdist(data,"chebychev"); 
Mar = pdist(data,"mahalanobis");  %马氏距离
EU = pdist(data,"euclidean");  %欧式距离
 