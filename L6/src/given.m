%% Параметры механизма
m = [1 1];      % масса звеньев
l = [1 1];      % длина звеньев
lc = [.5 .5];   % расст от СК звена до центра масс звена
I = [1 1];      % моменты инерции звеньев
Jm = [0 0];     % момент инерции редукторов?
r = [1 1];      % передаточные числа редукторов
D = [.1 .1];    % агрегированные коэффициенты демпфирования

g = 9.81;       % ускорение свободного падения


global rho;
rho = [
    m(1)*lc(1)^2 + m(2)*l(1)^2 + 2*m(2)*l(1)*lc(2)^2 + I(1),... % rho_1
    m(2)*lc(2)^2 + I(2),...                                     % rho_2
    m(2)*l(1)*lc(2),...                                         % rho_3
    r(1)^2*Jm(1),...                                            % rho_4
    r(2)^2*Jm(2),...                                            % rho_5
    (m(1)*lc(1) + m(2)*l(1))*g,...                              % rho_6
    m(2)*lc(2)*g,...                                            % rho_7
    m(2)*lc(2),...                                              % rho_8
    r(1)^2*D(1),...                                             % rho_9
    r(2)^2*D(2)                                                 % rho_10
    ];


q_ref = [1 2];
c2 = cos(q_ref(2));

% матрица номинального момента инерции манипулятора
M0 = [
    rho(1) + rho(2) + 2*rho(3)*c2 + rho(4), rho(2) + rho(3)*c2;
    rho(2) + rho(3)*c2, rho(2) + rho(5);
    ];

% матрица вязкого трения
Friction = [
    rho(9) 0;
    0 rho(10)
    ];

%% Параметры генераторов
% Задающий блок
A_ref = [1 1];      % амплитуды
psi_ref = [0 0];    % фазы
omega_ref = [1 2];  % частоты

w_ref_0 = [
    A_ref(1)*sin(psi_ref(1)),...
    omega_ref(1)*A_ref(1)*cos(psi_ref(1)),...
    A_ref(2)*sin(psi_ref(2)),...
    omega_ref(2)*A_ref(2)*cos(psi_ref(2))
    ]';

Sref1 = [
    0 1;
    -omega_ref(1)^2 0
    ];
Sref2 = [
    0 1;
    -omega_ref(2)^2 0
    ];

Sref = blkdiag(Sref1, Sref2);

H_ref_p1 = [1 0];
H_ref_p2 = [1 0];
H_ref_p = blkdiag(H_ref_p1, H_ref_p2);

H_ref_v1 = [0 1];
H_ref_v2 = [0 1];
H_ref_v = blkdiag(H_ref_v1, H_ref_v2);

H_ref_a1 = [-omega_ref(1)^2 0];
H_ref_a2 = [-omega_ref(2)^2 0];
H_ref_a = blkdiag(H_ref_a1, H_ref_a2);

% Возмущающий блок
A_dist = [30 40];       % амплитуды
C_dist = [5 6];         % свободный член
psi_dist = [7 8];       % фазы
omega_dist = [1 2];     % частоты

w_dist_0 = [
    C_dist(1);
    A_dist(1)*sin(psi_dist(1));
    omega_dist(1)*A_dist(1)*cos(psi_dist(1));
    C_dist(2);
    A_dist(2)*sin(psi_dist(2));
    omega_dist(2)*A_dist(2)*cos(psi_dist(2))
    ];

Sdist1 = [
    0 0 0
    0 0 1;
    0 -omega_dist(1)^2 0
    ];
Sdist2 = [
    0 0 0
    0 0 1;
    0 -omega_dist(2)^2 0
    ];

Sdist = blkdiag(Sdist1, Sdist2);

H_dist_1 = [1 1 0];
H_dist_2 = [1 1 0];
H_dist = blkdiag(H_dist_1, H_dist_2);

f = [1 3 3];
F_1 =[
    zeros(2, 1) eye(2);
    -f
    ];
F_2 =[
    zeros(2, 1) eye(2);
    -f
    ];
F = blkdiag(F_1, F_2);

G_1 = [0 0 1]';
G_2 = [0 0 1]';
G = blkdiag(G_1, G_2);

Gamma_1 = f - [0 omega_dist(1)^2 0];
Gamma_2 = f - [0 omega_dist(2)^2 0];
Gamma = blkdiag(Gamma_1, Gamma_2);
%% Параметры регулятора
kappa = 1000;

K =[
    1 0 1 0;
    0 1 0 1
    ];

N = inf;

A0 = [
    30 3;
    3 30
    ];
A1 = [
    30 3;
    3 30
    ];
A2 = [
    10 1;
    1 10
    ];

A = [
    -A2 eye(size(A2)) zeros(size(A2));
    -A1 zeros(size(A1)) eye(size(A1));
    -A0 zeros(size(A0)) zeros(size(A0));
    ];
% остальные матрицы зависят от q и объявлены функциями
