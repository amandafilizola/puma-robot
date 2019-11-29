function result = posicao_planar(angulo, raio, y0, z0)
%angulo precisa ser este vetor coluna dos angulos
%angulo = [0:30:330]'
% y0 e z0 são as distancias iniciais
    y = raio*cosd(angulo)+ y0;
    z = raio*sind(angulo)+ z0;
    result = [y,z];
end