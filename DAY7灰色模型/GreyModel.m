clc;
clear;

%% 1. 输入原始数据
x0 = [120 132 145 160 178 195];

% 需要预测的未来期数
predictNum = 3;

n = length(x0);

%% 2. 一次累加生成
x1 = cumsum(x0);

%% 3. 构造背景值
z1 = 0.5 * (x1(1:end-1) + x1(2:end));

%% 4. 构造矩阵 B 和向量 Y
B = [-z1' ones(n-1,1)];
Y = x0(2:end)';

%% 5. 使用最小二乘法估计参数 a 和 b
u = B \ Y;

a = u(1);
b = u(2);

fprintf('发展系数 a = %.6f\n', a);
fprintf('灰色作用量 b = %.6f\n', b);

%% 6. 计算累加序列的预测值
x1_hat = zeros(1,n + predictNum);

for k = 0:n + predictNum - 1
    x1_hat(k+1) = ...
        (x0(1) - b/a) * exp(-a*k) + b/a;
end

%% 7. 累减还原原始序列
x0_hat = zeros(1,n + predictNum);

x0_hat(1) = x0(1);

for k = 2:n + predictNum
    x0_hat(k) = x1_hat(k) - x1_hat(k-1);
end

%% 8. 输出拟合值
fprintf('\n原始数据与拟合数据：\n');

for k = 1:n
    fprintf('第%d期：原始值 = %.2f，拟合值 = %.2f\n', ...
        k,x0(k),x0_hat(k));
end

%% 9. 输出未来预测值
fprintf('\n未来预测结果：\n');

for k = 1:predictNum
    fprintf('第%d期预测值 = %.2f\n', ...
        n+k,x0_hat(n+k));
end

%% 10. 计算相对误差
relativeError = abs(x0 - x0_hat(1:n)) ./ x0;

fprintf('\n平均相对误差 = %.2f%%\n', ...
    mean(relativeError) * 100);

%% 11. 绘图
t1 = 1:n;
t2 = 1:n + predictNum;

plot(t1,x0,'o-', ...
    t2,x0_hat,'*-');

xlabel('时间');
ylabel('数值');
legend('原始数据','GM(1,1)拟合与预测');
title('GM(1,1)灰色预测结果');
grid on;