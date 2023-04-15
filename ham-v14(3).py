import random
import numpy as np
import tensorflow as tf
from PIL import Image
from tensorflow.keras import Sequential
from tensorflow.keras.layers import Dense
from tensorflow.keras.applications import ResNet50
from tensorflow.keras.applications.resnet50 import preprocess_input
from tensorflow.keras.preprocessing import image
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.callbacks import EarlyStopping
from keras.optimizers import SGD
from keras.callbacks import LearningRateScheduler

seed = 0
random.seed(seed)
np.random.seed(seed)
tf.random.set_seed(seed)
image_size = (224, 224)
class_labels = {
    "bkl": 0,
    "mel": 1,
    "nv": 2
}

datagen_withaug = ImageDataGenerator(
    rotation_range=10,
    width_shift_range=0.1,
    height_shift_range=0.1,
    shear_range=0.1,
    zoom_range=0.1,
    horizontal_flip=True,
    fill_mode='nearest',
    preprocessing_function=preprocess_input)

datagen_withoutaug = ImageDataGenerator(
    preprocessing_function=preprocess_input
)

train_generator = datagen_withaug.flow_from_directory(
        '/Users/derke/Documents/GitHub/machine-learning-for-sustainable-development-Orangesaresour/ham_polished/train',
        target_size=image_size,
        batch_size=32,
        class_mode='categorical',
        classes=list(class_labels.keys()))

validation_generator = datagen_withoutaug.flow_from_directory(
        '/Users/derke/Documents/GitHub/machine-learning-for-sustainable-development-Orangesaresour/ham_polished/val',
        target_size=image_size,
        class_mode='categorical',
        classes=list(class_labels.keys()))

num_classes = 3
# resnet_weights_path = '/Users/derke/Desktop/DermTest/resnet101/resnet101_weights_tf_dim_ordering_tf_kernels.h5'
checkpoint_path = "checkpoints_temp/cp-{epoch:04d}.ckpt"
checkpoint_callback = tf.keras.callbacks.ModelCheckpoint(
    filepath=checkpoint_path,
    save_best_only=True,
    verbose=1,
    period=5)  

model = Sequential()
model.add(ResNet50(include_top=False, pooling='avg', weights='imagenet')) #try f
model.add(Dense(num_classes, activation='softmax'))

model.layers[0].trainable = True
model.summary()
model.compile(optimizer='sgd', loss='categorical_crossentropy', metrics=['accuracy'])
earlystop_callback = EarlyStopping(monitor='val_loss', verbose = 2, patience=10)


model.fit(
        train_generator,
        epochs=100,
        validation_data=validation_generator,
        callbacks=[earlystop_callback]
        )

model.save('HAM10000(3)-modelv14-100epoch-softmax-imgnet-trainableTrue-topless-avgpooling.h5')