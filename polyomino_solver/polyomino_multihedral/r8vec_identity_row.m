function a = r8vec_identity_row ( n, i )

%*****************************************************************************80
%
%% R8VEC_IDENTITY_ROW returns a row of the identity matrix.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    28 March 2018
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, integer N, the number of entries in the vector.
%
%    Input, integer I, the index of the entry to be set to 1.
%
%    Output, real A(N), the vector.
%
  a = zeros ( 1, n );

  if ( 1 <= i && i <= n )
    a(i) = 1.0;
  end

  return
end

