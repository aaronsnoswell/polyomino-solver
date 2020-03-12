# polyomino-solver

Find multihedral tilings of patterns using Polyominoes.

## Installation

```bash
git clone https://github.com/aaronsnoswell/polyomino-solver.git
cd polyomino-solver
pip install -e .
```

## Requirements

Tested with Python 3.6 on Windows. Should support other OS' just fine though.
Requires Matlab to be installed and accessible.

## Usage

To tile the 2x3 rectangle with combinations of Polyominoes 1 and 9:

```python
from polyomino_solver import multihedral_tile
sols = multihedral_tile([[1, 1, 1], [1, 1, 1]], polyomino_set=[1, 9])
for s in sols: print(s)

```

Gives the output;

```bash
[[1. 2. 3.]
 [4. 5. 6.]]
[[3. 3. 1.]
 [2. 3. 3.]]
[[1. 3. 3.]
 [3. 3. 2.]]
```