import os

import urllib.request
os.environ['TF_CPP_MIN_LOG_LEVEL'] = "3"
os.environ["CUDA_VISIBLE_DEVICES"] = "0"

import argparse
import tensorflow as tf
from PIL import Image
import cv2
import numpy as np

from model.utils import open_json
from model.model import PetModel

class Inference:
    def __init__(self, args):
        self.input_shape = (args['input_size'], args['input_size'], 3)
        self.classes = args['classes']
        self.label_map = open_json(args['label'])
        self.model = PetModel(self.input_shape, self.classes).get_model(weights="imagenet", trainable_base=True)
        self.model.load_weights(args['weight_path'])
    
    def _get_normal_image(self, url):
        resp = urllib.request.urlopen(url)
        image_nparray = np.asarray(bytearray(resp.read()), dtype=np.uint8)
        image = cv2.imdecode(image_nparray, cv2.IMREAD_COLOR)
        return image
    
    def preprocess(self, input_data):
        if isinstance(input_data, str):
            # str, image_path
            if "http" in input_data:
                input_data = self._get_normal_image(input_data)
            else:
                # input_data = cv2.imread(input_data)
                input_data = tf.io.read_file(input_data)
                input_data = tf.io.decode_jpeg(input_data)
 
            
        elif isinstance(input_data, Image.Image):
            # pillow Image objects
            input_data = tf.keras.preprocessing.image.img_to_array(input_data)
        
        # np.ndarray
        input_data = tf.image.resize(input_data, self.input_shape[:2])
        input_data = tf.expand_dims(input_data, axis=0)
            
        return input_data
    
    def inference(self, input_data):
        input_data = self.preprocess(input_data)
        
        output = tf.squeeze(self.model.predict(input_data))
        reversed_map = {value:key for key,value in self.label_map.items()}
        emotion = reversed_map[tf.squeeze(tf.where(output==1)).numpy()]
        
        result_dict = {
            'output' : output.numpy(),
            'emotion' : emotion
        }
        return result_dict

if __name__ == "__main__" :
    parser = argparse.ArgumentParser()
    parser.add_argument('--weight_path', type=str, default='./3-1.56-0.50.h5')
    parser.add_argument('--input_size', type=int, default=224)
    parser.add_argument('--classes', type=int, default=6)
    parser.add_argument('--label', type=str, default='./label.json')
    # parser.add_argument('--input_data', type=str, default='./res/pic8.jpg')
    parser.add_argument('--input_data', type=str, default='https://images.theconversation.com/files/443350/original/file-20220131-15-1ndq1m6.jpg')
    args = parser.parse_args()
    
    inf = Inference(args)
    result_dict = inf.inference(args.input_data)
    
    print('result:')
    print(result_dict)