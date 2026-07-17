clc;
clear;

% 原始数据矩阵（每行代表一个地区，每列代表一个指标）
X = [
    80 85 78 90;
    75 80 72 85;
    90 88 92 95;
    60 65 58 70;
    85 82 88 91;
    70 75 68 80;
    95 92 96 98;
    65 70 62 75
];

%% 标准化
Z = zscore(X);

%% 主成分分析
[coeff, score, latent, ~, explained] = pca(Z);

%% 累计贡献率
cumulative = cumsum(explained);

%% 选择累计贡献率达到85%的主成分
m = find(cumulative >= 85, 1);

fprintf('需要保留 %d 个主成分。\n', m);

disp('特征向量（主成分系数）：');
disp(coeff);

disp('各主成分特征值：');
disp(latent);

disp('各主成分贡献率（%%）：');
disp(explained);

disp('累计贡献率（%%）：');
disp(cumulative);

%% 综合评价
weights = explained(1:m) / sum(explained(1:m));
comprehensiveScore = score(:,1:m) * weights;

%% 排序
[sortedScore, index] = sort(comprehensiveScore, 'descend');

disp('地区编号及排序后得分：');
disp([index, sortedScore]);
