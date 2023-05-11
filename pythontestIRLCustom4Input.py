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
from keras.layers.core import Dense, Activation, Dropout
from keras.optimizers import RMSprop
#Thanks this guy:https://github.com/jangirrishabh/toyCarIRL/tree/a5f76ab162740905269d8b9f7bd24eb161276cad

class IRLClass:

    '''    def train(self,W,i):
        self.model #This is the model to use?



 #filename = params_to_filename(params)

    observe = 1000  # Number of frames to observe before training.
    epsilon = 1
    train_frames = trainFrames  # Number of frames to play. 
    batchSize = [40,100,400]
    buffer = [10000, 50000]
    train_frames = 10000

    # Just stuff used below.
    max_car_distance = 0
    car_distance = 0
    t = 0
    data_collect = []
    replay = []  # stores tuples of (S, A, R, S').

    loss_log = []

    # Create a new game instance.
#    game_state = carmunk.GameState(weights)

    # Get initial state by doing nothing and getting the state.
#    _, state, temp1 = game_state.frame_step((2))

    # Let's time it.
#    start_time = timeit.default_timer() #not helpful

    # Run the frames.
    while t < train_frames:

        t += 1
        car_distance += 1

        # Choose an action.
        if random.random() < epsilon or t < observe:
            action = np.random.randint(0, 3)  # random #3
        else:
            # Get Q values for each action.
            qval = model.predict(state, batch_size=1)
            action = (np.argmax(qval))  # best
            #print ("action under learner ", action)

        # Take action, observe new state and get our treat.
#        reward, new_state, temp2 = game_state.frame_step(action)
#

        # Experience replay storage.
        replay.append((state, action, reward, new_state))

        # If we're done observing, start training.
        if t > observe:

            # If we've stored enough in our buffer, pop the oldest.
            if len(replay) > buffer:
                replay.pop(0)

            # Randomly sample our experience replay memory
            minibatch = random.sample(replay, batchSize)

            # Get training values.
            X_train, y_train = process_minibatch(minibatch, model)

            # Train the model on this batch.
            history = LossHistory()
            model.fit(
                X_train, y_train, batch_size=batchSize,
                nb_epoch=1, verbose=0, callbacks=[history]
            )
            loss_log.append(history.losses)

        # Update the starting state with S'.
        state = new_state

        # Decrement epsilon over time.
        if epsilon > 0.1 and t > observe:
            epsilon -= (1/train_frames)

        # We died, so update stuff.
        if state[0][7] == 1:
            # Log the car's distance at this T.
            data_collect.append([t, car_distance])

            # Update max.
            if car_distance > max_car_distance:
                max_car_distance = car_distance

            # Time it.
            tot_time = timeit.default_timer() - start_time
            fps = car_distance / tot_time

            # Output some stuff so we can watch.
            #print("Max: %d at %d\tepsilon %f\t(%d)\t%f fps" %
                  #(max_car_distance, t, epsilon, car_distance, fps))

            # Reset.
            car_distance = 0
            start_time = timeit.default_timer()

        # Save the model 
        if t % train_frames == 0:
            model.save_weights('saved-models_'+ path +'/evaluatedPolicies/'+str(i)+'-'+ filename + '-' +
                               str(t) + '.h5',
                               overwrite=True)
            print("Saving model %s - %d" % (filename, t))

    # Log results after we're done all frames.
    log_results(filename, data_collect, loss_log)


        
        return'''

    def play(self,model,W):
        while(true):
            state = GETFROMMATLAB ######TODO this bit is the challenging bit
            action = (np.argmax(model.predict(state, batch_size=1)))            
            featureExpectations += (GAMMA**(car_distance-101))*np.array(readings) #TODO the 'readings' are the state, aren't they?
            if(MATLABQUIT):
                break
        return featureExpectations
    
    def ConstructNetwork(self, n_states, n_actions, params):
        print("Constructing...")
        model = Sequential()
        model.add(Dense(params[0], bias_initializer='lecun_uniform', input_shape=(n_states,)))
        model.add(Activation('relu'))
        model.add(Dropout(0.2))
        # Second layer.
        model.add(Dense(params[1], bias_initializer='lecun_uniform'))
        model.add(Activation('relu'))
        model.add(Dropout(0.2))
        # Output layer.
        model.add(Dense(n_actions, bias_initializer='lecun_uniform'))
        model.add(Activation('linear'))

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
            print(i)
            policyList.append(self.policiesFE[i])
            print(self.policiesFE[i])
            h_list.append(1)
        policyMat = np.matrix(policyList)        
        policyMat[0] = -1*policyMat[0]
        print("PL2")
        print(policyList)
        print(":")
        print(policyMat)      
        print("beforeG")
        G = matrix(policyMat, tc='d') #This is the problem one
        h = matrix(-np.array(h_list), tc='d')
        sol = solvers.qp(P,q,G,h)

        weights = np.squeeze(np.asarray(sol['x']))
        norm = np.linalg.norm(weights)
        weights = weights/norm
        return weights

    '''
    def GetPolicy(self):
        #pick a file
        #read the file
        fileTime = 0
        fileVelocity = 0;
        fileLocation = 0;
        return GetPolicyFromExpertState(fileTime,fileVelocity,fileLocation)
    
    def GetPolicyFromExpertState(self,time,velocity,location):
        #TODO do this in matalb?
        #return newPolicy
        return[0.1,0.2,0,0] # This I feel should be like one for each step??
    '''

    def __init__(self, n_states, n_actions, params, expertFE, epsilon= 0.2, lr = 0.15):
        self.n_states = int(n_states)
        self.n_actions = int(n_actions)
        self.expertPolicy = expertFE
        self.randomPolicy = np.zeros(self.n_states) #This is  the 'states' but will be our random feature expectation
        for fIndex in range(self.n_states):
        #for(randomFeature in self.currentPolicy)
            #May not be a safe operation - test, if not then just use a normal for
            self.randomPolicy[fIndex] = random.uniform(-1,1);
        print(self.randomPolicy)
        self.randomT = np.linalg.norm(np.asarray(self.expertPolicy)-np.asarray(self.randomPolicy))
        self.epsilon = epsilon
        self.lr = lr 
        self.model = self.ConstructNetwork(self.n_states, self.n_actions, params)
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
