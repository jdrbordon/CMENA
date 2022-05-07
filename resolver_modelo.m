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

function modelo=resolver_modelo(modelo)

  % ------------------------------ %
  % Obtener K y f de la estructura %
  % ------------------------------ %
  
  [K,f]=ensamblar(modelo);
  
  % ---------------------------------------------- %
  % Reducir K y f a los grados de libertad activos %
  % ---------------------------------------------- %
  
  % Inicializar vector con todos los GDL de la estructura
  GDLA=1:2*modelo.n_nodos; 
  % Poner a 0 en GDLA los GDL no activos
  for ka=1:modelo.n_apoyos
    n=modelo.apoyos_nodo(ka);
    switch modelo.apoyos_tipo(ka)
      % Apoyo tipo rigido fijo
      case 1
        GDLA(2*n-1)=0;
        GDLA(2*n  )=0;
      % Apoyo tipo rigido carro horizontal
      case 2
        GDLA(2*n  )=0;
      % Apoyo tipo rigido carro vertical
      case 3
        GDLA(2*n-1)=0;
      % Apoyo inclinado
      case 4
        GDLA(2*n  )=0;
    end
  end
  GDLA=nonzeros(GDLA);
  A=K(GDLA,GDLA);
  b=f(GDLA);
  
  % --------------------------------- % 
  % Resolver el sistema de ecuaciones %
  % --------------------------------- %
  
  x=inv(A)*b;

  % ------------------------- %
  % Copiar solucion a nodos_u %
  % ------------------------- %
  
  % Inicializar nodos_u
  modelo.nodos_u=zeros(modelo.n_nodos,2);
  % Recorrer nodos extrayendo de x los desplazamientos si los hubiere
  for n=1:modelo.n_nodos
    % Desplazamiento horizontal
    pos=find(GDLA==2*n-1);
    if length(pos)==1
      modelo.nodos_u(n,1)=x(pos);
    end
    % Desplazamiento vertical
    pos=find(GDLA==2*n  );
    if length(pos)==1
      modelo.nodos_u(n,2)=x(pos);
    end
  end
  
  % ---------------------------------------------------- %
  % Obtener reacciones en los apoyos y copiar a apoyos_R %
  % ---------------------------------------------------- %

  % Inicializar nodos_u
  modelo.apoyos_R=zeros(modelo.n_apoyos,2);
  % Recorrer apoyos calculando reacciones y copiandolas a apoyos_R
  for ka=1:modelo.n_apoyos
      n=modelo.apoyos_nodo(ka); % Nodo conectado al apoyo
      switch modelo.apoyos_tipo(ka)
          % Apoyo tipo rigido fijo
          case 1
            modelo.apoyos_R(ka,1)=f(2*n-1)-K(2*n-1,GDLA)*x;
            modelo.apoyos_R(ka,2)=f(2*n  )-K(2*n  ,GDLA)*x; 
          % Apoyo tipo rigido carro horizontal
          case 2
            modelo.apoyos_R(ka,2)=f(2*n  )-K(2*n  ,GDLA)*x; 
          % Apoyo tipo rigido carro vertical
          case 3
            modelo.apoyos_R(ka,1)=f(2*n-1)-K(2*n-1,GDLA)*x; 
          % Apoyo inclinado
          case 4
            modelo.apoyos_R(ka,2)=f(2*n  )-K(2*n  ,GDLA)*x;
          % Apoyo elastico
          case 5
            Kx=modelo.apoyos_K(ka,1);
            Ky=modelo.apoyos_K(ka,2);
            modelo.apoyos_R(ka,1)=Kx*modelo.nodos_u(n,1);
            modelo.apoyos_R(ka,2)=Ky*modelo.nodos_u(n,2);
      end
  end

  % ------------------------------------------------------------------ %
  % Pasar a coordenadas globales los nodos resueltos en coord. locales %
  % ------------------------------------------------------------------ %
  
  % Recorrer apoyos y tratar aquellos que lo necesiten
  for ka=1:modelo.n_apoyos
    % Si es un apoyo inclinado
    if modelo.apoyos_tipo(ka)==4
      n=modelo.apoyos_nodo(ka);    % Nodo al que esta conectado el apoyo
      alfa=modelo.apoyos_alfa(ka); % Angulo del plano inclinado
      Ln=[cos(alfa) -sin(alfa)     % Matriz de rotacion u=L·u'
          sin(alfa)  cos(alfa)];
      % Pasar a globales
      modelo.nodos_u(n,:)=Ln*modelo.nodos_u(n,:)';
      modelo.apoyos_R(ka,:)=Ln*modelo.apoyos_R(ka,:)';
    end
  end
  
  % -------------------------------------- %
  % Calcular y asignar esfuerzos en barras %
  % ---------------------------------------%
  
  % Recorrer elementos
  for ke=1:modelo.n_elementos
    %
    % Datos basicos del elemento
    %
    ni=modelo.elementos_nodos(ke,1);   % Nodo i
    nj=modelo.elementos_nodos(ke,2);   % Nodo j
    xi=modelo.nodos_x(ni,:);           % Vector de posicion nodo i
    xj=modelo.nodos_x(nj,:);           % Vector de posicion nodo j
    r=xj-xi;                           % Vector distancia entre nodos
    elemento_L=sqrt(dot(r,r));         % Longitud
    alfa=atan2(r(2),r(1));             % Angulo
    s=modelo.elementos_seccion(ke);    % Seccion
    elemento_A=modelo.secciones_A(s);  % Area
    m=modelo.elementos_material(ke);   % Material
    elemento_E=modelo.materiales_E(m); % Modulo de Young
    %
    % Calcular esfuerzos 
    %
    Kep=calcular_Kep(elemento_L,elemento_A,elemento_E); % Ke'
    Le=calcular_Le(alfa);                               % Le
    u=[modelo.nodos_u(ni,1)                             % Vector de desplaz.
       modelo.nodos_u(ni,2)
       modelo.nodos_u(nj,1)
       modelo.nodos_u(nj,2)];
    F=Kep*Le'*u;                                        % Vector de esfuerzos 
    modelo.elementos_N(ke)=F(3);
  end
    
end

