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

condition = 0;
k = 1;
X(k,:) = punto;
while(condition == 0)
    step3 = 0;
    step5 = 1;
   % cuando itere spunto sera el punto anterior y punto sera el nuevo

    for i=1:length(rest) %PASO 2
        [c,matches] = strsplit(char(rest(i)),'\s*<=|>=|=\s*','DelimiterType','RegularExpression');%separamos la ecuacion
        Gxi = double(subs(sym(c{1}),[x1 x2], X(k,:)));
        if(Gxi >= 0)
            step3 = 1;
            break;
        end
    end
    
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
            Gx1 = subs(diff(sym(c{1}), x1),[x1 x2], X(k,:));
            Gx2 = subs(diff(sym(c{1}), x2),[x1 x2], X(k,:));
            Reqi = [[Gx1 Gx2 1] yAux(i,:)];
            beq = [beq;Gx1 + Gx2];
            Aeq = [Aeq;Reqi];
            last = i + 1;
        end
        Fx1 = subs(diff(obj, x1),[x1 x2], X(k,:));
        Fx2 = subs(diff(obj, x2),[x1 x2], X(k,:));
        Reqi = [[Fx1 Fx2 1] yAux(last,:)];
        beq = [beq;Fx1 + Fx2];
        Aeq = [Aeq;Reqi];
        vAux = [eye(2) [0;0]];
        [n, m] = size(Aeq);
        for i=1:(numOfY - n)
            last = last + 1;
            Reqi = [vAux(i,:) yAux(last,:)];
            Aeq = [Aeq;Reqi];
            beq = [beq;2];
        end
        Xl = linprog(F, [], [], double(Aeq), double(beq), zeros(numOfVar, 1));
        Si = [(Xl(1) - 1) (Xl(2) - 1)];
        if(Xl(3) <= e1) %PASO 4
            step5 = 0; 
        end
    else
        Si = -subs(gradient(obj),[x1 x2], X(k,:))';
        Si = Si / max(abs(Si(:)));
    end    

    %PASO 5
    if(step5 == 1)
        Fl = subs(obj,[x1 x2], X(k,:) + l * Si); % Funcion con la que se haya el lamda
        lamda = double(solve(diff(Fl, l), l));
        X(k+1,:) = X(k,:) + lamda * Si; %En esta parte spunto es el punto actual

        for i=1:length(rest) %PASO 2 reutilizacion verificar que no viola la condicion las restricciones
            [c,matches] = strsplit(char(rest(i)),'\s*<=|>=|=\s*','DelimiterType','RegularExpression');%separamos la ecuacion
            Gxi = subs(sym(c{1}),[x1 x2], X(k+1,:));
            if(Gxi > str2num(c{2}))
                Gxi2 = subs(sym(c{1}),[x1 x2], [0 0]);
                lamda = double(- (Gxi2 / (Gxi - Gxi2)) * lamda);
                X(k+1,:) = [lamda lamda];
                break;
            end
        end

        %PASO 6
        Fx1 = double(subs(obj, [x1 x2], X(k,:)));
        Fx2 = double(subs(obj, [x1 x2], X(k+1,:)));
        
        %PASO 7
        value1 = abs((Fx1 - Fx2) / Fx1);
        value2 = abs(norm(X(k,:) - X(k+1,:)));
    end
    if(value1 <= e2 && value2 <= e3 || step5 == 0)
        condition = 1;
    else
        condition = 0;
        k = k + 1;
    end
end
Z = double(subs(obj, [x1 x2], X(k,:)));
fprintf('El punto optimo encontrado es: \n');
disp(X(k,:));
fprintf('Evaluado en la funcion objetivo da: \n');
disp(Z);

time = toc;
fprintf('El tiempo en segundo es el siguiente : \n');
disp(time);