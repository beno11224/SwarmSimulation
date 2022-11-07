import gym
import numpy as np
import time

class QLearning:
    def __init__(self, epsilon= 0.2, lr = 0.15, gamma = 0.995, episodes = 5*10**3, timestep = 1000):
        self.epsilon = epsilon
        self.lr = lr
        self.gamma = gamma
        self.episodes = episodes
        self.timestep = timestep
        
        self.env = gym.make('CartPole-v0') # - use my sim

        self.episode = 0
        self.steps = 0
        self.rewards = 0
        self.solved = False 
        self.runs = [0]
        self.data = {'max' : [0], 'avg' : [0]}
        self.bin_size = 30
        self.score = 0
        self.bins = [np.linspace(-4.8,4.8,self.bin_size),
                np.linspace(-4,4,self.bin_size),
                np.linspace(-0.418,0.418,self.bin_size),
                np.linspace(-4,4,self.bin_size)]        
        self.q_table = np.random.uniform(low=-1,high=1,size=([self.bin_size] * 4 + [2]))
        self.prev_state = 0;
        self.prev_action = 0;
        #self.q_table, self.bins = self.Qtable(len(self.env.observation_space.low), self.env.action_space.n) #number observation space vars, num action vars. - obs is continuous, action is discrete


  #  def Qtable(self, state_space,action_space,bin_size = 30):    
  #      self.bins = [np.linspace(-4.8,4.8,bin_size),
  #              np.linspace(-4,4,bin_size),
  #              np.linspace(-0.418,0.418,bin_size),
  #              np.linspace(-4,4,bin_size)]
  #  
  #      self.q_table = np.random.uniform(low=-1,high=1,size=([bin_size] * state_space + [action_space]))
  #      return self.q_table, self.bins

    def Discrete(self, state, bins):
        index = []
        for i in range(len(state)):
            index.append(np.digitize(state[i],bins[i]) - 1)
        return tuple(index)
                
    def Q_LearningActionLoop(self, observation, reward, done, info):
        
        next_state = self.Discrete(observation, self.bins)
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
                self.prev_action = self.env.action_space.sample() #TODO what's this? - random action?
            else:
                self.prev_action = np.argmax(self.q_table[self.prev_state])
            return False


# TRANING
#q_table, bins = Qtable(len(env.observation_space.low), env.action_space.n)#
obj1 = QLearning()
episodeEnd = False
obs = obj1.env.reset()
obj1.prev_state = obj1.Discrete(obs[0], obj1.bins)
while(not episodeEnd):
    exit_Loop = False
    while(not exit_Loop):
        #Make the action decision
        if np.random.uniform(0,1) < obj1.epsilon:
            act = obj1.env.action_space.sample() #TODO what's this? - random action?
        else:
            act = np.argmax(obj1.q_table[obj1.prev_state])

        #This is the action - this is where MATLAB sits - so the above action is passed in, and then the below is called.
        res = obj1.env.step(act);
        
        exit_Loop = obj1.Q_LearningActionLoop(res[0], res[1], res[2], res[3])
    episodeEnd = obj1.episode > obj1.episodes
    #print(episodeEnd)
    obj1.env.reset();
#Have to split this so that matlab calls it in a loop. So must end run and store data across time steps.
