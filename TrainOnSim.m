pyenv("Version","C:\Users\bj20907\AppData\Local\Programs\Python\Python310\python.exe");
%insert(py.sys.path,int32(0),pwd)
if count(py.sys.path,'') == 0
    insert(py.sys.path,int32(0),'');
end
%py.sys.path
pyrun("from pythontest import *")
pyrun("obj1 = QLearning()")
episodeEnd = false;
%pyrun("episodeEnd = False")
%eE = pyrun("episodeEnd = False","episodeEnd")
pyrun("obs = obj1.env.reset()")
pyrun("obj1.prev_state = obj1.Discrete(obs[0])")
while(~ episodeEnd)
    exit_Loop = false;
    while(~ exit_Loop)
        if (rand(0,1) < 0.2)%(np.random.uniform(0,1) < obj1.epsilon) %epsilon
            action = pyrun("act = obj1.env.action_space.sample()","act"); %TODO what's this? - random action?
        else
            action = pyrun("act = np.argmax(obj1.q_table[obj1.prev_state])","act");
        end
%#        #Make the action decision
%#        if np.random.uniform(0,1) < obj1.epsilon:
%#            act = obj1.env.action_space.sample() #TODO what's this? - random action?
%#        else:
%#            act = np.argmax(obj1.q_table[obj1.prev_state])
%#
%#        #This is the action - this is where MATLAB sits - so the above action is passed in, and then the below is called.
        pyrun("res = obj1.env.step(act)", act = action);
        
        exit_Loop = pyrun("el = obj1.Q_LearningActionLoop(res[0], res[1], res[2], res[3])","el");
%#        #Above we actually return the action to take, and let matlab determine if we're done or not (res[3])
%#        #Matlab will actually do this loop, we're just contstructing the model in python and accessing it in matlab

    end    
    episodeEnd = pyrun("ee = obj1.episode > obj1.episodes","ee");
    pyrun("obj1.env.reset()");
    ab = pyrun("ss = obj1.episode","ss")
end