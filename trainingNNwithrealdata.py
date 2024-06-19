#!/usr/bin/env python
# coding: utf-8

# In[1]:


import numpy as np
import keras
import random
from keras.models import Sequential
from keras.layers import Input, Dense, Activation, Dropout
from keras.optimizers import Adam, SGD
import mat73
#Thanks this guy:https://github.com/jangirrishabh/toyCarIRL/tree/a5f76ab162740905269d8b9f7bd24eb161276cad

class NNClass:    
    
    def ConstructNetwork(self,n_states, n_actions, params):
        # use seed to make results re-producable
        np.random.seed(1000)
        random.seed(1000)
        keras.utils.set_random_seed(1000)

        #Tells keras it's a feedforward (sequential) architecture
        model = Sequential()
        model.add(Input(shape=(n_states,)))
        model.add(Dense(params[0], activation='relu', bias_initializer='lecun_uniform', kernel_initializer='lecun_uniform'))
        model.add(Dropout(0.5))
        model.add(Dense(params[1], activation='relu', bias_initializer='lecun_uniform', kernel_initializer='lecun_uniform'))
        model.add(Dropout(0.5))
        model.add(Dense(params[2], activation='relu', bias_initializer='lecun_uniform', kernel_initializer='lecun_uniform'))
        model.add(Dropout(0.5))
        model.add(Dense(params[3], activation='relu', bias_initializer='lecun_uniform', kernel_initializer='lecun_uniform'))
        model.add(Dense(n_actions, activation='tanh', bias_initializer='lecun_uniform', kernel_initializer='lecun_uniform'))
        #Choose the optimiser and compile the model
        #metrics allow us to graph the statistical performance of the network later - loss is recorded automatically, accuracy is used as an example and is not required.
        optimiser=Adam()
        
        model.compile(optimizer = optimiser, loss = "mse")

        return model

    def __init__(self, n_states, n_actions, params):
        self.n_states = int(n_states)
        self.n_actions = int(n_actions)
        self.model = self.ConstructNetwork(self.n_states, self.n_actions, params)


# In[2]:

def runTraining():

    import scipy.io as sio

    #dataset = sio.loadmat('ExampleTunedDataFile.mat')
    dataset = mat73.loadmat('ExampleTunedDataFile.mat')
    print(dataset['expertStates'])
    print(":")
    print(dataset['valExpertStates'])
    if dataset['valExpertStates'] is not None:
        X = np.concatenate((dataset['expertStates'],dataset['valExpertStates']))
        y = np.concatenate((dataset['expertActions'],dataset['valExpertActions']))
        #print(dataset['expertActions'])
        print("WithVAL")
    else:
        X = dataset['expertStates']
        y = dataset['expertActions']
        #print(X)
        print("NoVAL")
    #numStates=102
    numStates=34
    numActions=2
    hiddenLayers=[200,100,50,20]
    model = NNClass(numStates,numActions,hiddenLayers)
    model.model.summary()
    history = model.model.fit(X, y, epochs = 200,batch_size = 256)

    print('RMSE on outputs', model.model.evaluate(X,y,batch_size=len(X)) ** 0.5)

    model.model.save("BestModel")
