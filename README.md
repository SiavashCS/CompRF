# CompRF

The MATLAB code for the "comparison-based random forest" algorithm. The algorithm is proposed in:

S. Haghiri, D. Garreau, U. von Luxburg, “Comparison-Based Random Forests”, in ICML 2018.

The code contains four scripts to run the four main experiments discussed in the paper:

- Exp1_Classification.m: Runs the classification experiments reported in section 4.1.1 
- Exp2_Regression.m: Runs the regression experiments reported in section 4.1.2
- Exp3_GraphKernels.m: Runs the experiments in the non-Euclidean setting reported in section 4.2
- Exp4_s.m: Runs the experiments in the non-Euclidean setting reported in section 4.3


Two external library are included in the repository, you can find the original codes in the following:

- The WL graph kernel library by Nino Shervashidze:
http://mlcb.is.tuebingen.mpg.de/Mitarbeiter/Nino/Graphkernels/
Related paper: Shervashidze, Nino, et al. "Weisfeiler-lehman graph kernels." JMLR 12.Sep (2011): 2539-2561.

- The STE algorithm by Larens Van Der Maaten:
https://lvdmaaten.github.io/ste/Stochastic_Triplet_Embedding.html
Related paper: L.J.P. van der Maaten and K.Q. Weinberger. Stochastic Triplet Embedding. In MLSP , 2012.

In case of problems with code or any questions you can contact me via the following email:

haghiri [at] informatik.uni-tuebingen.de
