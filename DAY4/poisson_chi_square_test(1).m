clc;
clear;

%% 原始数据
% 印刷错误个数：0,1,2,3,4,5,6,>=7
error_num = 0:6;
freq = [36, 40, 19, 2, 0, 2, 1, 0];

n = sum(freq);                         % 总页数

%% 1. 估计泊松分布参数 lambda
% 因为“>=7”的频数为0，所以样本均值可直接按0~6计算
lambda_hat = sum(error_num .* freq(1:7)) / n;

%% 2. 合并组别
% 卡方拟合优度检验要求每组理论频数一般不小于5。
% 因此把3,4,5,6,>=7合并成“>=3”一组。
observed = [freq(1), freq(2), freq(3), sum(freq(4:end))];

% 对应的泊松分布理论概率：P(X=0), P(X=1), P(X=2), P(X>=3)
p0 = poisspdf(0, lambda_hat);
p1 = poisspdf(1, lambda_hat);
p2 = poisspdf(2, lambda_hat);
p_ge3 = 1 - poisscdf(2, lambda_hat);

probability = [p0, p1, p2, p_ge3];
expected = n * probability;

%% 3. 计算卡方统计量
chi2_stat = sum((observed - expected).^2 ./ expected);

% 自由度 = 合并后的组数 - 1 - 估计参数个数
% 这里有4组，并估计了1个参数lambda
df = length(observed) - 1 - 1;

alpha = 0.05;
critical_value = chi2inv(1 - alpha, df);
p_value = 1 - chi2cdf(chi2_stat, df);

% h=1表示拒绝原假设，h=0表示不拒绝原假设
h = chi2_stat > critical_value;

%% 4. 输出结果
fprintf('样本总数 n = %d\n', n);
fprintf('泊松参数估计值 lambda = %.4f\n', lambda_hat);
fprintf('卡方统计量 chi2 = %.4f\n', chi2_stat);
fprintf('自由度 df = %d\n', df);
fprintf('临界值 chi2_(0.95,%d) = %.4f\n', df, critical_value);
fprintf('p值 = %.4f\n', p_value);
fprintf('检验结果 h = %d\n\n', h);

group_name = {'0'; '1'; '2'; '>=3'};
result_table = table(group_name, observed', expected', ...
    'VariableNames', {'错误个数', '实际频数', '理论频数'});
disp(result_table);

if h == 0
    fprintf('在显著性水平 alpha = %.2f 下，不拒绝原假设。\n', alpha);
    fprintf('可以认为每页印刷错误个数服从参数为 %.4f 的泊松分布。\n', lambda_hat);
else
    fprintf('在显著性水平 alpha = %.2f 下，拒绝原假设。\n', alpha);
    fprintf('不能认为每页印刷错误个数服从泊松分布。\n');
end
