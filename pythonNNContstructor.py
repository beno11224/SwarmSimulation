import numpy as np
import keras
import random
from keras.models import Sequential
from keras.layers.core import Dense, Activation
from keras.optimizers import Adam
#Thanks this guy:https://github.com/jangirrishabh/toyCarIRL/tree/a5f76ab162740905269d8b9f7bd24eb161276cad

class NNClass:    
    
    def ConstructNetwork(self,n_states, n_actions, params):
        print("Constructing...")
        #Tells keras it's a feedforward (sequential) architecture
        model = Sequential()
        #Used in building layers - for keras each layer needs to know the number of inputs, the outputs are generated automatically.
        previous_layer_size = n_states
        print(params)
        try:
            num_layers = len(params)
        except:
            num_layers = 1
        #Hidden layers
        if(num_layers > 1):
            for h_layer_index in range(num_layers):
              #Add a new (hidden) layer - each layer has a size dictated by params, has the tanh activation function, and has the biases initialised using the lecun distribution.
              model.add(Dense(params[h_layer_index], activation='tanh', bias_initializer='lecun_uniform', input_shape=(previous_layer_size,)))
              previous_layer_size = params[h_layer_index]
        else:
            #else there's only one hidden layer and the [] cause errors
            model.add(Dense(params, activation='tanh', bias_initializer='lecun_uniform', input_shape=(previous_layer_size,)))
        # Output layer.
        model.add(Dense(n_actions, bias_initializer='lecun_uniform'))
        #Choose the optimiser and compile the model
        #metrics allow us to graph the statistical performance of the network later - loss is recorded automatically, accuracy is used as an example and is not required.
        rms=Adam(lr=0.00001)
        model.compile(loss='mse', optimizer=rms,metrics=['accuracy'])

        print("Done")
        return model

    def __init__(self, n_states, n_actions, params):
        self.n_states = int(n_states)
        self.n_actions = int(n_actions)
        self.model = self.ConstructNetwork(self.n_states, self.n_actions, params)
