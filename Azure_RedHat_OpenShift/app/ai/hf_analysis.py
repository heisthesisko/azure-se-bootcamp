#!/usr/bin/env python3
# Minimal Hugging Face Transformers example (CPU)
from transformers import pipeline
if __name__ == "__main__":
    nlp = pipeline("sentiment-analysis")  # downloads model on first run
    result = nlp("The hospital experience was efficient and caring.")
    print(result)
