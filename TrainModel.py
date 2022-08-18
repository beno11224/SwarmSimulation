from tensorflow import keras
import tkinter as tk
import tkinter.filedialog as fd
import csv

# Load in data
root = tk.Tk()
root.withdraw()
filez = fd.askopenfilenames(parent=root, title='Choose all data files')
    #print(filez)
for fileName in filez:
    with open(fileName) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        lineCount = 0
        for row in csv_reader:
            print(row[4])
            lineCount += 1
            #No, it's been read in cos python is better than matlab
            #Now we read stuff
            #datas = row.split(",");
            #time = datas[1];
            #magForce = datas[2];
            #goalPercentage = datas[3];
            #velocities = datas[4];
            #positions = datas[5];
            
        if lineCount == 0:
            print("No lines in file: " + fileName)

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

            
datax = [[0.1],[0.8],[0.4]]
datay = [[0.9],[0.1],[0.7]]

# TODO
# do keras training stuff
model = keras.models.Sequential()
model.add(keras.layers.Dense(12, input_shape=(1,),activation='relu'))
model.add(keras.layers.Dense(1, activation='sigmoid'))
model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
model.fit(datax, datay, epochs=15, batch_size=2, verbose=0)

a = model.predict([0.8])
print(a)
# TODO
# Save model



# This will be a separate file at some point

# TOOD
# Load the file

# TODO
# run the keras model on matlab input

#TODO return the output to matlab
