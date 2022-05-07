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

function modelo=leer_datos(fichero)
%leer_datos Leer datos del modelo desde fichero

  % --------------------------------------------------------------- %
  % Definir la estructura de datos donde se guardan todos los datos %
  % --------------------------------------------------------------- %

  % Estructura de datos del modelo
  modelo=struct('n_materiales',0,...         % Numero de materiales
                'materiales_E',[],...        % Vector con el modulo de Young de cada material
                'n_secciones',0,...          % Numero de secciones
                'secciones_A',[],...         % Vector con el area de cada seccion 
                'n_nodos',0,...              % Numero de nodos
                'nodos_x',[],...             % Matriz con las coordenadas de cada nodo (tantas filas como nodos)
                'nodos_u',[],...             % Matriz con los desplazamientos y rotacion de cada nodo (tantas filas como nodos)
                'n_elementos',0,...          % Numero de elementos
                'elementos_nodos',[],...     % Matriz con los nodos i y j de cada elemento (tantas filas como elementos)
                'elementos_seccion',[],...   % Vector con la seccion de cada elemento
                'elementos_material',[],...  % Vector con el material de cada elemento
                'elementos_N',[],...         % Vectir con los axiles de cada elemento
                'n_apoyos',0,...             % Numero de apoyos
                'apoyos_nodo',[],...         % Vector con el nodo con el cual esta conectado cada apoyos
                'apoyos_tipo',[],...         % Vector con el tipo de apoyo de cada apoyo
                'apoyos_K',[],...            % Rigideces de los apoyos elasticos
                'apoyos_alfa',[],...         % Angulo alfa para los apoyos inclinados
                'apoyos_beta',[],...         % Matriz con los angulos beta usados para representar graficamente los apoyos
                'apoyos_R',[],...            % Matriz con las reacciones en cada apoyo (tantas filas como apoyos)
                'n_cargas',0,...             % Numero de cargas nodales
                'cargas_nodo',[],...         % Vector con el nodo con el cual esta conectada cada carga
                'cargas_F',[]);              % Matriz con las cargas nodales (tantas filas como cargas)
              
  % -------------------------------------------------- %
  % Leer el fichero de texto plano con todos los datos %
  % ------------------------------------ ------------- %
  
  % Abrir fichero en modo lectura
  [f,msg]=fopen(fichero,'r');
  % Si hay error en lectura, mostrar mensaje de error
  if f==-1
    error(msg)
  end

  % MATERIALES
  
  % Leer numero de materiales
  modelo.n_materiales=fscanf(f,'%d',1);

  % Inicializar
  modelo.materiales_E=zeros(modelo.n_materiales,1);
  
  % Leer identificador y propiedades de cada material
  for n=1:modelo.n_materiales
    buf=fscanf(f,'%d %f',2);
    modelo.materiales_E(buf(1))=buf(2);
  end

  % SECCIONES
  
  % Leer numero de secciones
  modelo.n_secciones=fscanf(f,'%d',1);

  % Inicializar
  modelo.secciones_A=zeros(modelo.n_secciones,1);
  
  % Leer identificador y area de cada seccion
  for n=1:modelo.n_secciones
    buf=fscanf(f,'%d %f',2);
    modelo.secciones_A(buf(1))=buf(2);
  end

  % NODOS
  
  % Leer numero de nodos
  modelo.n_nodos=fscanf(f,'%d',1);

  % Inicializar
  modelo.nodos_x=zeros(modelo.n_nodos,2);
  modelo.nodos_u=zeros(modelo.n_nodos,2);
  
  % Leer identificador y coordenadas de cada nodo
  for n=1:modelo.n_nodos
    buf=fscanf(f,'%d %f %f',3);
    modelo.nodos_x(buf(1),:)=buf(2:3);
  end

  % ELEMENTOS
  
  % Leer numero de elementos
  modelo.n_elementos=fscanf(f,'%d',1);
  
  % Inicializar
  modelo.elementos_nodos=zeros(modelo.n_elementos,2);
  modelo.elementos_seccion=zeros(modelo.n_elementos,1);
  modelo.elementos_material=zeros(modelo.n_elementos,1);
  modelo.elementos_N=zeros(modelo.n_elementos,1);
  
  % Leer identificador, nodos, seccion y material de cada elemento
  for n=1:modelo.n_elementos
    buf=fscanf(f,'%d %d %d %d %d',5);
    modelo.elementos_nodos(buf(1),1)=buf(2);
    modelo.elementos_nodos(buf(1),2)=buf(3);
    modelo.elementos_seccion(buf(1))=buf(4);
    modelo.elementos_material(buf(1))=buf(5);
  end
  
  % APOYOS
  
  % Leer numero de apoyos
  modelo.n_apoyos=fscanf(f,'%d',1);

  % Inicializar
  modelo.apoyos_nodo=zeros(modelo.n_apoyos,1);
  modelo.apoyos_tipo=zeros(modelo.n_apoyos,1);
  modelo.apoyos_alfa=zeros(modelo.n_apoyos,1);
  modelo.apoyos_beta=zeros(modelo.n_apoyos,2);
  modelo.apoyos_K=zeros(modelo.n_apoyos,2);
  modelo.apoyos_R=zeros(modelo.n_apoyos,2);
  
  % Leer identificador, nodo, tipo y propiedades del apoyo
  for n=1:modelo.n_apoyos
    buf=fscanf(f,'%d %d %d',3);
    modelo.apoyos_nodo(buf(1))=buf(2);
    modelo.apoyos_tipo(buf(1))=buf(3);
    switch modelo.apoyos_tipo(buf(1))
      % Apoyo tipo rigido fijo
      case 1
        modelo.apoyos_beta(buf(1),1)=fscanf(f,'%f',1);
        modelo.apoyos_beta(buf(1),1)=modelo.apoyos_beta(buf(1),1)*pi/180.; 
      % Apoyo tipo rigido carro horizontal
      case 2
        modelo.apoyos_beta(buf(1),1)=fscanf(f,'%f',1);
        modelo.apoyos_beta(buf(1),1)=modelo.apoyos_beta(buf(1),1)*pi/180.;
        if abs(modelo.apoyos_beta(buf(1),1))>pi/2
          modelo.apoyos_beta(buf(1),1)=pi;
        else
          modelo.apoyos_beta(buf(1),1)=0;
        end
      % Apoyo tipo rigido carro vertical
      case 3
        modelo.apoyos_beta(buf(1),1)=fscanf(f,'%f',1);
        modelo.apoyos_beta(buf(1),1)=modelo.apoyos_beta(buf(1),1)*pi/180.;
        if abs(modelo.apoyos_beta(buf(1),1))>pi/2
          modelo.apoyos_beta(buf(1),1)=pi;
        else
          modelo.apoyos_beta(buf(1),1)=0;
        end
        modelo.apoyos_beta(buf(1),1)
      % Apoyo tipo rigido carro inclinado (angulo de entrada en grados)
      case 4
        modelo.apoyos_alfa(buf(1))=fscanf(f,'%f',1);
        modelo.apoyos_alfa(buf(1))=modelo.apoyos_alfa(buf(1))*pi/180.;
        modelo.apoyos_beta(buf(1),1)=modelo.apoyos_alfa(buf(1));
      % Apoyo tipo elastico
      case 5
        modelo.apoyos_K(buf(1),:)=fscanf(f,'%f %f',2);
        modelo.apoyos_beta(buf(1),1:2)=fscanf(f,'%f %f',2);
        modelo.apoyos_beta(buf(1),1:2)=modelo.apoyos_beta(buf(1),1:2)*pi/180.;
        if abs(modelo.apoyos_beta(buf(1),1))>pi/2
          modelo.apoyos_beta(buf(1),1)=pi;
        else
          modelo.apoyos_beta(buf(1),1)=0;
        end
        if abs(modelo.apoyos_beta(buf(1),2))>pi/2
          modelo.apoyos_beta(buf(1),2)=pi;
        else
          modelo.apoyos_beta(buf(1),2)=0;
        end
      otherwise
        error('Error: el apoyo %d tiene tipo de apoyo %d, que no es un tipo de apoyo valido',buf(1),modelo.apoyos_tipo(buf(1)))
    end
  end

  % CARGAS
  
  % Leer el numero de cargas
  modelo.n_cargas=fscanf(f,'%d',1);

  % Inicializar
  modelo.cargas_nodo=zeros(modelo.n_cargas,1);
  modelo.cargas_F=zeros(modelo.n_cargas,2);

  % Leer identificador, nodo y valor de la carga
  for n=1:modelo.n_cargas
    buf=fscanf(f,'%d %d %f %f',4);
    modelo.cargas_nodo(buf(1))=buf(2);
    modelo.cargas_F(buf(1),1)=buf(3);
    modelo.cargas_F(buf(1),2)=buf(4);
  end

  % Cerrar fichero
  fclose(f);

end
