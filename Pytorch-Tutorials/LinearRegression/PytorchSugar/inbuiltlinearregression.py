# -*- coding: utf-8 -*-
"""InbuiltLinearRegression.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1Zz2GGzdoEODbZSSXSAdGJEoEMnbGwz3Y
"""

import numpy as np
import torch
import torch.nn as nn

# Training data
# [Temp, Rainfall, Humidity]
inputs = np.array([[73,67,43],[91,88,64],[87,134,58],[102,43,37],[69,96,70],
                   [73,67,43],[91,88,64],[87,134,58],[102,43,37],[69,96,70],
                   [73,67,43],[91,88,64],[87,134,58],[102,43,37],[69,96,70]],dtype='float32')
# [Apples, Oranges]
targets = np.array([[56,70],[81,101],[119,133],[22,37],[103,119],
                    [56,70],[81,101],[119,133],[22,37],[103,119],
                    [56,70],[81,101],[119,133],[22,37],[103,119]], dtype='float32')

inputs = torch.from_numpy(inputs)
targets = torch.from_numpy(targets)

# We have 15 training examples here
from torch.utils.data import TensorDataset
# We will create a TensorDataset which will allow access to rows from inputs and targets as tuples, 
# and provides standard APIs for working with different types of datasets in Pytorch.

train_ds = TensorDataset(inputs,targets)
train_ds[0:3]

# We will create a Dataloader, which can split data into batches of a predefined size while training. It also provides other features like shuffling and sampling of data.

from torch.utils.data import DataLoader

batch_size = 5
train_dl = DataLoader(train_ds,batch_size,shuffle = True)

i = 0
for xb,yb in train_dl:
  i += 1
  print("Batch",i)
  print(xb)
  print(yb)

# Define model
model = nn.Linear(3,2)
print(model.weight)
print(model.bias)

list(model.parameters())

preds = model(inputs)
print(preds)

import torch.nn.functional as F

loss_fn = F.mse_loss

# ?nn.Linear => Help function to see/ visualize the model and its parameters

loss = loss_fn(model(inputs),targets)
print(loss)

opt = torch.optim.SGD(model.parameters(), lr = 1e-5)

def fit(num_epochs, model, loss_fn, opt):
  # Repeat for couple number of epochs
  for epoch in range(num_epochs):
    for xb,yb in train_dl:
      # Generate a prediction
      preds = model(xb)
      # Calculate the loss value
      loss = loss_fn(preds,yb)
      # Compute gradients
      loss.backward()
      # Update parameters using gradients
      opt.step()
      # Reset the gradients to zero
      opt.zero_grad()
    # Print the progress
    if (epoch+1) % 10 == 0:
      print(' Epoch [{}/{}], Loss: {:.4f}'.format(epoch+1, num_epochs,loss.item()))

fit(100, model, loss_fn, opt)

list(model.parameters())