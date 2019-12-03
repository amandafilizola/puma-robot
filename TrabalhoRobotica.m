clear 
clc 
clf
mdl_puma560
p560.tool = transl(0, 0, 0.18);
pos_cima = p560.fkine(qr); 
p_inicial = pos_cima.t'; 
ball = [0.5 0 0.8]; 

ball_o = [0 pi/2 0];
inicio_o = [0 0 0];
fim_o = [0 -pi/2 0];
t = [0:0.05:0.5]'; 
angulo = [0:30:330]';
raio = 0.05/cosd(75);
x_ini = [-0.75;-0.65;-0.55;-0.45];

path = [p_inicial];
orientations = [inicio_o];

for k = 1:4
    vetor = x_ini(k);
    for j = 1:11
        vetor = [vetor; x_ini(k)];
    end
    posicoes = posicao_planar(angulo,raio,0,0.2);
    pos_trid = [vetor, posicoes];
    for v = 1:12
        path = [path; ball];
        path = [path; pos_trid(v,:)];
    end
end

path = [path;p_inicial];
size = length(path)- 1;

for o = 1: size/2
    orientations = [orientations;ball_o];
    orientations = [orientations;fim_o];
end
orientations = [orientations;inicio_o];

%plotando a primeira esfera
plot_sphere(ball, 0.05, 'y'); 
size = length(path)- 1;
ae = [138 8]; %perspectiva 

for i = 1:size  
    row_ini = i;   
    row_fim = i + 1;
    Tini = transl(path(row_ini,:))* trotx(orientations(row_ini,1))* troty(orientations(row_ini,2))* trotz(orientations(row_ini,3));   
    Tfim = transl(path(row_fim,:))* trotx(orientations(row_fim,1))* troty(orientations(row_fim,2))* trotz(orientations(row_fim,3));
    qini = p560.ikine6s(Tini);    
    qfim = p560.ikine6s(Tfim);
    Qtraj = jtraj(qini, qfim, t);
    p560.plot(Qtraj);       
    if ( i ~= 1 ) && ( i ~= size )  
        plot_sphere([Tfim(1,4), Tfim(2,4), Tfim(3,4)], 0.05, 'y');    
    end
end
 







