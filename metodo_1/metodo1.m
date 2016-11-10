% Laboratorio de optimizacion 
% Metodo 2
% Roberto Daza, Mauricio Guzman, Alexander Taborda.
% 2016
%SLP SEQUENTIAL LINEAR PROGRAMMING
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
    obj = sym(subs(obj,[x1 x2],punto) + subs(gradient(obj)',[x1 x2], punto)*([x1 x2]'-punto' ))
end
lb = [punto(1),punto(1)];
ub = [punto(2),punto(2)];
f = fliplr(double(coeffs(obj)));
A=[];
b=[];
Aeq=[];
beq=[];
X = round(linprog(f,A,b,Aeq,beq,lb,ub),4)'
%-------------------fin lectura y verificación de función objetivo
fprintf('Por favor digite las restricciones en el siguiente formato :\n');
fprintf('ejemplo [x1^2 + 3<= 3; x1 + 2 + x2 <= 4 ] :\n');
rest = sym(input('Puede digitar las restricciones aqui : ', 's'));
tol = input('Digite la tolerancia: ');
fprintf('El programa de optimizacion a resolver ingresado es el siguiente :\n');
fprintf('funcion objetivo : \n');
pretty(obj);
fprintf('sujeto a :\n');
pretty(rest);
fprintf('con una tolerancia de: %d\n',tol);
tic
%-----------------------tratamiento y linealización de las restricciones
for i=1:length(rest)
    [c,matches] = strsplit(char(rest(i)),'\s*<=|>=|=\s*','DelimiterType','RegularExpression');%separamos la ecuacion
    syms eq value
    rest(i) = sym(c{1});
    degree = feval(symengine, 'degree', rest(i));
    if degree > 1
        fprintf('Hay que linealizar la siguiente ecuacion : \n');
        pretty(rest(i));
        restli(i) = sym(subs(rest(i),[x1 x2],X) + subs(gradient(rest(i))',[x1 x2], X)*([x1 x2]'-X' ));
        temp = double(coeffs(restli(i))); %para despejar la ecuación
        if (strcmp(matches,'=')) %toco linealizar, se mira el tipo de restriccion y se agrega donde corresponde
            Aeq = [temp(3),temp(2)];
            beq = double(coeffs(sym(c{2}))) + temp(1)*-1;
        else
            A = [temp(3),temp(2)];
            b = double((sym(c{2}))) + temp(1)*-1;
        end
    else %no se tiene que linealizar, se mira el tipo de restriccion y se agrega donde corresponde
        restli(i)= rest
        temp = double(coeffs(restli(i)));
        if (strcmp(matches,'='))
            Aeq = [temp(3),temp(2)];
            beq = double(coeffs(sym(c{2}))) + temp(1)*-1;
        else
            A = [temp(3),temp(2)]
            b = double((sym(c{2}))) + temp(1)*-1;
        end
    end
end
%--------------------end---------------------------------------------
sw = 1;
j=0;
row=0;
col = 0;
cont = 1;
m = zeros(1, 1);
iterCont = 0;
while sw == 1
    cont = cont + 1;
    j = j + 1;
    row = row+1;
    col=1;
    m(row,col) = fix(cont);
    X = linprog(f,A,b,Aeq,beq,lb,ub)';
    
    col = col+1;
    m(row,col) = X(1);
    col = col+1;
    m(row,col)=X(2);
    
    for i=1:length(rest)
        respuestas(j)= round(double(subs(rest(i),[x1,x2],X)),6);
        m(row, col+1) = respuestas(j);
        if subs(rest(i),[x1,x2],X) <= tol
            sw = 0;
        end
    end
    if sw == 1
        for i=1:length(rest)
            degree = feval(symengine, 'degree', rest(i));
            if degree > 1
                restli(i) = sym(subs(rest(i),[x1 x2],X) + subs(gradient(rest(i))',[x1 x2], X)*([x1 x2]'-X' ))
                temp = double(coeffs(restli(i)));
                A = [A;temp(3),temp(2)];
                b = [b;temp(1)*-1];
            end
        end
    end
    iterCont = iterCont + 1; 
end
fprintf('La tabla de resultado es la siguiente: \n');
m
fprintf('El numero de iteraciones es el siguiente : \n' );
disp(iterCont);
time = toc;
fprintf('El tiempo en segundo es el siguiente : \n');
disp(time);
