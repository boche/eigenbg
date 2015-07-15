# Intro

This is a simple matlab implementation of Eigenbackground subtraction, which is first proposed in this paper: 

Oliver, Nuria M., Barbara Rosario, and Alex P. Pentland. "A Bayesian computer vision system for modeling human interactions." Pattern Analysis and Machine Intelligence, IEEE Transactions on 22.8 (2000): 831-843.


# Folder structure

data
├── bg
├── src
└── train
    └── src


# Note

* Due to the large dimension of covariance matrix, in this implementation the image is first discretized into blocks, whose size is set by the parameter *block_size*.
* This implementation works with multiple cameras, and would only train the model if no model is found for specified camera.