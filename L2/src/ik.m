function q = ik(xi)

x = xi(1);
y = xi(2);
z = xi(3);
phi = xi(4);
theta = xi(5);
psi = xi(6);

% фиксированные параметры
a = [0 1 0 0 0 0];                  % расстояние вдоль x
alpha = [pi/2 0 pi/2 -pi/2 pi/2 0]; % угол вокруг x
d = [1 0 0 1 0 1];                  % расстояние вдоль z

p06 = [
    x;
    y;
    z
    ];

A1 = [
    cos(phi) -sin(phi) 0;
    sin(phi) cos(phi) 0;
    0 0 1
    ];
A2 = [
    cos(theta) 0 sin(theta);
    0 1 0;
    -sin(theta) 0 cos(theta)
      ];
A3 = [
    cos(psi) -sin(psi) 0;
    sin(psi) cos(psi) 0;
    0 0 1
      ];

R06 = A1 * A2 * A3;

p04 = p06 - d(6)*R06*[0 0 1]';

xc = p04(1);
yc = p04(2);
zc = p04(3);

% решаем обратную задачу
q(1) = atan2(yc,xc);
cosq3 = ((zc - d(1))^2 + xc^2 + yc^2 - a(2)^2 - d(4)^2) / (2*a(2)*d(4));
if fix(cosq3) == 1 % огругляем малые значения до нуля
    q(3) = 0;
    q(2) = atan2(zc-d(1), sqrt(xc^2+yc^2));
elseif fix(cosq3)==-1
    q(3)=pi;
elseif fix(cosq3)<1
    q(3)= atan2(sqrt(1-cosq3^2), cosq3);
end
q(2) = atan2(zc-d(1),sqrt(xc^2+yc^2))-atan2(d(4)*sin(q(3)), a(2)+d(4)*cos(q(3)));

% решаем прямую задачу до третьего звена
T01 = ht(q(1),d(1),a(1),alpha(1));
T12 = ht(q(2),d(2),a(2),alpha(2));
T23 = ht(q(3)+pi/2,d(3),a(3),alpha(3));

T02 = T01*T12;
T03 = T02*T23;
R03 = T03(1:3, 1:3);

R36 = R03'*R06;

R = R36;
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

q(4) = phi;
q(5) = theta;
q(6) = psi;
