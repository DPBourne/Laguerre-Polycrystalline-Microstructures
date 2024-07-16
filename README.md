# LPM: Laguerre-Polycrystalline-Microstructures
MATLAB and Python code for generating 2D and 3D synthetic polycrystalline microstructures using Laguerre tessellations, including fast algorithms for generating grains of prescribed volumes.

## Getting started ##

To use these MATLAB functions you must first install
* [MATLAB-Voro](https://github.com/smr29git/MATLAB-Voro)
* [MATLAB-SDOT](https://github.com/DPBourne/MATLAB-SDOT)
* [MatGeom](https://github.com/mattools/matGeom) by David Legland

Replace the file `matGeom/meshes3d/intersectPlaneMesh.m` with the version in this repository.

## Examples ##

See the `Examples` folder for examples from the following papers:
* Bourne, D.P., Pearce, M. & Roper, S.M. (2024) Inverting Laguerre tessellations: Recovering tessellations from the volumes and centroids of their cells using optimal transport, *arXiv:2406.00871*. [PDF](https://arxiv.org/abs/2406.00871)
* Bourne, D.P., Pearce, M. & Roper, S.M. (2023) Geometric modelling of polycrystalline materials: Laguerre tessellations and periodic semi-discrete optimal transport, *Mechanics Research Communications*, 127, 104023. [PDF](https://www.sciencedirect.com/science/article/pii/S0093641322001550)
* Bourne, D.P., Kok, P.J.J., Roper, S.M. & Spanjer, W.D.T. (2020) Laguerre tessellations and polycrystalline microstructures: A fast algorithm for generating grains of given volumes, *Philosophical Magazine*, 100, 2677-2707. [PDF](https://www.tandfonline.com/doi/full/10.1080/14786435.2020.1790053)

## Licence ##

See LICENCE.md

## Related software ##

* [pyAPD](https://github.com/mbuze/PyAPD) - our 'sister repository' for computing *anisotropic* Laguerre diagrams with grains of prescribed volumes
* [DREAM.3D](https://github.com/BlueQuartzSoftware/DREAM3D)
* [Kanapy](https://github.com/ICAMS/Kanapy)
* [Neper](https://github.com/neperfepx/neper)

## Main contributors ##

* [Steve Roper](https://www.gla.ac.uk/schools/mathematicsstatistics/staff/stevenroper/#), University of Glasgow
* [David Bourne](http://www.macs.hw.ac.uk/~db92/), Heriot-Watt University and the Maxwell Institute for Mathematical Sciences
* Mason Pearce, Heriot-Watt University and the Maxwell Institute for Mathematical Sciences

This work was in collaboration with Piet Kok (Universiteit Gent, Tata Steel) & Wil Spanjer (Tata Steel).
