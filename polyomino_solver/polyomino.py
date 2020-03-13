"""Find Multihedral tilings using Polyominoes
"""

import os
import io
import subprocess

import numpy as np
import itertools as it

import scipy.io


MONOMINOES = [1]
DOMINOES = [2]
TROMINOES = [3, 4]
TETROMINOES = [5, 6, 7, 8, 9]
PENTOMINOES = [10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21]

# Path to the polyomino_solver.m file relative to this file
SOLVER_PATH = os.path.dirname(os.path.abspath(__file__))


def np2matlab(x, format='%.12e'):
    """Display the ndarray 'x' in a format suitable for pasting to MATLAB
    
    From http://codepad.org/MVYCM0AJ, courtesy of
    https://stackoverflow.com/users/136194/robince
    """
    
    ret = ""
    
    def print_row(row, format):
        _ret = ""
        for i in row:
            _ret += format % i
            _ret += " "
        return _ret[:-1]

    if x.ndim == 1:
        # 1d input
        ret += "["
        ret += print_row(x, format)
        ret += "]\n"

    if x.ndim == 2:
        ret += "["
        ret += print_row(x[0], format)
        if x.shape[0] > 1:
            ret += ';'
        for row in x[1:-1]:
            ret += " "
            ret += print_row(row, format)
            ret += ";"
        if x.shape[0] > 1:
            ret += " "
            ret += print_row(x[-1], format)
        ret += "]"

    if x.ndim > 2:
        print("GRRR")
        d_to_loop = x.shape[2:]
        sls = [slice(None, None)]*2
        ret += "reshape([ "
        # loop over flat index
        for i in range(np.prod(d_to_loop)):
            # reverse order for matlab
            # tricky double reversal to get first index to vary fastest
            ind_tuple = np.unravel_index(i, d_to_loop[::-1])[::-1]
            ind = sls + list(ind_tuple)
            ret += np2matlab(x[ind], format)

        ret += '],['
        for i in x.shape:
            ret += '%d' % i
        ret += '])\n'
    
    return ret


def multihedral_tile(
        target_shape,
        *,
        polyomino_set=[],
        max_tile_repeat=None,
        verbose=False,
        MATLAB_PATH="C:\\Program Files\\MATLAB\\R2019a\\bin\\matlab.exe"
    ):
    """Find multihedral Polyomino tilings of a given shape
    
    Args:
        target_shape (numpy array): Binary 2D array giving the target shape we
            want to tile
        
        polyomino_set (list): Optional list indices to restrict the set of
            available polyominoes. See `blokus_polyominoes.pdf` for indices. If
            emtpy, all Polyominoes of size 1-5 will be used.
        max_tile_repeat (int): Optional maximum number of times tiles can be
            repeated. Can be an int, or a list of 21 ints, one for each tile.
        verbose (bool): If true, show full output from solver.
        MATLAB_PATH (str): OS-appropriate absolute path to Matlab binary
        
    Returns:
        (list): List of unique configurations that tile the target shape
    """
    
    # Convert to numpy array
    target_shape = np.array(target_shape)

    _data = scipy.io.loadmat(
        os.path.join(SOLVER_PATH, 'polyominoes-1to5.mat')
    )
    p_shapes = _data['p_shapes']
    p_shapes_bbox = _data['p_shapes_bbox']
    
    if polyomino_set == []:
        polyomino_set = list(range(1, p_shapes.shape[2] + 1))
    
    if max_tile_repeat is not None:
        if isinstance(max_tile_repeat, int):
            max_tile_repeat = np.ones(
                p_shapes.shape[2], dtype=int
            ) * max_tile_repeat
        else:
            assert isinstance(max_tile_repeat, list),\
                "max_tile_repeat must be int or list"
            assert len(max_tile_repeat) == p_shapes.shape[2],\
                "len(max_tile_repeat) must match number of entries in p_shapes"
            max_tile_repeat = np.array(max_tile_repeat, dtype=int)
    
    print("# ============================================== #")
    print("Solving Multihedral tiling for")
    print(target_shape)
    print("Using Polyominoes: {}".format(polyomino_set))
    print("With maximum number of repeats: {}".format(max_tile_repeat))
    
    p_shapes_max_dim = np.max(p_shapes_bbox, 1)
    max_target_dim = np.max(target_shape.shape)
    shapes_too_big, = np.where(p_shapes_max_dim > max_target_dim)
    print("Removing Polyominoes {} as they are too big".format(shapes_too_big))
    for shape_too_big in shapes_too_big:
        if shape_too_big + 1 in polyomino_set:
            polyomino_set.remove(shape_too_big + 1)
    print("Updated Polyomino set: {}".format(polyomino_set))

    # Find permutations of p_shapes with valid numbers of cells
    p_sizes = np.squeeze(np.sum(np.sum(p_shapes, 0), 0))
    r_size = np.sum(target_shape.flatten())
    max_repeats = np.array(r_size // p_sizes, dtype=int)
    
    # Zero out any removed Polyominoes
    for i in range(1, len(max_repeats) + 1):
        if i not in polyomino_set:
            max_repeats[i-1] = 0
    
    # Clamp max repeats based on user-specified maximum repeat counts
    if max_tile_repeat is not None:
        max_repeats = np.array([
            min(m1, m2)
            for m1, m2 in zip(max_repeats, max_tile_repeat)
        ], dtype=int)
    
    print("Max polyomino repeats: {}".format(max_repeats))
    ranges = [list(range(0, m + 1)) for m in max_repeats]
    num_permutations = int(np.prod(np.array(max_repeats + 1, dtype=float)))
    print("Testing {} tile combinations...".format(num_permutations))
    
    # A *very* big iterator
    num_tested = 0
    num_skipped = 0
    valid_count_mat = []
    for count_vec in it.product(*ranges):
        num_tested += 1
        
        if not num_tested % int(1e6):
            print("{:.2f}%".format(num_tested / num_permutations * 100))
        
        # Skip any permutation that won't have the right number of cells
        if count_vec @ p_sizes != r_size:
            num_skipped += 1
            continue
        
        valid_count_mat.append(list(count_vec))
    
    valid_count_mat = np.array(valid_count_mat, dtype=int)
    
    print("Found {} valid tile combinations".format(
        num_permutations - num_skipped
    ))
    if verbose:
        with np.printoptions(linewidth=None):
            print(valid_count_mat)
    
    # Construct the solver command
    SOLVER_COMMAND = "polyomino_solver({}, {})".format(
        np2matlab(target_shape, '%d'),
        np2matlab(valid_count_mat, '%d')
    )

    # Call Polyomino solver script with arguments
    solver_output = subprocess.check_output(
        args=[
            MATLAB_PATH,
            "-batch",
            SOLVER_COMMAND
        ],
        cwd=SOLVER_PATH,
        universal_newlines=True
    )
    if verbose:
        print(solver_output)
    
    # Parse solutions arrays from stdout
    # This is super dodgy, but easier than IPC with Matlab
    
    colors = [
        _.strip().split("\n\n")[0].split("\nSolving for")[0]
        for _ in solver_output.split("\"Colors\"")[1:]
    ]
    colors = [np.loadtxt(io.StringIO(c)) for c in colors]

    labels = [
        _.split("Tiling based on solution")[0].strip()
        for _ in solver_output.split("Numeric Labels")[1:]
    ]
    labels = [np.loadtxt(io.StringIO(l)) for l in labels]
    
    solutions = list(zip(colors, labels))
    
    return solutions


def main():
    """Demonstrate the function"""
    
    # Tile the 2x3 rectangle with combinations of Polyominoes 1 to 9
    target_shape = np.ones((2, 3))
    sols = multihedral_tile(
        target_shape,
        polyomino_set=MONOMINOES + DOMINOES + TROMINOES,# + TETROMINOES,
        verbose=True
    )
    
    print("Found {} solutions".format(len(sols)))
    for i, (c, l) in enumerate(sols):
        print(l)


if __name__ == "__main__":
    main()
