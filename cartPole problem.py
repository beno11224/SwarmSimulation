import gym
import random
import numpy as np
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Flatten
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.losses import Huber
from tensorflow import keras
#from keras.models import Sequential
#from keras.layers import Dense, Flatten
#from keras.optimizers import Adam
#from keras.losses import Huber

#import rl
#from rl.agents import DQNAgent
#from rl.policy import BoltzmannQPolicy
#from rl.memory import SequentialMemory


seed = 42
gamma = 0.99  # Discount factor for past rewards
epsilon = 1.0  # Epsilon greedy parameter
epsilon_min = 0.1  # Minimum epsilon greedy parameter
epsilon_max = 1.0  # Maximum epsilon greedy parameter
epsilon_interval = (
    epsilon_max - epsilon_min
)  # Rate at which to reduce chance of random action being taken
batch_size = 9  # Size of batch taken from replay buffer
max_steps_per_episode = 10000

########-----Borrowed from:https://www.youtube.com/watch?v=cO5g5qLrLSo - Deep Reinforcement Learning Tutorial for Python in 20 Minutes -  Nicholas Renotte

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
    #model.add(Flatten(input_shape=(batch_size,states)))
    model.add(Dense(states, input_shape=(batch_size,states), activation='relu'))
    model.add(Dense(24, activation='relu'))
    model.add(Dense(24, activation='relu'))
    model.add(Dense(actions, activation='linear'))
    return model

model = build_model(states,actions)
model_target = build_model(states,actions)
model.summary()

#def build_agent(model,actions):
#    policy = BoltzmannQPolicy()
#    memory = SequentialMemory(limit=50000, window_length=1)
#    dqn = DQNAgent(model=model, memory=memory, policy=policy, nb_actions=actions, nb_steps_warmup=10, target_model_update=1e-2)
#    return dqn

#dqn = build_agent(model, actions)
#dqn.compile(Adam('learning-rate=1e-3'), metrics=['mae'])
#print(dqn)
#dqn.fit(env, nb_steps=50000)
#dqn.fit(env, nb_steps=50000, visualize=True, verbose=1)

########-----Borrowed from:https://keras.io/examples/rl/deep_q_network_breakout/########


#num_actions = actions

# In the Deepmind paper they use RMSProp however then Adam optimizer
# improves training time
optimizer = Adam(learning_rate=0.00025, clipnorm=1.0)

# Experience replay buffers
action_history = []
state_history = []
state_next_history = []
rewards_history = []
done_history = []
episode_reward_history = []
running_reward = 0
episode_count = 0
frame_count = 0
# Number of frames to take random action and observe output
epsilon_random_frames = 50000
# Number of frames for exploration
epsilon_greedy_frames = 1000000.0
# Maximum replay length
# Note: The Deepmind paper suggests 1000000 however this causes memory issues
max_memory_length = 100000
# Train the model after 4 actions
update_after_actions = 4
# How often to update the target network
update_target_network = 10000
# Using huber loss for stability
loss_function = Huber()

while True:  # Run until solved
    state = np.array(env.reset())
    episode_reward = 0

    for timestep in range(1, max_steps_per_episode):
        # env.render(); Adding this line would show the attempts
        # of the agent in a pop up window.
        frame_count += 1

        # Use epsilon-greedy for exploration
        if frame_count < epsilon_random_frames or epsilon > np.random.rand(1)[0]:
            # Take random action
            action = np.random.choice(actions)
        else:
            # Predict action Q-values
            # From environment state
            state_tensor = tf.convert_to_tensor(state)
            state_tensor = tf.expand_dims(state_tensor, 0)
            action_probs = model(state_tensor, training=False)
            # Take best action
            action = tf.argmax(action_probs[0]).numpy()

        # Decay probability of taking random action
        epsilon -= epsilon_interval / epsilon_greedy_frames
        epsilon = max(epsilon, epsilon_min)

        # Apply the sampled action in our environment
        #state_next, reward, done, _ = env.step(action)
        res = env.step(action)
        state_next = res[0]
        reward = res[1]
        done = res[2]
        state_next = np.array(state_next)

        episode_reward += reward

        # Save actions and states in replay buffer
        action_history.append(action)
        state_history.append(state)
        state_next_history.append(state_next)
        done_history.append(done)
        rewards_history.append(reward)
        state = state_next

        # Update every fourth frame and once batch size is over 32
        if frame_count % update_after_actions == 0 and len(done_history) > batch_size:

            # Get indices of samples for replay buffers
            indices = np.random.choice(range(len(done_history)), size=batch_size)

            # Using list comprehension to sample from replay buffer
            state_sample = np.array([state_history[i] for i in indices], dtype=np.float)
            state_next_sample = np.array([state_next_history[i] for i in indices])
            rewards_sample = [rewards_history[i] for i in indices]
            action_sample = [action_history[i] for i in indices]
            done_sample = tf.convert_to_tensor(
                [float(done_history[i]) for i in indices]
            )

            # Build the updated Q-values for the sampled future states
            # Use the target model for stability
            #print(state_next_sample[0].flatten())
            #print(state_next_sample[0])
            s_n_s = state_next_sample[np.newaxis, :, :] ##<<<<<<<<<<<<<<<<<<THIS WAS THE BIG ISSUE! Make sure dimensions line up
            #print(s_n_s)
            future_rewards = model_target.predict(s_n_s).squeeze()
            # Q value = reward + discount factor * expected future reward
            updated_q_values = rewards_sample + gamma * tf.reduce_max(future_rewards, axis=1)
            print(updated_q_values.shape)

            # If final frame set the last value to -1
            updated_q_values = updated_q_values * (1 - done_sample) - done_sample

            # Create a mask so we only calculate loss on the updated Q-values
            masks = tf.one_hot(action_sample, actions)

            with tf.GradientTape() as tape:
                # Train the model on the states and updated Q-values
                st_sam = state_sample[np.newaxis, :]
                #print(st_sam.shape)
                q_values = model(st_sam)
                #q_values = model(state_sample)

                # Apply the masks to the Q-values to get the Q-value for action taken
                q_action = tf.reduce_sum(tf.multiply(q_values, masks), axis=1)
                # Calculate loss between new Q-value and old Q-value
                print(updated_q_values.shape)
                print(q_action.shape)
                loss = loss_function(updated_q_values, q_action)

            # Backpropagation
            grads = tape.gradient(loss, model.trainable_variables)
            optimizer.apply_gradients(zip(grads, model.trainable_variables))

        if frame_count % update_target_network == 0:
            # update the the target network with new weights
            model_target.set_weights(model.get_weights())
            # Log details
            template = "running reward: {:.2f} at episode {}, frame count {}"
            print(template.format(running_reward, episode_count, frame_count))

        # Limit the state and reward history
        if len(rewards_history) > max_memory_length:
            del rewards_history[:1]
            del state_history[:1]
            del state_next_history[:1]
            del action_history[:1]
            del done_history[:1]

        if done:
            break

    # Update running reward to check condition for solving
    episode_reward_history.append(episode_reward)
    if len(episode_reward_history) > 100:
        del episode_reward_history[:1]
    running_reward = np.mean(episode_reward_history)

    episode_count += 1

    if running_reward > 40:  # Condition to consider the task solved
        print("Solved at episode {}!".format(episode_count))
        break
