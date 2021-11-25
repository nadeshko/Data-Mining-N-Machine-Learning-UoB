import sys
import math
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from random import random

def initialize_network():
    # NN-Size
    numInput = 4
    numHidden = 2
    numOutput = 4
    input = np.array([[0.9, 0.1, 0.1, 0.1], [0.1, 0.9, 0.1, 0.1],  # 4x4
                      [0.1, 0.1, 0.9, 0.1], [0.1, 0.1, 0.1, 0.9]])
    W_1 = np.array([[random() for i in range(numHidden)] for i in range(numInput)])  # 2x4
    W_2 = np.array([[random() for i in range(numOutput)] for i in range(numHidden)]) # 4x2
    return input, input, W_1, W_2

def sigmoid(x):
    return 1 / (1 + np.exp(-x))

def sigmoid_d(x):
    return sigmoid(x)*(1-sigmoid(x))

def main():
    input, target, W_1, W_2 = initialize_network()
    y_in   = np.dot(input, W_1)
    y_out  = sigmoid(y_in)
    out_in = np.dot(y_out, W_2)
    output = sigmoid(out_in)
    E_n = np.power((output - target),2)
    E = (1/2)*(E_n.sum())

    #y_in = np.matmul(np.matrix.transpose(W_1), input)   # 2x4.4x4 = 2x4
    #y_out = sigmoid(y_in)                               # 2x4
    #out_1 = np.matmul(np.matrix.transpose(W_2), y_out)  # 4x2.2x4 = 4x4
    #out_2 = sigmoid(out_1)
    #Error = target - out_2


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print('Interrupted')
        sys.exit()