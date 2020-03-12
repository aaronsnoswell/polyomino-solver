function [ mq, nq, q ] = polyomino_transform ( m, n, p, rotate, reflect )

%*****************************************************************************80
%
%% POLYOMINO_TRANSFORM transforms a polyomino.
%
%  Discussion:
%
%    A polyomino can be rotated or reflected.
%
%    This program is given a polyomino and returns the resulting polyomino
%    after the specified reflection and rotation.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    12 April 2018
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, integer M, N, the number of rows and columns in the representation
%    of the polyomino P.
%
%    Input, integer P(M,N), a matrix of 0's and 1's representing the 
%    polyomino.  The matrix should be "tight", that is, there should be a
%    1 in row 1, and in column 1, and in row M, and in column N.
%
%    Input, integer ROTATE, is 0, 1, 2, or 3, the number of 90 degree
%    counterclockwise rotations to be applied.
%
%    Input, integer REFLECT, is 0 or 1.  If it is 1, then each row of the
%    polyomino matrix is to be reflected before any rotations are performed.
%
%    Output, integer MQ, NQ, the number of rows and columns of the
%    representation of the transformed polyomino
%
%    Output, integer Q(MQ,NQ), the representation of the transformed
%    polyomino.
%
  mq = m;
  nq = n;

  reflect = mod ( reflect, 2 );

  if ( reflect == 1 )
    q = fliplr ( p );
  else
    q = p;
  end

  rotate = mod ( rotate, 4 );

  for k = 1 : rotate
    r = mq;
    s = nq;
    mq = s;
    nq = r;
    q = flipud ( q' ); 
  end

  return
end
