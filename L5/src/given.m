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


% матрица вязкого трения
F = [
    rho(9) 0;
    0 rho(10)
    ];

A_ref = [1 1];      % амплитуды
psi_ref = [0 0];    % фазы
omega_ref = [1 2];  % частоты

w_ref_0 = [
    A_ref(1)*sin(psi_ref(1)),...
    omega_ref(1)*A_ref(1)*cos(psi_ref(1)),...
    A_ref(2)*sin(psi_ref(2)),...
    omega_ref(2)*A_ref(2)*cos(psi_ref(2))
    ];

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

k_p = [100 100];
K_p = diag(k_p);

k_d = [100 100];
K_d = diag(k_d);

kappa = 1000;

A1 = [
    10 1;
    1 10
    ];
A2 = [
    20 2;
    2 20
    ];

A = [
    -A2 eye(size(A2));
    -A1 zeros(size(A1))
    ];

% остальные матрицы зависят от q и объявлены функциями
