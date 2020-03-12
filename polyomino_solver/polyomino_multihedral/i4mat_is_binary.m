function value = i4mat_is_binary ( m, n, x )

%*****************************************************************************80
%
%% I4MAT_IS_BINARY is true if an I4MAT only contains 0 and 1 entries.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    24 April 2018
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, integer M, N, the dimension of the array.
%
%    Input, integer X(M,N), the array to be checked.
%
%    Output, logical VALUE, is true (1) if X only contains
%    0 or 1 entries.
%
  value = true;

  for j = 1 : n
    for i = 1 : m

      if ( x(i,j) ~= 0 && x(i,j) ~= 1 )
        value = false;
        break;
      end

    end
  end

  return
end
