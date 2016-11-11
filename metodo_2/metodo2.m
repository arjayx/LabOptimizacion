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
% obj = sym(input('Por favor digite z : ', 's'));
% punto = input('Digite un punto Xi arbitrario de la forma [a,b]: ');
% 
% fprintf('Por favor digite las restricciones en el siguiente formato :\n');
% fprintf('ejemplo [x1^2 + 3<= 3; x1 + 2 + x2 <= 4 ] :\n');
% rest = sym(input('Puede digitar las restricciones aqui : ', 's'));
% e1 = input('Digite la tolerancia E1: ');
% e2 = input('Digite la tolerancia E2: ');
% e3 = input('Digite la tolerancia E3: ');

obj = sym('x1^2+x2^2-4*x1-4*x2+8');
punto= [0 0];
rest = sym('[x1 + 2*x2 - 4 <= 0]');

e1 = 0.001;
e2 = 0.001;
e3 = 0.01;

fprintf('El programa de optimizacion a resolver ingresado es el siguiente :\n');
fprintf('funcion objetivo : \n');
pretty(obj);
fprintf('sujeto a :\n');
pretty(rest);
fprintf('con una tolerancia E1, E2 y E3 de: %d, %d, %d\n', e1, e2, e3);

spunto = punto;
condition = 0;
iteration = 0;
while(condition == 0)
    iteration = iteration + 1;
    step3 = 0;
    punto = spunto; % cuando itere spunto sera el punto anterior y punto sera el nuevo

    for i=1:length(rest) %PASO 2
        [c,matches] = strsplit(char(rest(i)),'\s*<=|>=|=\s*','DelimiterType','RegularExpression');%separamos la ecuacion
        Gxi = subs(sym(c{1}),[x1 x2], punto);
        if(Gxi == 0)
            step3 = 1;
            break;
        end
    end

    Si = subs(gradient(obj),[x1 x2],punto)';
    Si = Si / min(Si);

    if(step3 == 1) %PASO 3 y 4
        numOfY = 2 + length(rest) + 1;
        numOfVar = 2 + numOfY + 1;
        F = [[0 0 -1], zeros(1, numOfY)]; %calcular F
        yAux = eye(numOfY);
        Aeq = [];
        beq = [];
        last = 0;
        for i=1:length(rest)
            [c,matches] = strsplit(char(rest(i)),'\s*<=|>=|=\s*','DelimiterType','RegularExpression');%separamos la ecuacion
            Gx1 = subs(diff(sym(c{1}), x1),[x1 x2], punto);
            Gx2 = subs(diff(sym(c{1}), x2),[x1 x2], punto);
            Reqi = [[Gx1 Gx2 1] yAux(i,:)];
            beq = [beq;Gx1 + Gx2];
            Aeq = [Aeq;Reqi];
            last = i + 1;
        end
        Fx1 = subs(diff(obj, x1),[x1 x2], punto);
        Fx2 = subs(diff(obj, x2),[x1 x2], punto);
        Reqi = [[Fx1 Fx2 1] yAux(last,:)];
        beq = [beq;Fx1 + Fx2];
        Aeq = [Aeq;Reqi];
        vAux = [eye(2) [1;1]];
        [n, m] = size(Aeq);
        for i=1:(numOfY - n)
            last = last + 1;
            Reqi = [vAux(i,:) yAux(last,:)]
            Aeq = [Aeq;Reqi];
            beq = [beq;2];
        end
        A = [1 0 0 0 0 0 0; 0 1 0 0 0 0 0; 0 0 1 0 0 0 0];
        b = [0;0;0];
        linprog(F, [], [], double(Aeq), double(beq), zeros(3,1))
        Si = [1 -0.7];
    end

    %PASO 5
    Fl = subs(obj,[x1 x2], punto + l * Si); % Funcion con la que se haya el lamda
    lamda = solve(diff(Fl, l), l);
    spunto = punto + lamda * Si; %En esta parte spunto es el punto actual
    
    double(spunto)
    
    for i=1:length(rest) %PASO 2 reutilizacion verificar que no viola la condicion las restricciones
        [c,matches] = strsplit(char(rest(i)),'\s*<=|>=|=\s*','DelimiterType','RegularExpression');%separamos la ecuacion
        Gxi = subs(sym(c{1}),[x1 x2], spunto);
        if(Gxi > str2num(c{2}))
            Gxi2 = subs(sym(c{1}),[x1 x2], [0 0]);
            lamda = - (Gxi2 / (Gxi - Gxi2)) * lamda;
            spunto = [lamda lamda];
            break;
        end
    end
    
    %PASO 6
    Fx1 = subs(obj, [x1 x2], punto);
    Fx2 = subs(obj, [x1 x2], spunto);

    %PASO 7
    value1 = abs((Fx1 - Fx2) / Fx1);
    value2 = norm(punto - spunto);
    if(value1 > e2 && value2 > e2)
        condition = 0;
    else
        condition = 1;
    end
    
    if(iteration == 2)
       break; 
    end
end

time = toc;
fprintf('El tiempo en segundo es el siguiente : \n');
disp(time);