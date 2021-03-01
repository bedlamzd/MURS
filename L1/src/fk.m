function xi = fk(q)
%% Начальные значения
N = 6;
q0 = [0 0 pi/2 0 0 0];  % начальное положение
q = q + q0;             % смещение положения
a = [0 1 0 0 0 0];      % размеры вдоль x
alpha = [pi/2 0 pi/2 -pi/2 pi/2 0]; % угол вокруг x
d = [1 0 0 1 0 1];      % размеры вдоль z

T_rel_to_prev_link = cell(1, N);
for i = 1:N
    T_rel_to_prev_link{i} = ht(q(i), d(i), a(i), alpha(i));
end

% вычисляем матрицы однородного преобразования T06
T_abs = {eye(4)};
for i = 1:N
    T_abs{i+1} = T_abs{i}*T_rel_to_prev_link{i};
end

x = T_abs{end}(1,4);
y = T_abs{end}(2,4);
z = T_abs{end}(3,4);
R06 = T_abs{end}(1:3, 1:3); %(1.24)

%% Расчёт углов Эйлера из матрицы
R = R06;
if abs(R(3,3)) < 1
    phi = atan2(R(2,3), R(1,3));
    theta = atan2(sqrt(1-R(3,3)^2), R(3,3));
    psi = atan2(R(3,2), -R(3,1));
elseif R(3,3) == 1
    phi = 0;
    theta = 0;
    psi = atan2(R(2,1), R(1,1));
elseif R(3,3) == -1
    phi = atan2(-R(1,2), R(1,1));
    theta = pi;
    psi = 0;
end

xi = [x y z phi theta psi]; %ответ на задачу прямой кинемтатики
