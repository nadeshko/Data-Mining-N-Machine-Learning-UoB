X = load('lab2Data-matlab');
C = cov(X);
[U,D] = eig(C)
