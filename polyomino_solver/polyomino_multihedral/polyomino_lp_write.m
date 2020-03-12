function polyomino_lp_write ( filename, label, m, n, a, b )

%*****************************************************************************80
%
%% POLYOMINO_LP_WRITE writes an LP file for the polyomino problem.
%
%  Discussion:
%
%    We have begun to look at rather large problems, and have encountered
%    software packages that put limits on the maximum length of a line
%    in an LP file.  We try to control this by adding line breaks so that,
%    at least when there are no more than 99,999 variables, the lines of the
%    LP file should be no more than 80 characters long.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    15 June 2018
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, string FILENAME, the output filename.
%
%    Input, string LABEL, the problem title.
%
%    Input, integer M, the number of equations
%
%    Input, integer N, the number of variables.
%
%    Input, integer A(M,N), the coefficients.
%
%    Input, integer B(M), the right hand sides.
%

%
%  Open the file.
%
  output = fopen ( filename, 'wt' );

  if ( output < 0 ) 
    fprintf ( 1, '\n' );
    fprintf ( 1, 'POLYOMINO_LP_WRITE - Error!\n' );
    fprintf ( 1, '  Could not open the output file.\n' );
    error ( 'POLYOMINO_LP_WRITE - Error!' );
  end

  fprintf ( output, '%s\n', label );
  fprintf ( output, '\n' );

  fprintf ( output, 'Maximize\n' );
  fprintf ( output, '  Obj: 0\n' );

  fprintf ( output, 'Subject to\n' );
  line_length = 0;

  for i = 1 : m

    first = true;

    for j = 1 : n

      if ( a(i,j) ~= 0 )

        if ( a(i,j) < 0 )
          byte_num = fprintf ( output, ' -' );
          line_length = line_length + byte_num;
        elseif ( ~ first )
          byte_num = fprintf ( output, ' +' );
          line_length = line_length + byte_num;
        end

        if ( abs ( a(i,j) ) == 1 )
          byte_num = fprintf ( output, ' x%d', j );
          line_length = line_length + byte_num;
        else
          byte_num = fprintf ( output, ' %d x%d', abs ( a(i,j) ), j );
          line_length = line_length + byte_num;
        end

        if ( 70 <= line_length )
          fprintf ( output, '\n' );
          fprintf ( output, '  ' );
          line_length = 2;
        end

        first = false;

      end
    end
    numbytes = fprintf ( output, ' = %d\n', b(i) );
    line_length = 0;
  end

  fprintf ( output, 'Binary\n' );
  line_length = 0;

  byte_num = fprintf ( output, ' ' );
  line_length = line_length + byte_num;

  for j = 1 : n
    byte_num = fprintf ( output, ' x%d', j );
    line_length = line_length + byte_num;
    if ( 73 <= line_length && j < n )
      fprintf ( output, '\n' );
      fprintf ( output, '  ' );
      line_length = 2;
    end
  end
  fprintf ( output, '\n' );

  fprintf ( output, 'End\n' );
%
%  Close the file.
%
  fclose ( output );

  return
end
