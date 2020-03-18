# polyomino-solver

Find all multihedral tilings of an arbitrary pattern using free [Polyominoes](https://en.wikipedia.org/wiki/Polyomino).

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
for label, coloring in sols: print(label)

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

Keep in mind that the underlying solver optimization requires inverting a binary linear matrix system.
As such, the time complexity is approximately cubic in the area of the target shape.
To put this in perspective, using an Intel 8 Core i7-8650u laptop processor at 1.9GHz to solve the tiling of a shape with area 10 takes 5 minutes.
Using the same laptop to solve a pattern with area 14 takes about a week.

## Acknowledgements

This package is simply a thin convenience wrapper around the amazing Matlab
[Polyomino library](https://people.sc.fsu.edu/~jburkardt/m_src/polyominoes/polyominoes.html)
provided free under GPL by John Burkardt at his website.
Much thanks to him, and please see their paper describing the method at;

 * Garvie, Marcus R., and John Burkardt. *"[A New Mathematical Model for Tiling Finite Regions of the Plane with Polyominoes](https://people.sc.fsu.edu/~jburkardt%20/publications/gb_2018.pdf)"*.

I have made minor modifications to the library, in particular I have enabled both H1 and H2 solution verification steps to screen out all invalid solutions.
Please see [this patch](https://github.com/aaronsnoswell/polyomino-solver/commit/7eef4bc27418c0a9edea216f6306bbc140faa6bf) for details.

Also thanks to the following;

 * [P. Todd Decker](https://www.boardgamegeek.com/user/ptdecker) from
   BoardGameGeek for the [Polyomino reference PDF](https://www.boardgamegeek.com/filepage/15838/blokus-refpdf).
