% Laboratorio de optimizacion 
% Metodo 1
% Roberto Daza, Mauricio Guzman, Alexander Taborda.
% 2016
% ZOUTENDIJK’S METHOD OF FEASIBLE DIRECTIONS

tic
clear;
clc;
%-------------------variables simbolicas
syms x1 x2 obj rest restli;
%-------------------fin variables simbolicas
%-------------------lectura y verificación de función objetivo
obj = sym(input('Por favor digite z : ', 's'));
punto = input('Digite un punto Xi arbitrario de la forma [a,b]: ');

fprintf('Por favor digite las restricciones en el siguiente formato :\n');
fprintf('ejemplo [x1^2 + 3<= 3; x1 + 2 + x2 <= 4 ] :\n');
rest = sym(input('Puede digitar las restricciones aqui : ', 's'));
e1 = input('Digite la tolerancia E1: ');
e2 = input('Digite la tolerancia E2: ');
e3 = input('Digite la tolerancia E3: ');

fprintf('El programa de optimizacion a resolver ingresado es el siguiente :\n');
fprintf('funcion objetivo : \n');
pretty(obj);
fprintf('sujeto a :\n');
pretty(rest);
fprintf('con una tolerancia E1, E2 y E3 de: %d, %d, %d\n', e1, e2, e3);






time = toc;
fprintf('El tiempo en segundo es el siguiente : \n');
disp(time);