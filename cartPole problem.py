import gym
import random
import numpy as np
import rl
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Flatten
from tensorflow.keras.optimizers import Adam
#from rl.agents import DQNAgent
#from rl.policy import BoltzmannQPolicy
#from rl.memory import SequentialMemory


env = gym.make('CartPole-v1')
states = env.observation_space.shape[0]
actions = env.action_space.n

#example of random actions
#episodes = 10
#for episode in range(1,episodes+1):
#    state= env.reset()
#    done = False
#    score = 0
#    while not done:
#        action = random.choice([0,1])
#        res = env.step(action)
#        n_state = res[0]
#        reward = res[1]
#        done = res[2]
#        info = res[3]
#        score+=reward
#    print('Ep:{} Sc:{}'.format(episode, score))


def build_model(states, actions):
    model = Sequential()
    model.add(Flatten(input_shape=(1,states)))
    model.add(Dense(24, activation='relu'))
    model.add(Dense(24, activation='relu'))
    model.add(Dense(actions, activation='linear'))
    return model

model = build_model(states,actions)
model.summary()

def build_agent(model,actions):
    policy = BoltzmannQPolicy()
    memory = SequentialMemory(limit=50000, window_length=1)
    dqn = DQNAgent(model=model, memory=memory, policy=policy, nb_actions=actions, nb_steps_warmup=10, target_model_update=1e-2)
    return dqn

dqn = build_agent(model, actions)
dqn.compile(Adam('learning-rate=1e-3'), metrics=['mae'])
print(dqn)
dqn.fit(env, nb_steps=50000)
#dqn.fit(env, nb_steps=50000, visualize=True, verbose=1)
