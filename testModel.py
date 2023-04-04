import tensorflow as tf
from tensorflow.keras.models import Model
import cv2
from keras.preprocessing import image
from tensorflow.keras.utils import load_img, img_to_array
import numpy as np

IMAGE_SIZE = [224, 224]

categories = ["AtopicDermatitis", "Eczema", "Melanoma", "Psoriasis_LichenPlanus_RelatedDiseases", "WartsMolluscum_ViralInfections"]
model = tf.keras.models.load_model("model_v3.h5")
print(model.summary())

def prepareImage(path):
    image = load_img(path, target_size=(IMAGE_SIZE[0], IMAGE_SIZE[1]))
    imgResult = img_to_array(image)
    imgResult = np.expand_dims(imgResult, axis = 0) / 255.0
    return imgResult


testImage = "test.jpg"
imgForModel = prepareImage(testImage)
resultArray = model.predict(imgForModel, verbose = 1)
prediction = np.argmax(resultArray, axis = 1)

index = prediction[0]
accuracy = resultArray[0][index] * 100.0
print("Predicted skin condition: " + categories[index] + ", accuracy: " + str(accuracy) + "%")

# img = cv2.imread(testImage)
# cv2.putText(img, categories[index], (10, 100), cv2.FONT_HERSHEY_COMPLEX, 1.6, (255, 0, 0), 3, cv2.LINE_AA)
# cv2.imshow("image", img)
# cv2.waitKey(0)