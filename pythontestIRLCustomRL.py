import gym
import numpy as np
import time
import random
import keras
from cvxopt import matrix 
from cvxopt import solvers #convex optimization library
#from learning import IRL_helper
"""
The design of -theNN- comes from here:
http://outlace.com/Reinforcement-Learning-Part-3/
"""
from keras.models import Sequential
from keras.layers.core import Dense, Activation, Dropout
from keras.optimizers import RMSprop, Adam
#Thanks this guy:https://github.com/jangirrishabh/toyCarIRL/tree/a5f76ab162740905269d8b9f7bd24eb161276cad

class IRLClass:    
    
    def ConstructNetwork(self, n_states, n_actions, params):
        print("Constructing...")
        model = Sequential()
        model.add(Dense(params[0], bias_initializer='lecun_uniform', input_shape=(n_states,)))
        model.add(Activation('tanh'))
        #model.add(Dropout(0.2))
        # Second layer.
      #  model.add(Dense(params[1], bias_initializer='lecun_uniform'))
      #  model.add(Activation('tanh'))
       # model.add(Dropout(0.2))
        # Output layer.
        model.add(Dense(n_actions, bias_initializer='lecun_uniform'))#, input_shape=(n_states,)))
        #model.add(Activation('softmax'))#sigmoid
      #  model.add(Activation('tanh'))

        #rms = RMSprop()
        rms=Adam(lr=0.00001)
        #rms=Adam()
        model.compile(loss='mse', optimizer=rms,metrics=['accuracy'])
        print("Done")
        return model

    def UpdatePolicyList(self,W,PlayW,i):
        #Train the agent - this guy saves to file, we probably won't
      #  model = train(W,i)
        #play the model - return the FE
     #   tempFE = play(model,W)
        hyperDistance = np.abs(np.dot(W, np.asarray(self.expertPolicy)-np.asarray(PlayW)))
        print(hyperDistance)
        print(PlayW)
        self.policiesFE[hyperDistance] = PlayW
        print("all Policies:")
        print(self.policiesFE)
        return hyperDistance

#Direct Copy from the one above (then modified to 'work') - this can be changed out later if needed.
#Convex optimisation
    def Optimise(self, expertPolicy):
        m = len(expertPolicy)
        #print(m)
        P = matrix(2.0*np.eye(m), tc='d') # min ||w||
        q = matrix(np.zeros(m), tc='d')
        policyList = [np.asarray(expertPolicy)]
        #print("PL")
        #print(policyList)
        h_list = [1]
        #print("keys")
        #print(self.policiesFE.keys())
        for i in self.policiesFE.keys():
            print(i)
            policyList.append(np.squeeze(self.policiesFE[i]))
            print(policyList)
            h_list.append(1)
        policyMat = np.matrix(np.squeeze(policyList))#.astype(np.double)
        policyMat[0] = -1*policyMat[0]
        '''print("PL2")
        print(policyList)
        print(":")
        print(policyMat)      
        print("beforeG")'''
        G = matrix(np.squeeze(policyMat), tc='d') #This is the problem one
        print("G")
        #print(G)
        h = matrix(-np.array(h_list), tc='d')
        print(P)
        print(q)
        print(G)
        print(h)
        sol = solvers.qp(P,q,G,h)
        print("Solved!")

        weights = np.squeeze(np.asarray(sol['x']))
        norm = np.linalg.norm(weights)
        weights = weights/norm
        return weights

    def __init__(self, n_states, n_actions, params):
        self.n_states = int(n_states)
        self.n_actions = int(n_actions)
        #self.expertPolicy = expertFE
        #self.randomPolicy = np.zeros(self.n_states) #This is  the 'states' but will be our random feature expectation
        #for fIndex in range(self.n_states):
        #for(randomFeature in self.currentPolicy)
            #May not be a safe operation - test, if not then just use a normal for
        #    self.randomPolicy[fIndex] = random.uniform(-1,1);
        #print(self.randomPolicy)
        #self.randomT = np.linalg.norm(np.asarray(self.expertPolicy)-np.asarray(self.randomPolicy))
        #self.epsilon = epsilon
        #self.lr = lr 
        self.model = self.ConstructNetwork(self.n_states, self.n_actions, params)
        #self.policiesFE = {self.randomT:self.randomPolicy}
        #self.currentT = self.randomT
        #self.minimumT = self.randomT
        #solvers.options['feastol'] = 1e-2
        solvers.options['maxiters'] = 20;
'''
#Setup portion
random.seed(1000)
numStates = 4 #Velocity x #Velocity y #Location x #Location y
numActions = 8
epsilon = 0.2
learningRate = 0.15
hiddenLayers = [164,150]
irl = IRLClass( numStates, numActions, hiddenLayers, epsilon, lr)

#Training Loop
#first optimise the 'weights' - this is the input FE I think (reward part)
#Then update the policy, returning the 'hyperdistance' - which is also our error (policy part)
stepIndex = 0
while(stepIndex<10)
    CurrentExpertPolicy = GetPolicy()
    FirstLayerWeights = Optimise()
    newHyperDistance = UpdatePolicyList(FirstLayerWeights,stepIndex)
    print(newHyperDistance+"\r\n")
    stepIndex = stepIndex+1
    if(newHyperDistance <= epsilon) #hyperdistance is the 'error' if you will, so above we are positioning the new data in order of error? I think?
       break
'''
