function x = r8mat_u_solve ( n, a, b )

%*****************************************************************************80
%
%% R8MAT_U_SOLVE solves an upper triangular linear system.
%
%  Discussion:
%
%    An R8MAT is an MxN array of R8's, stored by (I,J) -> [I+J*M].
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    28 July 2015
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, integer N, the number of rows and columns of
%    the matrix A.
%
%    Input, real A(N,N), the N by N upper triangular matrix.
%
%    Input, real B(N,1), the right hand side of the linear system.
%
%    Output, real X(N,1), the solution of the linear system.
%
  b = b(:);
%
%  Solve U * x = b.
%
  x = zeros ( n, 1 );

  for i = n : -1 : 1
    x(i,1) = b(i,1);
    for j = i + 1 : n
      x(i,1) = x(i,1) - a(i,j) * x(j,1);
    end
    x(i,1) = x(i,1) / a(i,i);
  end

  return
end
