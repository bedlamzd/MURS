g = 9.81;

r0 = 5;
r1 = 10;
alpha = 0.9;

K = [-100 -100 -100 -10];

a0 = 0.01 ;
a1 = 1 ;
a2 = 1000 ;
a3 = 1000 ;
a4 = 10;
bar_B = [
    g 0;
    0 -g
    ];
N = 100;
kappa = 5;

%% Initial conditions
set = 4;
switch set
    case 1
    % first set
    x0 = 1;
    y0 = 1;
    z0 = 1;

    theta0 = pi/6;
    psi0 = pi/6;

    case 2
    % second set
    x0 = 1;
    y0 = 2;
    z0 = 3;

    theta0 = pi/6;
    psi0 = pi/4;

    case 3
    % third set
    x0 = -1;
    y0 = -1;
    z0 = -1;

    theta0 = -pi/6;
    psi0 = -pi/6;

    case 4
    % fourth set
    x0 = -1;
    y0 = -2;
    z0 = -3;

    theta0 = -pi/6;
    psi0 = -pi/4;

    otherwise
    % default set
    x0 = 0;
    y0 = 0;
    z0 = 0;

    theta0 = 0;
    psi0 = 0;

end
