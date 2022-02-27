# AbInitioTopo

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://oashour.github.io/AbInitioTopo.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://oashour.github.io/AbInitioTopo.jl/dev)
[![Build Status](https://github.com/oashour/AbInitioTopo.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/oashour/AbInitioTopo.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/oashour/AbInitioTopo.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/oashour/AbInitioTopo.jl)

AbInitioTopo.jl is a Julia concept package for copmuting topological invariants and other topological properties of materials from first principles calculations.

Currently, this package is only capable of computing Z2 and Z4 invariants for systems with inversion symmetry. Z4 invariants are only defined when the system is both time-reversal and inversion symmetric, and Z2 reqiures time-reversal symmetry. If your system breaks inversion symmetry, this package won't work (yet).

# Workflow
## Requirements
1. `phonopy`, see instructions [here](https://phonopy.github.io/phonopy/install.html).
2. `irvsp`, see instructions [here](https://ashour.dev/DFT+Technical/Compiling+irvsp)
3. Julia, see [here](https://julialang.org/downloads/). In Julia, install the package as follows:
```
julia> ]
pkg> add XXX
```
## Procedure
1. Generate a `POSCAR` file from VESTA or any other method.
2. Run `phonopy --tolerance 0.01 --symmetry -c POSCAR` in the folder to generate the file `PPOSCAR` with the standard orientation. 
3. `cp PPOSCAR POSCAR`
4. Run an SCF calculation for your system, make sure it is properly converged. You should obviously be using spin-orbit coupling. (`LSORBIT = .TRUE.`)
5. Run an NSCF calculation for your system (`ICHARG=11`) with the following `KPOINTS`. The order is extremely important or AbInitioTopo.jl won't work.
```
TRIM
8
Reciprocal
0.0 0.0 0.0 1 \Gamma
0.5 0.0 0.0 1 X
0.0 0.5 0.0 1 Y
0.0 0.0 0.5 1 Z
0.5 0.5 0.0 1 M1
0.5 0.0 0.5 1 M2
0.0 0.5 0.5 1 M3
0.5 0.5 0.5 1 R
```
6. After the calculation is done, open the `OUTCAR`. You should see something like
```
Space group operators:
 irot       det(A)        alpha          n_x          n_y          n_z        tau_x        tau_y        tau_z
    1     1.000000     0.000000     1.000000     0.000000     0.000000     0.000000     0.000000     0.000000
    2    -1.000000     0.000000     1.000000     0.000000     0.000000     0.000000     0.000000     0.000000
    3     1.000000   120.000000    -0.577350    -0.577350    -0.577350     0.000000     0.000000     0.000000
    4    -1.000000   120.000000    -0.577350    -0.577350    -0.577350     0.000000     0.000000     0.000000
    5     1.000000   120.000000     0.577350     0.577350     0.577350     0.000000     0.000000     0.000000
    6    -1.000000   120.000000     0.577350     0.577350     0.577350     0.000000     0.000000     0.000000
```
7. Delete all the symmetry operations from `OUTCAR` except the first 2 (identity and inversion):
```
Space group operators:
 irot       det(A)        alpha          n_x          n_y          n_z        tau_x        tau_y        tau_z
    1     1.000000     0.000000     1.000000     0.000000     0.000000     0.000000     0.000000     0.000000
    2    -1.000000     0.000000     1.000000     0.000000     0.000000     0.000000     0.000000     0.000000
```
8. Run `irvsp -sg 2 > irvsp.out`. This tells `irvsp` to use space group 2 (i.e. only identity and inversion, this is why we edited the `OUTCAR`)
9. Download `irvsp.out` to whatever local machine you are running Julia on, or keep it on the cluster if you're using Julia there.