function polyomino_multihedral_test ( )

%*****************************************************************************80
%
%% POLYOMINO_MULTIHEDRAL_TEST tests POLYOMINO_MULTIHEDRAL.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    04 June 2018
%
%  Author:
%
%    John Burkardt
%
  timestamp ( );
  fprintf ( 1, '\n' );
  fprintf ( 1, 'POLYOMINO_MULTIHEDRAL_TEST:\n' );
  fprintf ( 1, '  MATLAB version\n' );
  fprintf ( 1, '  POLYOMINO_MULTIHEDRAL sets up an solves the linear system\n' );
  fprintf ( 1, '  associated with a multi-polyomino tiling problem.\n' );

  polyomino_multihedral_test01 ( )
  polyomino_multihedral_test02 ( )
%
%  Terminate.
%
  fprintf ( 1, '\n' );
  fprintf ( 1, 'POLYOMINO_MULTIHEDRAL_TEST:\n' );
  fprintf ( 1, '  Normal end of execution.\n' );
  fprintf ( 1, '\n' );
  timestamp ( );

  return
end
function polyomino_multihedral_test01 ( )

%*****************************************************************************80
%
%% POLYOMINO_MULTIHEDRAL_TEST01 tests POLYOMINO_MULTIHEDRAL.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    05 June 2018
%
%  Author:
%
%    John Burkardt
%
  fprintf ( 1, '\n' );
  fprintf ( 1, 'POLYOMINO_MULTIHEDRAL_TEST01:\n' );
  fprintf ( 1, '  POLYOMINO_MULTIHEDRAL must solve a multihedral polyomino\n' );
  fprintf ( 1, '  tiling problem for a 2x4 rectangle.\n' );
%
%  Define R.
%
  shape_r = [ ...
    1, 1, 1, 1; ...
    1, 1, 1, 1 ];

  [ m_r, n_r ] = size ( shape_r );
  polyomino_print ( m_r, n_r, shape_r, '  Region R:' );
%
%  Define N, O, P
%
  shape_n = [ ...
    1 ];
  [ m_n, n_n ] = size ( shape_n );
  polyomino_print ( m_n, n_n, shape_n, '  Polyomino N:' );

  shape_o = [ ...
    1, 1, 1 ];
  [ m_o, n_o ] = size ( shape_o );
  polyomino_print ( m_o, n_o, shape_o, '  Polyomino O:' );

  shape_p = [ ...
    0, 0, 1;
    1, 1, 1 ];
  [ m_p, n_p ] = size ( shape_p );
  polyomino_print ( m_p, n_p, shape_p, '  Polyomino P:' );
%
%  Pack the arrays into P.
%
  p_num = 3;
  p = zeros ( m_r, n_r, p_num );
  p(1:m_n,1:n_n,1) = shape_n(1:m_n,1:n_n);
  p(1:m_o,1:n_o,2) = shape_o(1:m_o,1:n_o);
  p(1:m_p,1:n_p,3) = shape_p(1:m_p,1:n_p);
%
%  Set the vector D, which indicates how many copies of each polyomino
%  we can use: one of each, in this case.
%
  d = ones ( p_num, 1 );
%
%  Set up and solve the system.
%
  filename = '2x4.lp';
  comment = 'The 2x4 multihedral example.';
  [ m, n, k, a, b, x ] = polyomino_multihedral ( shape_r, p_num, p, d, ...
     filename, comment );

  return
end
function polyomino_multihedral_test02 ( )

%*****************************************************************************80
%
%% POLYOMINO_MULTIHEDRAL_TEST02 tests POLYOMINO_MULTIHEDRAL.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    05 June 2018
%
%  Author:
%
%    John Burkardt
%
  fprintf ( 1, '\n' );
  fprintf ( 1, 'POLYOMINO_MULTIHEDRAL_TEST02:\n' );
  fprintf ( 1, '  POLYOMINO_MULTIHEDRAL must solve a multihedral polyomino\n' );
  fprintf ( 1, '  tiling problem for a subset of a 4x4 rectangle.\n' );
%
%  Define R.
%
  shape_r = [ ...
    1, 0, 0, 0; ...
    1, 0, 0, 0; ...
    1, 1, 1, 1; ...
    1, 1, 1, 1 ];

  [ m_r, n_r ] = size ( shape_r );
  polyomino_print ( m_r, n_r, shape_r, '  Region R:' );
%
%  Define N, O, P
%
  shape_n = [ ...
    0, 0, 1; ...
    1, 1, 1 ];
  [ m_n, n_n ] = size ( shape_n );
  polyomino_print ( m_n, n_n, shape_n, '  Polyomino N:' );

  shape_o = [ ...
    1, 1, 1 ];
  [ m_o, n_o ] = size ( shape_o );
  polyomino_print ( m_o, n_o, shape_o, '  Polyomino O:' );

  shape_p = [ ...
    0, 1;
    1, 1 ];
  [ m_p, n_p ] = size ( shape_p );
  polyomino_print ( m_p, n_p, shape_p, '  Polyomino P:' );
%
%  Pack the arrays into P.
%
  p_num = 3;
  p = zeros ( m_r, n_r, p_num );
  p(1:m_n,1:n_n,1) = shape_n(1:m_n,1:n_n);
  p(1:m_o,1:n_o,2) = shape_o(1:m_o,1:n_o);
  p(1:m_p,1:n_p,3) = shape_p(1:m_p,1:n_p);
%
%  Set the vector D, which indicates how many copies of each polyomino
%  we can use: one of each, in this case.
%
  d = ones ( p_num, 1 );
%
%  Set up and solve the system.
%
  filename = '4x4.lp';
  comment = 'The 4x4 multihedral example.';
  [ m, n, k, a, b, x ] = polyomino_multihedral ( shape_r, p_num, p, d, ...
     filename, comment );

  return
end
