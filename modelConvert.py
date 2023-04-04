import coremltools as ct
import tensorflow as tf
from PIL import Image
from tensorflow.keras.utils import load_img, img_to_array
import numpy as np

path = "model_v4.h5"
classes = ["AtopicDermatitis", "Eczema", "Melanoma", "Psoriasis_LichenPlanus_RelatedDiseases", "WartsMolluscum_ViralInfections"]

keras_model = tf.keras.models.load_model(path)
input_img = ct.ImageType(name="input_1", shape = (1, 224, 224, 3), scale = 1/255.0, )
classifier_config = ct.ClassifierConfig(classes)

model = ct.convert(keras_model, inputs=[input_img], classifier_config = classifier_config,)
# example_img = Image.open("test.jpg").resize((224, 224))
# output = model.predict({"input_1": example_img})
# print(output["classLabels"])

model.save("model_v4.mlmodel")