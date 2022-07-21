from tensorflow import keras

# TODO
# Load in data
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
