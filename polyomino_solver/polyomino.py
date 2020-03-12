"""Find Multihedral tilings using Polyominoes
"""

import os
import io
import subprocess

import numpy as np


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
            ind_tuple = np.unravel_index(i,d_to_loop[::-1])[::-1]
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
        allow_flipping=True,
        MATLAB_PATH = "C:\\Program Files\\MATLAB\\R2019a\\bin\\matlab.exe"
    ):
    """Find multihedral Polyomino tilings of a given shape
    
    Args:
        target_shape (numpy array): Binary 2D array giving the target shape we
            want to tile
        
        polyomino_set (list): Optional list indices to restrict the set of
            available polyominoes. See `blokus_polyominoes.pdf` for indices. If
            emtpy, all Polyominoes of size 1-5 will be used.
        allow_flipping (bool): If True, flipping polyominoes will be allowed.
        MATLAB_PATH (str): OS-appropriate absolute path to Matlab binary
        
    Returns:
        (list): List of unique configurations that tile the target shape
    """
    
    # Convert to numpy array
    target_shape = np.array(target_shape)
    
    # Path to the polyomino_solver.m file relative to this file
    SOLVER_PATH = os.path.dirname(os.path.abspath(__file__))
    
    # Name of the function in the polyomino_solver.m file
    if len(polyomino_set) == 0:
        SOLVER_COMMAND = "polyomino_solver({})".format(
            np2matlab(target_shape, '%d')
        )
    else:
        SOLVER_COMMAND = "polyomino_solver({}, {})".format(
            np2matlab(target_shape, '%d'),
            polyomino_set
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

    # Parse solutions arrays from stdout
    solutions = [
        _.split("Tiling based on solution")[0].strip().replace("  ", "")
        for _ in solver_output.split("Numeric Labels")[1:]
    ]

    # Parse solutions to numpy arrays
    solutions = [
        np.loadtxt(io.StringIO(sol))
        for sol in solutions
    ]
    
    # Filter solutions based on constraints
    # TODO ajs 12/03/2020
    if not allow_flipping: raise NotImplementedError("Not yet implemented!")
    
    return solutions


def main():
    """Demonstrate the function"""
    
    # Tile the 2x3 rectangle with combinations of Polyominoes 1 and 9
    target_shape = np.ones((2, 3))
    sols = multihedral_tile(target_shape, polyomino_set=[1, 9])
    
    print("Found {} solutions".format(len(sols)))
    for sol in sols:
        print(sol)


if __name__ == "__main__":
    main()
