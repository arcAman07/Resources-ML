# -*- coding: utf-8 -*-
"""Models (PyTorch)

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/github/huggingface/notebooks/blob/master/course/chapter2/section3_pt.ipynb

# Models (PyTorch)

Install the Transformers and Datasets libraries to run this notebook.
"""

!pip install datasets transformers[sentencepiece]

from transformers import BertConfig, BertModel

# Building the config
config = BertConfig()

# Building the model from the config
model = BertModel(config)

print(config)

from transformers import BertConfig, BertModel

config = BertConfig()
model = BertModel(config)

# Model is randomly initialized!

from transformers import BertModel

model = BertModel.from_pretrained("bert-base-cased")

model.save_pretrained("directory_on_my_computer")

sequences = ["Hello!", "Cool.", "Nice!"]

encoded_sequences = [
    [101, 7592, 999, 102],
    [101, 4658, 1012, 102],
    [101, 3835, 999, 102],
]

import torch

model_inputs = torch.tensor(encoded_sequences)

output = model(model_inputs)