#!/usr/bin/env python3
# Minimal TensorFlow example for cloud-based inference
import os, numpy as np, tensorflow as tf
from tensorflow import keras

def build_model():
    model = keras.Sequential([keras.layers.Dense(8, activation='relu', input_shape=(4,)),
                              keras.layers.Dense(1, activation='sigmoid')])
    model.compile(optimizer='adam', loss='binary_crossentropy')
    return model

if __name__ == "__main__":
    X = np.random.rand(64, 4).astype('float32')
    y = (X.sum(axis=1) > 2).astype('float32')
    model = build_model()
    model.fit(X, y, epochs=2, verbose=0)
    sample = np.random.rand(1,4).astype('float32')
    pred = model.predict(sample, verbose=0)
    print("Input:", sample.tolist(), "Prediction:", float(pred[0][0]))
