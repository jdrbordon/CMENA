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

function escribir_resultados(modelo,fichero)
%escribir_resultados Escribir los resultados

  % Desplazamientos de los nodos
  f=fopen([fichero '.u.txt'],'w');
  fprintf(f,'__nodo ___________ux ___________uy\n');
  for n=1:modelo.n_nodos
    fprintf(f,'%6d %13.6e %13.6e\n',n,modelo.nodos_u(n,:));
  end
  fclose(f);

  % Axiles de las barras
  f=fopen([fichero '.N.txt'],'w');
  fprintf(f,'_barra ____________N ________sigma\n');
  for n=1:modelo.n_elementos
    A=modelo.secciones_A(modelo.elementos_seccion(n));
    fprintf(f,'%6d %13.6e %13.6e\n',n,modelo.elementos_N(n),modelo.elementos_N(n)/A);
  end
  fclose(f);

  % Reacciones en los apoyos
  f=fopen([fichero '.R.txt'],'w');
  fprintf(f,'_apoyo ___________Rx ___________Ry\n');
  for n=1:modelo.n_apoyos
    fprintf(f,'%6d %13.6e %13.6e\n',n,modelo.apoyos_R(n,:));
  end
  fclose(f);

end
