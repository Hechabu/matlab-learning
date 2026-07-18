clc;
clear;

%% 1. 输入评价因素权重
% 教学内容、教学方法、教学态度、教学效果
A = [0.30 0.25 0.20 0.25];

%% 2. 输入原始评价人数
% 每一行代表一个评价因素
% 每一列依次代表：优秀、良好、一般、较差
number = [
    50 30 15 5;
    40 35 20 5;
    60 25 10 5;
    45 35 15 5
];

%% 3. 将评价人数转化为隶属度
% 每一行除以该行总人数
R = number ./ sum(number, 2);

disp('模糊关系矩阵 R：');
disp(R);

%% 4. 模糊综合评判
% 加权平均型模糊算子
B = A * R;

disp('模糊综合评判结果 B：');
disp(B);

%% 5. 根据最大隶属度原则确定评价等级
grades = {'优秀', '良好', '一般', '较差'};

[maxMembership, index] = max(B);

fprintf('最大隶属度为：%.4f\n', maxMembership);
fprintf('最终评价等级为：%s\n', grades{index});

%% 6. 计算综合评分
% 优秀、良好、一般、较差对应的分值
scoreVector = [100; 80; 60; 40];

comprehensiveScore = B * scoreVector;

fprintf('综合评分为：%.2f 分\n', comprehensiveScore);

%% 7. 输出完整评价结果
fprintf('\n各等级隶属度：\n');

for j = 1:length(grades)
    fprintf('%s：%.4f\n', grades{j}, B(j));
end
