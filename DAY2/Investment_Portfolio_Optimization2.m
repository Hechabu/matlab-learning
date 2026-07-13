clc;
clear;

% 目标函数
c = [1 2 3 4 1 2 3 4]';


% 约束矩阵
Aeq = [
    1 -1 -1 1  -1 1 1 -1;
    1 -1 1 -3  -1 1 -1 3;
    1 -1 -2 3  -1 1 2 -3
    ];


% 右端值
beq = [
    0;
    1;
    -1/2
    ];


% 变量下界
LB = zeros(8,1);


% 求解
[y,z] = linprog(c,[],[],Aeq,beq,LB);


% 还原x
x = y(1:4)-y(5:8);


disp('x=')
disp(x)

disp('最小值z=')
disp(z)