function polyomino_print ( m, n, p, label )

%*****************************************************************************80
%
%% POLYOMINO_PRINT prints a polyomino.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    07 June 2018
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, integer M, N, the number of rows and columns in the representation.
%
%    Input, integer P(MP,NP), a matrix representing the polyomino.  
%
%    Input, string LABEL, a label to be printed first.  
%
  fprintf ( 1, '\n' );
  fprintf ( 1, '%s\n', label );
  fprintf ( 1, '\n' );

  if ( m <= 0 || n <= 0 )
    fprintf ( 1, '  [ Null matrix ]\n' );
  else
    for i = 1 : m
      fprintf ( 1, ' ' );
      for j = 1 : n
        fprintf ( 1, ' %d', p(i,j) );
      end
      fprintf ( 1, '\n' );
    end
  end

  return
end
