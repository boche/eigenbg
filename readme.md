# Introduction

This is a simple matlab implementation of Eigenbackground subtraction, which is first proposed in this paper: 

Oliver, Nuria M., Barbara Rosario, and Alex P. Pentland. "A Bayesian computer vision system for modeling human interactions." Pattern Analysis and Machine Intelligence, IEEE Transactions on 22.8 (2000): 831-843.


# Note

* ~~Due to the large dimension of covariance matrix, in this implementation the image is first discretized into blocks, whose size is set by the parameter *block_size*.~~ 
* This implementation works with multiple cameras, and would only train the model if no model is found for specified camera.

# Update

### 2015-07-26:
* With new implementation of Eigenbackground, now the algorithm is **no longer block based**, and is much faster in training and requires much less memory, with same output.
* Instead of converting to gray image first (and thus losing information) and then train eigenvectors, now the algorithm train first, and then merge r, g, b channel output by taking their maximum.
* add example output (images taken from PETS 2009) in example folder.

# License

GPL v3.0 license: [http://www.gnu.org/licenses/gpl-3.0.en.html](http://www.gnu.org/licenses/gpl-3.0.en.html)