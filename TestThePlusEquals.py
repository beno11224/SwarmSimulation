import numpy as np
from cvxopt import matrix 
from cvxopt import solvers
featureExpectations = np.zeros(2)

'''for car_distance in range(200):
    readings = np.ones(2)
    featureExpectations += (0.9**(car_distance-101))*np.array(readings)
    print(car_distance)
    print(featureExpectations)
''' 
P = matrix(2.0*np.eye(2), tc='d') # min ||w||
q = matrix(np.zeros(2), tc='d')
G = matrix([[-5.62e-01,5.55e-01,4.57e-0,4.57e-01],[-3.91e+00,3.40e-01,8.88e+00,8.88e+00]])
    #np.array([-5.62e-01,-3.91e+00],[5.55e-01,3.40e-01],[4.57e-0,8.88e+00],[4.57e-01,8.88e+00])
h = matrix(-np.array(np.ones(4)))
print(P)
print(q)
print(G)
print(h)

solvers.options['feastol'] = 1e-2
solvers.options['maxiters'] = 20;

try:
    sol = solvers.qp(P,q,G,h)
except:
    print("ohDear")
print(np.squeeze(np.asarray(sol['x'])))
