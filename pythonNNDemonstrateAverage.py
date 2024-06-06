import matplotlib.pyplot as plt

#Init network using NN file
from pythonNNContstructor import *
numStates=102
numActions=2
hiddenLayers=6
model = NNClass(numStates,numActions,hiddenLayers)
model.model.summary()

#Collect weights
allFirstWeights = [layer.get_weights()[0] for layer in model.model.layers]
flattenedWeights = [x for xs in allFirstWeights[0] for x in xs]
histBinsToUse = 20
#plt.hist(flattenedWeights,histBinsToUse)
averageWeights = [sum(weights)/len(weights) for weights in allFirstWeights[0]]
avgAverageWeights = sum(averageWeights)/len(averageWeights)
print("")
print("AverageWeightFirstLayer(102):")
print(avgAverageWeights)

print("")
print("LastLayerWeights:")
print(model.model.layers[1].get_weights()[0])
print("LastLayerBias:")
print(model.model.layers[1].get_weights()[1])
#print(avgAverageWeights)


#Do some predicting
numPredictions = 50
predictionResultsX = []
predictionResultsY = []
for inc in range(numPredictions):
    randomInput = [(random.random()*2)-1 for _ in range(numStates)]
    pred = model.model.predict([randomInput],verbose=0,batch_size=1)
    predictionResultsX.append(pred[0][0])
    predictionResultsY.append(pred[0][1])
   # print("")
   # print("PredicitonOnRandomData")
   # print(pred[0])


f, axarr = plt.subplots(2,1)

#Show histogram of weights and random plots
axarr[0].hist(flattenedWeights,histBinsToUse)
axarr[1].plot(predictionResultsX,predictionResultsY, marker='x',linestyle='None')
plt.show()
