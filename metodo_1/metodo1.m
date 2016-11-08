clear;
clc;
%-------------------variables simbolicas
syms x1 x2 obj rest restli;
%-------------------fin variables simbolicas
%-------------------lectura y verificación de función objetivo
obj = sym(input('Por favor digite z : ', 's'));
degree = feval(symengine, 'degree', obj);
punto = input('Digite un punto Xi arbitrario de la forma [a,b]: ');
if degree > 1
    fprintf('Hay que linealizar la función objetivo \n');
    restli(j) = sym(subs(obj,[x1 x2],punto) + subs(gradient(obj)',[x1 x2], punto)*([x1 x2]'-punto' ))
else
    lb = [punto(1),punto(1)];
    ub = [punto(2),punto(2)];
    f = double(coeffs(obj));
    A=[];
    b=[];
    Aeq=[];
    beq=[];
    X = linprog(f,A,b,Aeq,beq,lb,ub);
    X = round(X)'
end
%-------------------fin lectura y verificación de función objetivo
fprintf('Por favor digite las restricciones en el siguiente formato :\n');
fprintf('ejemplo [x1^2 + 3; x1 + 2 + x2] :\n');
rest = sym(input('Puede digitar las restricciones aqui : ', 's'));
clc;
fprintf('El programa de optimizacion a resolver ingresado es el siguiente :\n');
fprintf('funcion objetivo : \n');
pretty(obj);
fprintf('sujeto a :\n');
pretty(rest);
j=0;
for i=1:length(rest)
    degree = feval(symengine, 'degree', rest(i));
    if degree > 1
        j = j + 1; 
        fprintf('Hay que linealizar la siguiente ecuacion : \n');
        pretty(rest(i));
        % Voy a llamar la funcion para linelizar
        restli(j) = sym(subs(rest(i),[x1 x2],X) + subs(gradient(rest(i))',[x1 x2], X)*([x1 x2]'-X' ))
    end
end
input('para continuar presione cualquier caracter : ', 's')
g = 3*x1^2 -2*x1*x2 + x2^2 - 1;
obj = x1-x2
c = coeffs(neweq)
A = double([c(3) c(2)])
b = double([-c(1)])
x = linprog(f,A,b,Aeq,beq,lb,ub)'
disp(subs(g,[x1 x2], x))
disp(subs(obj,[x1 x2], x))