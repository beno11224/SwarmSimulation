from tensorflow import keras
import tkinter as tk
import tkinter.filedialog as fd
import csv
import os

# Load in data
root = tk.Tk()
root.withdraw()
filez = fd.askopenfilenames(parent=root, title='Choose all data files')

datax = []
datay = []
goalLocations = [[]]
goalLocations.append([1,2])
goalLocations.append([-1,2])
goalLocations.append([1,-2])
goalLocations.append([-1,-2])# TODO set the 4 end states here.
for fileName in filez:
    with open(fileName) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        lineCount = 0
        for row in csv_reader:
            
            #Make data easier to use
            time = row[0]
            magForce = row[1]
            goalPercentage = row[2]
            velocities = row[3]
            positions = row[4]
            testNumber = (os.path.basename(fileName))[4:6]
            testNumber = ''.join(filter(str.isdigit, testNumber))
            testNumber = (int(testNumber) % 2) *-1 + 2 #set which test we're running. use offset to set between various outputs.
            goalLocation = goalLocations[int(testNumber)]
            #Raw data is in, clean individual records here, or do them all together outside this loop.
            #Remember good practice
                #- all values should be the same scale (-1 > 0 > -1 is a good start)
                #inputs should be of same magnitude - goal location should take similar number of inputs to particle location.
                # think about what data is useable - throw data until user input detected? ignore once no more particles reach the goal?
            splitPositions = []
            splitMagForce = []
            positions = positions.strip('[')
            positions = positions.strip(']')
            positions = positions.split(';')
            for positionTuple in positions:
                a = positionTuple.split(' ')
                splitPositions.append(float(a[0]))
                splitPositions.append(float(a[1]))
               
            datax.append(splitPositions)

            
            #only add the magforce for the next line
            if lineCount == 0:
                lineCount += 1
                continue
            
            magForce = magForce.strip('[')
            magForce = magForce.strip(']')
            magForceboth = magForce.split(' ')
           # datay.append(magForceboth)
            #print(type(datay[0][0]))
            splitMagForce.append(float(magForceboth[0]))
            splitMagForce.append(float(magForceboth[1]))
            datay.append(splitMagForce)
           # datay.append(float(magForceboth[1]))
          #  print(magForce)
                  
            lineCount += 1
         #   print(lineCount)

        if lineCount == 0:
            print("No lines in file: " + fileName)
        datax.pop(-1);

#TODO sort out reading the polygons in.
#polyLine = plot(ax1,polygon.currentPoly(:,1),polygon.currentPoly(:,2), 'Color','b');
#endLine = plot(ax1,polygon.currentEndZone(1,:,1),polygon.currentEndZone(1,:,2), 'Color','g');

#tidiedPositions = [];
#times = [];
#while ischar(tline)
#    %TODO port this into Python - this is the reading bit
#    datas = split(tline,',');
#    time = datas(1);
#    magForce = datas(2);
#    goalPercentage = datas(3);
#    velocities = datas(4);
#    positions = datas(5);
#end

            
#datax = [[0.1],[0.8],[0.4]]
#datay = [[0.9],[0.1],[0.7]]

# TODO
# do keras training stuff
print("Starting Training")
#print(datax[0])
#print(datay[0])
#print(datax[2])
#print(len(datax))
#print(len(datax[0]))
model = keras.models.Sequential()
model.add(keras.layers.Dense(len(datax[0]), input_shape=(len(datax[0]),),activation='relu'))
model.add(keras.layers.Dense(len(datay[0]), activation='sigmoid'))
#model.add(keras.layers.Dense(12, input_shape=(1,),activation='relu'))
#model.add(keras.layers.Dense(1, activation='sigmoid'))
model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
print(model.summary())
print("Fitting:")
model.fit(datax, datay, epochs=15, batch_size=1, verbose=1)
print("Fitted!")

a = model.predict(datax[:2])
print(a)
# TODO
# Save model



# This will be a separate file at some point

# TOOD
# Load the file

# TODO
# run the keras model on matlab input

#TODO return the output to matlab
