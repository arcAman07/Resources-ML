# -*- coding: utf-8 -*-
"""Bias and limitations

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/github/huggingface/notebooks/blob/master/course/chapter1/section8.ipynb

# Bias and limitations

Install the Transformers and Datasets libraries to run this notebook.
"""

!pip install datasets transformers[sentencepiece]

from transformers import pipeline

unmasker = pipeline("fill-mask", model="bert-base-uncased")
result = unmasker("This man works as a [MASK].")
print([r["token_str"] for r in result])

result = unmasker("This woman works as a [MASK].")
print([r["token_str"] for r in result])