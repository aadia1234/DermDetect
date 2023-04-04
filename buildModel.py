from tensorflow.keras.layers import Input, Lambda, Dense, Flatten
from tensorflow.keras.models import Model
from tensorflow.keras.applications.resnet50 import ResNet50, preprocess_input
from tensorflow.keras.preprocessing import image
from tensorflow.keras.preprocessing.image import ImageDataGenerator, load_img
from tensorflow.keras.models import Sequential
from glob import glob
import coremltools as ct
import numpy as np
import matplotlib.pyplot as plt
import tensorflow as tf
from tensorflow.keras.callbacks import EarlyStopping



IMAGE_SIZE = [224, 224]

trainFolder = "data/train_2"
testFolder = "data/test_2"
classes = glob(trainFolder + "/*")
numOfClasses = len(classes)


myResNet = ResNet50(input_shape = IMAGE_SIZE+[3], pooling = "avg", weights = "imagenet", include_top=False)

# print(my_resnet.summary())

# for layer in myResNet.layers: 
    # layer.trainable = True

myResNet.layers[0].trainable = True


plusFlattenLayer = Flatten()(myResNet.output)
prediction = Dense(numOfClasses, activation="softmax")(plusFlattenLayer)
model = Model(inputs = myResNet.input, outputs = prediction)

model.compile(
    loss = "categorical_crossentropy",
    optimizer = "Adam",
    metrics = ["accuracy"]
)

# image augmentation -- later

trainDatagen = ImageDataGenerator(preprocessing_function=preprocess_input, rescale = 1. /255, shear_range = 0.2, zoom_range=0.2, horizontal_flip=True)
testDatagen = ImageDataGenerator(preprocessing_function=preprocess_input, rescale = 1. /255)
trainingSet = trainDatagen.flow_from_directory(trainFolder, batch_size=80, class_mode="categorical")
testSet = testDatagen.flow_from_directory(testFolder, batch_size=40, class_mode="categorical")


# fit model - train
checkpoint_path = "checkpoints_temp/cp-{epoch:04d}.ckpt"
checkpoint_callback = tf.keras.callbacks.ModelCheckpoint(
    filepath=checkpoint_path,
    save_best_only=True,
    verbose=1,
    period=5)

earlystop_callback = EarlyStopping(monitor='val_loss', verbose = 1, patience = 5)

result = model.fit(trainingSet, validation_data = testSet, epochs = 100, steps_per_epoch = 20, validation_steps = 10)

# plt.plot(result.history["accuracy"], label = "train_accuracy")
# plt.plot(result.history["val_accuracy"], label = "test_accuracy")
# plt.legend()
# plt.show() d


# plt.plot(result.history["loss"], label = "train_loss")
# plt.plot(result.history["val_loss"], label = "test_loss")
# plt.legend()
# plt.show()

model.save("model_v4.h5")

# MLModel = ct.convert(model)
# MLModel.save("model_v4.mlmodel")