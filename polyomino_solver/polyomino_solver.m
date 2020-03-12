
function polyomino_solver(r_shape, p_ind)
    % Solve a Polyomino multihedral tiling problem
    % r_shape is a binary array defining the desired shape
    % p_ind is an optional list of indices to restrict the set of polyominos
    %       (refer to ../blokus_polyominoes.pdf for a listing of the indices)

    addpath("polyomino_multihedral");
    addpath("cartprod");
    addpath("ind2subVect");

    % Covert to logical format if it isn't
    r_shape = logical(r_shape);

    % Define the 1-5 Polyomino set
    p_shapes              = [1 0 0; 0 0 0; 0 0 0; 0 0 0; 0 0 0];         % Monomino                     (1)

    p_shapes(:, :, end+1) = [1 0 0; 1 0 0; 0 0 0; 0 0 0; 0 0 0];         % Domino                       (2)

    p_shapes(:, :, end+1) = [1 0 0; 1 0 0; 1 0 0; 0 0 0; 0 0 0];         % Straight Tromino             (3)
    p_shapes(:, :, end+1) = [1 1 0; 1 0 0; 0 0 0; 0 0 0; 0 0 0];         % L Tromino                    (4)

    p_shapes(:, :, end+1) = [1 0 0; 1 0 0; 1 0 0; 1 0 0; 0 0 0];         % Straight Tetromino           (5)
    p_shapes(:, :, end+1) = [1 1 0; 1 0 0; 1 0 0; 0 0 0; 0 0 0];         % L Tetromino                  (6)
    p_shapes(:, :, end+1) = [1 0 0; 1 1 0; 1 0 0; 0 0 0; 0 0 0];         % T Tetromino                  (7)
    p_shapes(:, :, end+1) = [1 1 0; 1 1 0; 0 0 0; 0 0 0; 0 0 0];         % Square Tetromino             (8)
    p_shapes(:, :, end+1) = [1 1 0; 0 1 1; 0 0 0; 0 0 0; 0 0 0];         % Shear Tetromino              (9)

    p_shapes(:, :, end+1) = [1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0];         % Straight Pentomino           (10)
    p_shapes(:, :, end+1) = [1 1 0; 1 0 0; 1 0 0; 1 0 0; 0 0 0];         % l Pentomino                  (11)
    p_shapes(:, :, end+1) = [1 0 0; 1 0 0; 1 1 0; 0 1 0; 0 0 0];         % Shear Pentomino              (12)
    p_shapes(:, :, end+1) = [1 0 0; 1 1 0; 1 1 0; 0 0 0; 0 0 0];         % Square with bump Pentomino   (13)
    p_shapes(:, :, end+1) = [1 1 0; 1 0 0; 1 1 0; 0 0 0; 0 0 0];         % C Pentomino                  (14)
    p_shapes(:, :, end+1) = [1 0 0; 1 1 0; 1 0 0; 1 0 0; 0 0 0];         % r Pentomino                  (15)
    p_shapes(:, :, end+1) = [1 1 1; 0 1 0; 0 1 0; 0 0 0; 0 0 0];         % T Pentomino                  (16)
    p_shapes(:, :, end+1) = [1 0 0; 1 0 0; 1 1 1; 0 0 0; 0 0 0];         % L Pentomino                  (17)
    p_shapes(:, :, end+1) = [1 1 0; 0 1 1; 0 0 1; 0 0 0; 0 0 0];         % M Pentomino                  (18)
    p_shapes(:, :, end+1) = [1 0 0; 1 1 1; 0 0 1; 0 0 0; 0 0 0];         % S Pentomino                  (19)
    p_shapes(:, :, end+1) = [1 0 0; 1 1 1; 0 1 0; 0 0 0; 0 0 0];         % T with bump Pentomino        (20)
    p_shapes(:, :, end+1) = [0 1 0; 1 1 1; 0 1 0; 0 0 0; 0 0 0];         % + Pentomino                  (21)

    p_shapes = logical(p_shapes);

    % Restrict available shapes
    if nargin == 2
        p_shapes = p_shapes(:, :, p_ind);
    end

    % Number of polyominoes available
    p_num = size(p_shapes, 3);

    % Filename and comment for LP file
    filename = "_tmp_polyomino.lp";
    comment = "Multihedral Polyomino tiling problem";

    % How many times should each Polyomino be used?
    % d = [2, 1, 0, 0];

    % Find permutations of p_shapes with valid numbers of cells
    poly_sizes = squeeze(sum(sum(p_shapes)));
    r_size = sum(r_shape, 'all');
    max_repeats = idivide(r_size, int32(poly_sizes))';
    ranges = cell(1, length(max_repeats));
    for mr_ind = 1:length(max_repeats)
        ranges{mr_ind} = 0:max_repeats(mr_ind);
    end

    counts = cartprod(ranges{:});
    for d_ind = 1:length(counts)
        d = counts(d_ind, :);

        % Skip any permutation that won't have the right number of cells
        if d * poly_sizes ~= r_size
            continue;
        end

        fprintf('Got permutation: %s\n', num2str(d));

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

