%  程序名称: Dynamic Time Warping
%  数据输入：各数组序列
%  结果输出：DTW距离
clc,clear all;
format short g;
fprintf(2,'Dynamic Time Warping distance：\n')

%% %%%%%%%%%%%%%%%%%%%%%%%% 将.xls数据文件添加到路径 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% %%%%%%%%%%%%%%%%%%%%%%%% 计算DTW distance %%%%%%%%%%%%%%%%%%%%%%
% 数据输入（第一行为参照序列）
sheetNames = sheetnames("AQI.xls");
data = readtable('AQI.xls',"ReadRowNames",false,"ReadVariableNames",false,"Sheet",sheetNames{28},"Range","C2:Z29"); % 读入table
data = data{:,:}; % table 转 matrix
[m,n] = size(data); % m=m1+1，n=n1

DTW_degree=[];
object = 27;
for z = 1:object
    %生成两个有明显平移性质的时间序列
    x = data(1,:);
    y = data(z+1,:);
    x_len = length(x);
    y_len = length(y);
%     plot(1:x_len,x);hold on
%     plot(1:y_len,y);hold on
    %计算两序列每个特征点的距离矩阵
    distance = zeros(x_len,y_len);
    for i = 1:x_len
        for j=1:y_len
            distance(i,j) = (x(i)-y(j)).^2;
        end
    end
    %计算两个序列
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
    %回溯，找到各个特征点之间的匹配关系
    i = x_len;
    j = y_len;
    while(~((i == 1)&&(j==1)))
        plot([i,j],[x(i),y(j)],'b');hold on %画出匹配之后的特征点之间的匹配关系
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
    DTW_degree = [DTW_degree,DP(1,24)];
end

% 结果输出
disp('DTW_distance:');
disp(DTW_degree);

