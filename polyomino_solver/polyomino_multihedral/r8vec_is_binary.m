function value = r8vec_is_binary ( n, x )

%*****************************************************************************80
%
%% R8VEC_IS_BINARY is true if an R8VEC only contains 0 and 1 entries.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    29 March 2018
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, integer N, the dimension of the vectors.
%
%    Input, real X(N), the vector to be compared against.
%
%    Output, logical R8VEC_IS_BINARY, is true (1) if X only contains
%    0 or 1 entries.
%
  value = true;

  for i = 1 : n

    if ( x(i) ~= 0 && x(i) ~= 1 )
      value = false;
      break;
    end

  end

  return
end
