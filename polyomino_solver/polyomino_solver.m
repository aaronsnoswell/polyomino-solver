
function polyomino_solver(r_shape, d_mat)
    % Solve a Polyomino multihedral tiling problem
    % r_shape is a binary array defining the desired shape
    % d_mat A matrix where rows specify counts of polyominoes to try
    %     (refer to ../blokus_polyominoes.pdf for a listing of the indices)

    addpath("polyomino_multihedral");

    % Covert to logical format if it isn't
    r_shape = logical(r_shape);

    % Define the 1-5 Polyomino set
    % p_shapes              = [1 0 0; 0 0 0; 0 0 0; 0 0 0; 0 0 0];         % Monomino                     (1)
    % p_shapes(:, :, end+1) = [1 0 0; 1 0 0; 0 0 0; 0 0 0; 0 0 0];         % Domino                       (2)
    % p_shapes(:, :, end+1) = [1 0 0; 1 0 0; 1 0 0; 0 0 0; 0 0 0];         % Straight Tromino             (3)
    % p_shapes(:, :, end+1) = [1 1 0; 1 0 0; 0 0 0; 0 0 0; 0 0 0];         % L Tromino                    (4)
    % p_shapes(:, :, end+1) = [1 0 0; 1 0 0; 1 0 0; 1 0 0; 0 0 0];         % Straight Tetromino           (5)
    % p_shapes(:, :, end+1) = [1 1 0; 1 0 0; 1 0 0; 0 0 0; 0 0 0];         % L Tetromino                  (6)
    % p_shapes(:, :, end+1) = [1 0 0; 1 1 0; 1 0 0; 0 0 0; 0 0 0];         % T Tetromino                  (7)
    % p_shapes(:, :, end+1) = [1 1 0; 1 1 0; 0 0 0; 0 0 0; 0 0 0];         % Square Tetromino             (8)
    % p_shapes(:, :, end+1) = [1 1 0; 0 1 1; 0 0 0; 0 0 0; 0 0 0];         % Shear Tetromino              (9)
    % p_shapes(:, :, end+1) = [1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0];         % Straight Pentomino           (10)
    % p_shapes(:, :, end+1) = [1 1 0; 1 0 0; 1 0 0; 1 0 0; 0 0 0];         % l Pentomino                  (11)
    % p_shapes(:, :, end+1) = [1 0 0; 1 0 0; 1 1 0; 0 1 0; 0 0 0];         % Shear Pentomino              (12)
    % p_shapes(:, :, end+1) = [1 0 0; 1 1 0; 1 1 0; 0 0 0; 0 0 0];         % Square with bump Pentomino   (13)
    % p_shapes(:, :, end+1) = [1 1 0; 1 0 0; 1 1 0; 0 0 0; 0 0 0];         % C Pentomino                  (14)
    % p_shapes(:, :, end+1) = [1 0 0; 1 1 0; 1 0 0; 1 0 0; 0 0 0];         % r Pentomino                  (15)
    % p_shapes(:, :, end+1) = [1 1 1; 0 1 0; 0 1 0; 0 0 0; 0 0 0];         % T Pentomino                  (16)
    % p_shapes(:, :, end+1) = [1 0 0; 1 0 0; 1 1 1; 0 0 0; 0 0 0];         % L Pentomino                  (17)
    % p_shapes(:, :, end+1) = [1 1 0; 0 1 1; 0 0 1; 0 0 0; 0 0 0];         % M Pentomino                  (18)
    % p_shapes(:, :, end+1) = [1 0 0; 1 1 1; 0 0 1; 0 0 0; 0 0 0];         % S Pentomino                  (19)
    % p_shapes(:, :, end+1) = [1 0 0; 1 1 1; 0 1 0; 0 0 0; 0 0 0];         % T with bump Pentomino        (20)
    % p_shapes(:, :, end+1) = [0 1 0; 1 1 1; 0 1 0; 0 0 0; 0 0 0];         % + Pentomino                  (21)
    % p_shapes = logical(p_shapes);
    load('polyominoes-1to5.mat', 'p_shapes');
    
    % Number of polyominoes available
    p_num = size(p_shapes, 3);

    % Filename and comment for LP file
    filename = "_tmp_polyomino.lp";
    comment = "Multihedral Polyomino tiling problem";

    % Iterate through the specified matrix of tile count vectors
    for d_ind = 1:size(d_mat, 1)
        d = d_mat(d_ind, :);
        
        fprintf('Solving for d=[%s]\n', num2str(d));
        [m, n, x_num, a, b, x] = polyomino_multihedral(...
            r_shape,...
            p_num,...
            p_shapes,...
            d,...
            filename,...
            comment...
        );

    end
end

