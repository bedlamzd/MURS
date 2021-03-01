%функция однородного преобразования 
function [T] = ht(q, d, a, alpha)

cq = cos(q);
sq = sin(q);

ca = cos(alpha);
sa = sin(alpha);

T1 = [
    cq -sq 0 0;
    sq  cq 0 0;
     0   0 1 0;
     0   0 0 1
    ];
T2 = [
    1 0 0 0;
    0 1 0 0;
    0 0 1 d;
    0 0 0 1
    ];
T3 = [
    1 0 0 a;
    0 1 0 0;
    0 0 1 0;
    0 0 0 1
    ];
T4 = [
    1  0   0 0;
    0 ca -sa 0;
    0 sa  ca 0;
    0  0   0 1
    ];

T = T1 * T2 * T3 * T4;
end
