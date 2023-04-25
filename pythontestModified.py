import gym
import numpy as np
import time
import random

class QLearning:
    def __init__(self, n_states, n_actions, epsilon= 0.2, lr = 0.15, gamma = 0.995, episodes = 5*10**3, timestep = 1000):
        self.n_states = n_states
        self.n_actions = n_actions
        
        self.epsilon = epsilon
        self.lr = lr
        self.gamma = gamma
        self.episodes = episodes
        self.timestep = timestep
        
#        self.env = gym.make('CartPole-v0') # - use my sim

        self.episode = 0
        self.steps = 0
        self.rewards = 0
        self.solved = False 
        self.runs = [0]
        self.data = {'max' : [0], 'avg' : [0]}
        self.bin_size = 10
        self.score = 0
        self.bins = [np.linspace(-1,1,self.bin_size), #minmax velocity #check for min/max velocity.
                np.linspace(-1,1,self.bin_size),
                np.linspace(-0.01,0.015,self.bin_size), #minmax location
                np.linspace(-0.01,0.01,self.bin_size)]
#        self.bins = [np.linspace(-4.8,4.8,self.bin_size), #THIS is the setup - min and max for each STATE, actions here are discrete (e.g. left/right)
#                np.linspace(-4,4,self.bin_size),
#                np.linspace(-0.418,0.418,self.bin_size),
#                np.linspace(-4,4,self.bin_size)]
        self.q_table = np.random.uniform(low=-1,high=1,size=([self.bin_size] * self.n_states + [self.n_actions]))
        self.prev_state = 0;
        self.prev_action = 0;


        
    def Discrete(self, state):
        index = []
        for i in range(len(state)):
            index.append(np.digitize(state[i],self.bins[i]) - 1)
        return tuple(index)
                
    def Q_LearningActionLoop(self, observation, reward, done, info):
        
        next_state = self.Discrete(observation)
        self.score += reward
                

        if not done:
            max_future_q = np.max(self.q_table[next_state])
            current_q = self.q_table[self.prev_state+(self.prev_action,)] #TODO read before assign - not right.
            new_q = (1-self.lr)*current_q + self.lr*(reward + self.gamma*max_future_q)
            self.q_table[self.prev_state+(self.prev_action,)] = new_q

        self.prev_state = next_state

        if(done):
            # End of the loop update
            self.rewards += self.score
            self.runs.append(self.score)
            if self.score > 195 and self.steps >= 100 and self.solved == False: # considered as a solved:
                self.solved = True
                print('Solved in episode : {} '.format(self.episode))
            
            # Timestep value update
            if self.episode%self.timestep == 0:
                print('Episode : {} | Reward -> {} | Max reward : {}'.format(self.episode,self.rewards/self.timestep, max(self.runs)))
                self.data['max'].append(max(self.runs))
                self.data['avg'].append(self.rewards/self.timestep)
                if self.rewards/self.timestep >= 195: 
                    print('Solved in episode : {}'.format(self.episode))
                self.rewards, self.runs= 0, [0]
            #reset - next 'episode'.
            self.episode += 1
            self.score = 0;
            return True
        #Now start the loop again
        else:
            self.steps += 1
            if np.random.uniform(0,1) < self.epsilon:
                #self.prev_action = self.env.action_space.sample() #pick a random action
                self.prev_action = random.randint(0, 7)
               # print("random action = ",self.prev_action)
            else:
                self.prev_action = np.argmax(self.q_table[self.prev_state])
            return False

#States - very large discrete, so can use bins as above to provide a sensible level of accuracy:
        #Velocity x
        #Velocity y
        #Location x
        #Location y

        #Start with above, then need to do tie it to play space:
        #this should arguably be a visual layer (confluithingy layer in NN speak) this would then be the only inputs.
        
#Actions - arguably continuous:(Force x/Force y) discretise to 8 (clockwise)(up/upright/right/downright/down/downleft/left/upleft) to start with, increase action space accordingly.

#Recorded values:
        #Time ,1 value discrete. not sure how to use this - might be best to remove for training?
        ##Force x (action), 1 value
        ##Force y (action), 1 value
        #GoalPercentage (success metric)/ discrete, 1 value
        #Velocity x - per particle(500)
        #Velocity y - per particle(500)
        #Location x - per particle(500)
        #Location y - per particle(500)
        #end zones -  different success metric, 5 per particle (2,500)

#    def resultThenNextAction(self,obj1,exit_Loop):
#    #Do the previous step.
#    if(!exit_Loop)
#        exit_Loop = obj1.Q_LearningActionLoop(res[0], res[1], res[2], res[3])
#    if(!exit_Loop)
#        if np.random.uniform(0,1) < obj1.epsilon:
#            #act = obj1.env.action_space.sample() #TODO what's this? - random action?
#            act = random.randint(0, 7)
#        else:
#            act = np.argmax(obj1.q_table[obj1.prev_state])
#        act = act + 1; #Matlab action starts at 1. 0 is being used to exit the loop instead (shouldn't be reqired from Python, but keeping the functionality)
#    else act = 0;    
#    return act
                             
                             

'''#%# TRANING
obj1 = QLearning(4,2)#OriginalVersion
nparticles = 500
states = 4
#obj1 = QLearning(4,8)
episodeEnd = False
obs = obj1.env.reset()
a = len(obs[0])
obj1.prev_state = obj1.Discrete(obs[0])
#%while(not episodeEnd):
#%    exit_Loop = False
#%    while(not exit_Loop):
#%        #Make the action decision
#%        if np.random.uniform(0,1) < obj1.epsilon:
#%            act = obj1.env.action_space.sample() #TODO what's this? - random action?
#%        else:
#%            act = np.argmax(obj1.q_table[obj1.prev_state])
#%
#%        #This is the action - this is where MATLAB sits - so the above action is passed in, and then the below is called.
#%        res = obj1.env.step(act);
#%        a = res[0]
#%        b = res[1]
#%        c = res[2]
#%        d = res[3]
#%        
#%        exit_Loop = obj1.Q_LearningActionLoop(res[0], res[1], res[2], res[3])
#%        #Above we actually return the action to take, and let matlab determine if we're done or not (res[3])
#%        #Matlab will actually do this loop, we're just contstructing the model in python and accessing it in matlab
#%    episodeEnd = obj1.episode > obj1.episodes
#%    obj1.env.reset();
#%#Have to split this so that matlab calls it in a loop. So must end run and store data across time steps.
'''
