import numpy as np
from joblib import dump
# Trains a trivial linear model (no PHI, synthetic data)
X = np.arange(0, 100).reshape(-1, 1).astype(float)
y = X.ravel() * 0.5 + 3.0
# store coefficients
model = {"coef": 0.5, "intercept": 3.0}
dump(model, "model.joblib")
print("Model trained and saved to model.joblib")
