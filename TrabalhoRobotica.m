clear 
clc 
clf
mdl_puma560
startup_rvc
%Definindo a distância da base da ferramenta à sua extremidade
p560.tool = transl(0, 0, 0.18);
%Definindo posições iniciais do robô e da bola
pos_cima = p560.fkine(qr); 
p_inicial = pos_cima.t'; 
ball = [0.5 0 0.8]; 

%Definindo orientação dos pontos de início da trajetória e os pontos de destino 
ball_o = [0 pi/2 0];
inicio_o = [0 0 0];
fim_o = [0 -pi/2 0];

%Definindo o passo diferencial da trajetória
t = [0:0.05:0.5]'; 

%Definindo espaçamento angular entre cada vértice do dodecágono
angulo = [0:30:330]';

%Distância entre o vértice do dodecágono ao centro(raio)
raio = 0.05/cosd(75);

%Array de espaçamento entre os centros de cada dodecágono
x_ini = [-0.75;-0.65;-0.55;-0.45];

%Inicialização da variável path
path = [p_inicial];
orientations = [inicio_o];

%Rotina de repetição
for k = 1:4
    %Inicializa vetor auxiliar com valor k de x_ini(posição inicial do x) 
    vetor = x_ini(k);
    %Aumenta o vetor para 12 posições iguais
    for j = 1:11
        vetor = [vetor; x_ini(k)];
    end
    %12 posições do vértice do dodecágono
    posicoes = posicao_planar(angulo,raio,0,0.2);
    %Agrupa as posições em x(vetor) com as posições em y e z (definidas
    %pelo dodecágono)
    pos_trid = [vetor, posicoes];
    %Montando o path de busca e entrega da bola
    for v = 1:12
        path = [path; ball];
        path = [path; pos_trid(v,:)];
    end
end

%Adicionando a posição final do robô
path = [path;p_inicial];
%Obtem tamanho path
size = length(path)- 1;

%Montando array de orientações
for o = 1: size/2
    orientations = [orientations;ball_o];      %Orientação da bola
    orientations = [orientations;fim_o];       %Orientação dos destinos
end
%Orientação final
orientations = [orientations;inicio_o];

%plotando a primeira esfera
plot_sphere(ball, 0.05, 'y'); 
ae = [138 8]; %perspectiva 

for i = 1:size  
    row_ini = i;   
    row_fim = i + 1;
    %Matriz do ponto inicial da trajetoria 
    Tini = transl(path(row_ini,:))* trotx(orientations(row_ini,1))* troty(orientations(row_ini,2))* trotz(orientations(row_ini,3));   
    %Matriz do ponto final da trajetoria
    Tfim = transl(path(row_fim,:))* trotx(orientations(row_fim,1))* troty(orientations(row_fim,2))* trotz(orientations(row_fim,3));
    %Matriz espaço da junta do ponto inicial
    qini = p560.ikine6s(Tini);    
    %Matriz espaço da junta do ponto final
    qfim = p560.ikine6s(Tfim);
    %Calculo da trajetória com passo 't'
    Qtraj = jtraj(qini, qfim, t);
    %Animação robô
    p560.plot(Qtraj); 
    %Verificando se a ferramenta está no início ou fim da trajetória
    if ( i ~= 1 ) && ( i ~= size )  
        plot_sphere([Tfim(1,4), Tfim(2,4), Tfim(3,4)], 0.05, 'y');    
    end
end
