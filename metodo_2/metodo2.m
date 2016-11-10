% Laboratorio de optimizacion 
% Metodo 1
% Roberto Daza, Mauricio Guzman, Alexander Taborda.
% 2016
% ZOUTENDIJK’S METHOD OF FEASIBLE DIRECTIONS

tic
clear;
clc;
%-------------------variables simbolicas
syms x1 x2 obj rest restli l;
%-------------------fin variables simbolicas
%-------------------lectura y verificación de función objetivo
obj = sym(input('Por favor digite z : ', 's'));
punto = input('Digite un punto Xi arbitrario de la forma [a,b]: ');

fprintf('Por favor digite las restricciones en el siguiente formato :\n');
fprintf('ejemplo [x1^2 + 3<= 3; x1 + 2 + x2 <= 4 ] :\n');
rest = sym(input('Puede digitar las restricciones aqui : ', 's'));
% e1 = input('Digite la tolerancia E1: ');
% e2 = input('Digite la tolerancia E2: ');
% e3 = input('Digite la tolerancia E3: ');

e1 = 0.001;
e2 = 0.001;
e3 = 0.01;

fprintf('El programa de optimizacion a resolver ingresado es el siguiente :\n');
fprintf('funcion objetivo : \n');
pretty(obj);
fprintf('sujeto a :\n');
pretty(rest);
fprintf('con una tolerancia E1, E2 y E3 de: %d, %d, %d\n', e1, e2, e3);

Fx1 = subs(obj, [x1 x2], punto);
spunto = punto;
step3 = 0;



punto = spunto; % cuando itere spunto sera el punto anterior y punto sera el nuevo

for i=1:length(rest) %PASO 2
    [c,matches] = strsplit(char(rest(i)),'\s*<=|>=|=\s*','DelimiterType','RegularExpression');%separamos la ecuacion
    rest(i) = sym(c{1});
    Gxi = subs(rest(i),[x1 x2], punto);
    if(Gxi == 0)
        step3 = 1;
        break;
    end
end

Si = subs(gradient(obj),[x1 x2],punto)';

if(step3 == 1) %PASO 3 y 4
    
end

Si = Si / min(Si);

%PASO 5
Fl = subs(obj,[x1 x2], (punto + l * Si)); % Funcion con la que se haya el lamda

lamda = max(solve(Fl, l));

spunto = punto + lamda*Si; %En esta parte spunto es el punto actual

spunto


time = toc;
fprintf('El tiempo en segundo es el siguiente : \n');
disp(time);