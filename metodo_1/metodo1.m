clear;
clc;
syms x1 x2 obj rest;
obj = sym(input('Por favor digite z : ', 's'));
fprintf('Por favor digite las restricciones en el siguiente formato :\n');
fprintf('ejemplo [x^2 + 3; x + 2 + y] :\n');
rest = sym(input('Puede digitar las restricciones aqui : ', 's'));
clc;
fprintf('El programa de optimizacion a resolver ingresado es el siguiente :\n');
fprintf('funcion objetivo : \n');
pretty(obj);
fprintf('sujeto a :\n');
pretty(rest);
input('para continuar presione cualquier caracter : ', 's')
clc;
g = 3*x1^2 -2*x1*x2 + x2^2 - 1;
f = [1,-1];
A=[];
b=[];
Aeq=[];
beq=[];
lb = [-2,-2];
ub = [2,2];
x = linprog(f,A,b,Aeq,beq,lb,ub);
x = round(x);
g2 = matlabFunction(g);
eval = g2(x(1), x(2));
gra = gradient(g, [x1, x2]);
grad = [round(subs(gra(1), [x1 x2], [x(1) x(2)])), round(subs(gra(2), [x1 x2], [x(1) x(2)]))].';
neweq = eval + grad*([x1 x2]-x.');
