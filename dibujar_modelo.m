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

function dibujar_modelo(modelo)
%dibujar_modelo Dibuja la geometria, apoyos y cargas nodales del modelo

  % Modelo 2D
  dim=2;

  % Abrir figura y configurarla para dibujar varias cosas
  figure(1);
  close(1);
  figure(1);
  hold on;
  grid on;

  % Coordenadas maximas y minimas, y dimensiones de la estructura
  xmin=zeros(dim,1);
  xmax=zeros(dim,1);
  L=zeros(dim,1);
  for i=1:dim
    xmin(i)=min(modelo.nodos_x(:,i));
    xmax(i)=max(modelo.nodos_x(:,i));
    L(i)=xmax(i)-xmin(i);
  end
  % Dimension caracteristica
  D=max(L);

  % Ejes de la grafica
  margen=0.25;
  rango=zeros(2*dim,1);
  for i=1:dim
    rango((2*i-1):(2*i))=[xmin(i)-margen*D xmax(i)+margen*D];
  end
  axis(rango)

  % Dibujar los elementos
  for n=1:modelo.n_elementos
    line(modelo.nodos_x(modelo.elementos_nodos(n,:),1),...
      modelo.nodos_x(modelo.elementos_nodos(n,:),2),...
      'LineWidth',3,'Color','b')
  end

  % Dibujar los nodos
  plot(modelo.nodos_x(:,1),modelo.nodos_x(:,2),'ok','MarkerSize',6)

  % El tamano de los apoyos sera de un 10% de la dimension caracteristica
  tamano=0.1*D;
  
  % Dibujar
  for n=1:modelo.n_apoyos
    x=modelo.nodos_x(modelo.apoyos_nodo(n),:);
    switch modelo.apoyos_tipo(n)
      % Apoyo tipo fijo articulado
      case 1
        dibujo=crear_dibujo_apoyo('fijo');
        dibujar_polilineas(dibujo,tamano,modelo.apoyos_beta(n,1),x,2,'k')
      % Apoyo tipo carro horizontal articulado
      case 2
        dibujo=crear_dibujo_apoyo('carro_articulado');
        dibujar_polilineas(dibujo,tamano,modelo.apoyos_beta(n,1),x,2,'k')
      % Apoyo tipo carro vertical articulado
      case 3
        dibujo=crear_dibujo_apoyo('carro_articulado');
        dibujar_polilineas(dibujo,tamano,pi/2+modelo.apoyos_beta(n,1),x,2,'k')
      % Apoyo tipo carro inclinado articulado
      case 4
        dibujo=crear_dibujo_apoyo('carro_articulado');
        dibujar_polilineas(dibujo,tamano,modelo.apoyos_beta(n,1),x,2,'k')
      % Apoyo elastico (Kx, Ky, Kr)
      case 5
        dibujo=crear_dibujo_apoyo('resorte_vertical');
        dibujar_polilineas(dibujo,tamano,modelo.apoyos_beta(n,1),x,2,'k') 
        dibujar_polilineas(dibujo,tamano,pi/2+modelo.apoyos_beta(n,2),x,2,'k') 
    end
  end

  % Maxima carga
  max_F=max(sqrt(modelo.cargas_F(:,1).^2+modelo.cargas_F(:,2).^2));

  % Factor multiplicador de las cargas
  factor_F=0.1*D/max_F;

  % Dibujar las cargas
  for n=1:modelo.n_cargas
    quiver(modelo.nodos_x(modelo.cargas_nodo(n),1),...
      modelo.nodos_x(modelo.cargas_nodo(n),2),...
      factor_F*modelo.cargas_F(n,1),...
      factor_F*modelo.cargas_F(n,2),...
      'maxheadsize',0.5,'Color','r')
  end

  % Opciones de visualizacion
  title 'Modelo'
  xlabel 'x_1'
  ylabel 'x_2'
  box on
  axis equal

end

