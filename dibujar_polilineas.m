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

function dibujar_polilineas(polilineas,f,alpha,x,lw,c)

  % Rotar
  R=[cos(alpha),-sin(alpha); sin(alpha),cos(alpha)];
  for i=1:polilineas.n_puntos
    polilineas.puntos(i,:)=R*polilineas.puntos(i,:)';
  end
  % Dibujar en x
  for i=1:polilineas.n_lineas
    line(x(1)+f*polilineas.puntos(polilineas.lineas(i,:),1),...
         x(2)+f*polilineas.puntos(polilineas.lineas(i,:),2),...
         'LineWidth',lw,'Color',c)
  end

end
