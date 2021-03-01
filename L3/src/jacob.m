function [J] = jacob(value)

N = 6;

q = sym('q', [1 N]);
a = [0 1 0 0 0 0];                  % расстояние вдоль x
alpha = [pi/2 0 pi/2 -pi/2 pi/2 0]; % угол вокруг x
d = [1 0 0 1 0 1];                  % расстояние вдоль z

T_rel_to_prev_link = cell(1, N);
for i = 1:N
    T_rel_to_prev_link{i} = ht(q(i), d(i), a(i), alpha(i));
end

% вычисляем матрицы однородного преобразования T06
T_abs = {eye(4)};
for i = 1:N
    T_abs{i+1} = T_abs{i}*T_rel_to_prev_link{i};
end

% вычисляем столбцы матрицы Якоби
J = sym('J1', [N N]);
for i = 1:N
   J(:, i) = [
       diff(T_abs{end}(1:3, 4), q(i));
       T_abs{i}(1:3, 3)
       ];
end

J = double(subs(J, q, value));
