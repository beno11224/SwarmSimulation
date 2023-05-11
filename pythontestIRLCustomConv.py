import gym
import numpy as np
import time
import random
from cvxopt import matrix 
from cvxopt import solvers #convex optimization library
#from learning import IRL_helper
"""
The design of -theNN- comes from here:
http://outlace.com/Reinforcement-Learning-Part-3/
"""
from keras.models import Sequential
#from keras.layers.core import Dense, Activation, Dropout
#from keras.layers.core import Dense, Conv2D, MaxPooling2D, Flatten
from keras.optimizers import RMSprop

from tensorflow.keras.layers import Dense, Conv2D, MaxPooling2D, Flatten
#Thanks this guy:https://github.com/jangirrishabh/toyCarIRL/tree/a5f76ab162740905269d8b9f7bd24eb161276cad

class IRLClass: 

    '''def play(self,model,W):
        while(true):
            state = GETFROMMATLAB ######TODO this bit is the challenging bit
            action = (np.argmax(model.predict(state, batch_size=1)))            
            featureExpectations += (GAMMA**(car_distance-101))*np.array(readings) #TODO the 'readings' are the state, aren't they?
            if(MATLABQUIT):
                break
        return featureExpectations
    '''
    def ConstructNetwork(self, state_size, n_actions, params):
        print("Constructing...")
        ''' model = Sequential()
        model.add(Dense(params[0], bias_initializer='lecun_uniform', input_shape=(n_states,)))
        model.add(Activation('relu'))
        model.add(Dropout(0.2))
        # Second layer.
        model.add(Dense(params[1], bias_initializer='lecun_uniform'))
        model.add(Activation('relu'))
        model.add(Dropout(0.2))
        # Output layer.
        model.add(Dense(n_actions, bias_initializer='lecun_uniform'))
        model.add(Activation('linear'))'''
        num_filters = 8
        filter_size = 3
        pool_size = 2
        model = Sequential()
        print("Making model")
        model.add(Conv2D(num_filters, filter_size, input_shape=(state_size[0],state_size[1],1)))
        print("firstLayer")
        model.add(MaxPooling2D(pool_size=pool_size))
        model.add(Flatten())
        model.add(Dense(n_actions, activation='softmax'))

        rms = RMSprop()
        model.compile(loss='mse', optimizer=rms)
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
        print("optimising")
        v = memoryview(expertPolicy)
        print(v)
        print("someStuff")
        print(expertPolicy)
        m = len(expertPolicy)
        P = matrix(2.0*np.eye(m), tc='d') # min ||w||
        q = matrix(np.zeros(m), tc='d')
        policyList = [expertPolicy]
        print("PL")
        print(policyList)
        h_list = [1]
        print("keys")
        print(self.policiesFE.keys())
        for i in self.policiesFE.keys():
            print("This is i:")
            print(i)
            print(self.policiesFE[i])
            policyList.append(self.policiesFE[i])
            print("appended")
            h_list.append(1)
            print(policyList[0])
        policyMat = np.matrix(policyList)
        print("made to differentMatrix")
        policyMat[0] = -1*policyMat[0]
        print("PL2")
        print(policyList)
        print(":")
        print(policyMat)      
        print("beforeG")
        G = matrix(policyMat, tc='d') #This is the problem one
        h = matrix(-np.array(h_list), tc='d')
        print("Solving")
        print(len(G))
        #print(G[0])
        #print(len(G[0][0]))
        sol = solvers.qp(P,q,G,h)

        weights = np.squeeze(np.asarray(sol['x']))
        norm = np.linalg.norm(weights)
        weights = weights/norm
        return weights


    def __init__(self, state_sz, n_actions, params, expertFE, epsilon= 0.2, lr = 0.15):
        self.state_size = [int(state_sz[0]),int(state_sz[1])]
        self.n_actions = int(n_actions)
        self.expertPolicy = expertFE
        self.randomPolicy = np.zeros(self.state_size) #This is  the 'states' but will be our random feature expectation
        for fIndex in range(self.state_size[0]):
            for fIndexy in range(self.state_size[1]):
                #for(randomFeature in self.currentPolicy)
                #May not be a safe operation - test, if not then just use a normal for
                self.randomPolicy[fIndex,fIndexy] = random.uniform(-1,1);
        #print(self.randomPolicy)
        self.randomT = np.linalg.norm(np.asarray(self.expertPolicy)-np.asarray(self.randomPolicy))
        self.epsilon = epsilon
        self.lr = lr 
        self.model = self.ConstructNetwork(self.state_size, self.n_actions, params)
        self.policiesFE = {self.randomT:self.randomPolicy}
        self.currentT = self.randomT
        self.minimumT = self.randomT
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
