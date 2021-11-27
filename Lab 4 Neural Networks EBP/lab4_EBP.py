import sys
import numpy as np
import matplotlib.pyplot as plt
from random import random

def initialize_network():
    # NN-Size
    numInput  = 4
    numHidden = 2
    numOutput = 4
    input = np.array([[0.9, 0.1, 0.1, 0.1], [0.1, 0.9, 0.1, 0.1],  # 4x4
                      [0.1, 0.1, 0.9, 0.1], [0.1, 0.1, 0.1, 0.9]])
    W_1 = np.array([[random() for i in range(numInput)] for i in range(numHidden)])  # 4x2
    W_2 = np.array([[random() for i in range(numHidden)] for i in range(numOutput)]) # 2x4
    return input, input, W_1, W_2

def sigmoid(x):
    return 1 / (1 + np.exp(-x))

def main():
    lr = 0.1
    Delta_W1 = np.zeros((2,4))
    Delta_W2 = np.zeros((4,2))

    input, target, W_1, W_2 = initialize_network()
    for epoch in range(1000):
        for i in range(4):
            y_in  = np.matmul(W_1, input[i])
            y_out = sigmoid(y_in)
            o_in  = np.matmul(W_2, y_out)
            o_out = sigmoid(o_in)
            Error = (1 / 2) * ((np.power((o_out - target[i]), 2)).sum())
            deltaj_out = (o_out - target[i]) * o_out * (1 - o_out)
            print(Delta_W2)
            print(deltaj_out.shape)
            print(np.array(y_out))
            #elta_W2   = Delta_W2 + ( -lr * (np.dot(np.array(y_out).T, deltaj_out)))

            #deltaj_H   = (np.matmul(W_2.T, deltaj_out)) * y_out * (1 - y_out)
            #Delta_W1   = Delta_W1 + ( -lr * (np.matmul(input[i], deltaj_H)))

        #if epoch % 100 == 0:
            #print('epoch: ',epoch, 'error: ', Error)
        #W_2 = W_2 + Delta_W2/4
        #W_1 = W_1 + Delta_W1/4
        #Delta_W2 = 0
        #Delta_W1 = 0

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print('Interrupted')
        sys.exit()