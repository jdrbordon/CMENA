% Copyright 2016 Jacob David Rodríguez Bordón (jacobdavid.rodriguezbordon@ulpgc.es)
%                Guillermo Manuel Álamo Meneses (guillermo.alamo@ulpgc.es)

% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License.

% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.

% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

function polilineas=crear_dibujo_apoyo(tipo)
%crear_dibujo_apoyo Genera una variable estructura de datos con puntos y 
% lineas que dibuja un apoyo. El apoyo tiene dimensiones aproximadas
% de 1 unidad por 1 unidad, y el origen esta en el nudo del apoyo.
  switch tipo
    % Apoyo fijo horizontal
    case 'fijo'
      polilineas.n_puntos=17;
      polilineas.puntos=[0,0;-3,-7;3,-7;-5,-7;5,-7;-5,-8;-4,-7;-5,-10;...
        -2,-7;-3,-10;0,-7;-1,-10;2,-7;1,-10;4,-7;3,-10;5,-8];
      polilineas.puntos=0.1*polilineas.puntos;
      polilineas.n_lineas=9;
      polilineas.lineas=[1,2;1,3;4,5;6,7;8,9;10,11;12,13;14,15;16,17];
    % Apoyo carro articulado
    case 'carro_articulado'
      polilineas.n_puntos=35;
      polilineas.puntos=[0,0;-3,-5;3,-5;-5,-7;5,-7;-5,-8;-4,-7;-5,-10;
        -2,-7;-3,-10;0,-7;-1,-10;2,-7;1,-10;4,-7;3,-10;5,-8;
        -2+0.0000,-6+1.0000;-2-0.7071,-6+0.7071;-2-1.0000,-6+0.0000;
        -2-0.7071,-6-0.7071;-2+0.0000,-6-1.0000;-2+0.7071,-6-0.7071;
        -2+1.0000,-6+0.0000;-2+0.7071,-6+0.7071;-2+0.0000,-6+1.0000;
        2+0.0000,-6+1.0000; 2-0.7071,-6+0.7071; 2-1.0000,-6+0.0000;
        2-0.7071,-6-0.7071; 2+0.0000,-6-1.0000; 2+0.7071,-6-0.7071;
        2+1.0000,-6+0.0000; 2+0.7071,-6+0.7071; 2+0.0000,-6+1.0000];
      polilineas.puntos=0.1*polilineas.puntos;
      polilineas.n_lineas=26;
      polilineas.lineas=[1,2;1,3;2,3;4,5;6,7;8,9;10,11;12,13;14,15;16,17;
        18,19;19,20;20,21;21,22;22,23;23,24;24,25;25,26;
        27,28;28,29;29,30;30,31;31,32;32,33;33,34;34,35];
    % Apoyo elastico vertical
    case 'resorte_vertical'
      polilineas.n_puntos=19;
      polilineas.puntos=[0,0;0,-2;1,-2;-1,-3;1,-4;-1,-5;1,-6;0,-6;0,-7;
        -3,-7;3,-7;-3,-8;-2,-7;-3,-10;0,-7;-1,-10;2,-7;1,-10;3,-8];
      polilineas.puntos=0.1*polilineas.puntos;
      polilineas.n_lineas=13;
      polilineas.lineas=[1,2;2,3;3,4;4,5;5,6;6,7;7,8;8,9;10,11;12,13;
        14,15;16,17;18,19];
    % Apoyo resorte giro
    case 'resorte_giro'
      polilineas.n_puntos=22;
      polilineas.puntos=[0,0;0,-1;-0.71,-0.71;-1,0;-0.71,0.71;0,1;
        0.71,0.71;1,0;1,-1;0.71,-1.71;0,-2;0,-7;-3,-7;3,-7;-3,-8;-2,-7;
        -3,-10;0,-7;-1,-10;2,-7;1,-10;3,-8];
      polilineas.puntos=0.1*polilineas.puntos;
      polilineas.n_lineas=16;
      polilineas.lineas=[1,2;2,3;3,4;4,5;5,6;6,7;7,8;8,9;9,10;10,11;
        11,12;13,14;15,16;17,18;19,20;21,22];
    % Empotramiento
    case 'empotramiento'
      polilineas.n_puntos=14;
      polilineas.puntos=[-5,0;5,0;-5,-1;-4,0;-5,-3;-2,0;-3,-3;0,0;
        -1,-3;2,0;1,-3;4,0;3,-3;5,-1];
      polilineas.puntos=0.1*polilineas.puntos;
      polilineas.n_lineas=7;
      polilineas.lineas=[1,2;3,4;5,6;7,8;9,10;11,12;13,14];
    % Apoyo carro horizontal empotrado
    case 'carro_empotrado'
      polilineas.n_puntos=35;
      polilineas.puntos=[0,0;-3,-5;3,-5;-5,-7;5,-7;-5,-8;-4,-7;
        -5,-10;-2,-7;-3,-10;0,-7;-1,-10;2,-7;1,-10;4,-7;3,-10;5,-8;
        -2+0.0000,-6+1.0000;-2-0.7071,-6+0.7071;-2-1.0000,-6+0.0000;
        -2-0.7071,-6-0.7071;-2+0.0000,-6-1.0000;-2+0.7071,-6-0.7071;
        -2+1.0000,-6+0.0000;-2+0.7071,-6+0.7071;-2+0.0000,-6+1.0000;
        2+0.0000,-6+1.0000; 2-0.7071,-6+0.7071; 2-1.0000,-6+0.0000;
        2-0.7071,-6-0.7071; 2+0.0000,-6-1.0000; 2+0.7071,-6-0.7071;
        2+1.0000,-6+0.0000; 2+0.7071,-6+0.7071; 2+0.0000,-6+1.0000];
      polilineas.puntos(:,2)=polilineas.puntos(:,2)+5;
      polilineas.puntos=0.1*(polilineas.puntos);
      polilineas.n_lineas=24;
      polilineas.lineas=[2,3;4,5;6,7;8,9;10,11;12,13;14,15;
        16,17;18,19;19,20;20,21;21,22;22,23;23,24;24,25;25,26;
        27,28;28,29;29,30;30,31;31,32;32,33;33,34;34,35];
  end

end
