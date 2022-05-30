# -*- coding: utf-8 -*-
"""ImageClassifier-MNIST.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1lyKbvm3nZj1yGtaXOn4o4pBiNuUbOSgv
"""

import torch
import numpy
import torch.nn as nn
import torchvision
from torchvision.datasets import MNIST

# Download training dataset
dataset = MNIST(root='data/', download = True)

len(dataset)

test_dataset = MNIST(root='data/', train = False)
len(test_dataset)

dataset[0]

import matplotlib.pyplot as plt

image, label = dataset[0]
plt.imshow(image, cmap='gray')
print('Label:',label)

image, label = dataset[10]
plt.imshow(image, cmap='gray')
print('Label:',label)

image, label = dataset[1000]
plt.imshow(image, cmap='gray')
print('Label:',label)

import torchvision.transforms as transforms

dataset = MNIST(root='data/', train = True, transform = transforms.ToTensor())

img_tensor, label = dataset[0]

print(img_tensor.shape, label)

print(img_tensor[:,10:15,10:15])
print(torch.max(img_tensor), torch.min(img_tensor))

plt.imshow(img_tensor[0,10:15,10:15], cmap='gray')

n = 60000
val_pct = 0.2
import numpy as np
def split_indices(n, val_pct):
  # Determine the size of validation set
  n_val = int(n*val_pct)
  # Create the random permutation of 0 to n-1
  idxs = np.random.permutation(n)
  # Pick first n_val indices for validation set
  return idxs[n_val:], idxs[:n_val]

train_indices, val_indices = split_indices(len(dataset), val_pct=0.2)

print(len(train_indices), len(val_indices))
print('Sample val indices: ',val_indices[:20])

from torch.utils.data.sampler import SubsetRandomSampler
from torch.utils.data.dataloader import DataLoader

batch_size = 100

# Training sampler and data loader
train_sampler = SubsetRandomSampler(train_indices)
train_loader = DataLoader(dataset, batch_size, sampler = train_sampler)

val_sampler = SubsetRandomSampler(val_indices)
val_loader = DataLoader(dataset, batch_size, sampler = val_sampler)

input_size = 28*28
num_classes = 10

model = nn.Linear(input_size,num_classes)

print(model.weight.shape)
print(model.bias.shape)

list(model.parameters())

for images, labels in train_loader:
  print(labels)
  print(images.shape)
  break

class MnistModel(nn.Module):
  def __init__(self):
    super().__init__()
    self.linear = nn.Linear(input_size, num_classes)
  def forward(self,xb):
    xb = xb.reshape(-1,784)
    out = self.linear(xb)
    return out

model = MnistModel()

list(model.parameters())

print(model.linear.weight.shape)
print(model.linear.bias.shape)

for images, labels in train_loader:
  print(labels)
  print(images.shape)
  outputs = model(images)
  break

print(outputs.shape)

import torch.nn.functional as F

probs = F.softmax(outputs, dim=1)
# Look at sample probabilities
print('Sample probabilities: \n', probs[:2].data)
# Add up the sample probabilties of an output row
print('Sum: ',torch.sum(probs[0]).item())

max_probs, preds = torch.max(probs, dim=1)
print(max_probs)
print(preds)

labels

def accuracy(l1,l2):
  return torch.sum(l1 == l2).item()/ len(l1)

accuracy(preds,labels)

loss_fn = F.cross_entropy

# Loss for current batch of data
loss = loss_fn(outputs, labels)

loss

learning_rate = 0.001
optimizer = torch.optim.SGD(model.parameters(), lr=learning_rate)

def loss_batch(model, loss_func, xb, yb, opt = None, metric = None):
  # Calculate loss
  preds = model(xb)
  loss = loss_func(preds, yb)
  if opt is not None:
    # Compute gradients
    loss.backward()
    # Updating the gradients
    opt.step()
    # Reset the gradients
    opt.zero_grad()
  metric_result = None
  if metric is not None:
    # Compute metric
    metric_result = metric(preds, yb)
  return loss.item(), len(xb), metric_result

def evaluate(model, loss_func, valid_dl, metric = None):
  with torch.no_grad():
    # Pass each batch through the model
    results = [loss_batch(model, loss_func,xb, yb, metric = metric)
    for xb,yb in valid_dl]
    # Seperate losses, counts and metrics
    losses, nums, metrics = zip(*results)
    # Total size of the dataset
    total = np.sum(nums)
    # Avg loss across batches
    avg_loss = np.sum(np.multiply(losses, nums))/ total
    avg_metric  = None
    if metric is not None:
      # Avg of metric across batches
      avg_metric = np.sum(np.multiply(metrics, nums)) / total
  return avg_loss, total, avg_metric

def accuracy(outputs, labels):
  _, preds = torch.max(outputs, dim=1)
  return torch.sum(preds == labels).item() / len(preds)

val_loss, total, val_acc = evaluate(model, loss_fn, val_loader, metric = accuracy)
print('Loss: {:.4f}, Accuracy: {:.4f}'.format(val_loss, val_acc))

def fit(epochs, model, loss_fn, opt, train_dl, valid_dl, metric = None):
  for epoch in range(epochs):
    # Training
    for xb,yb in train_dl:
      loss,_,_ = loss_batch(model, loss_fn, xb, yb, opt)

    # Evaluation
    result = evaluate(model, loss_fn, valid_dl,metric)
    val_loss, total, val_metric = result

    # Print progress
    if metric is None:
      print('Epoch [{}/{}], Loss: {:.4f}'.format(epoch+1, epochs, val_loss))
    else:
      print('Epoch [{}/{}], Loss: {:.4f}, {}: {:.4f}'.format(epoch+1, epochs, val_loss, metric.__name__,val_metric))

# Redefine model and optimizer
model = MnistModel()
optimizer = torch.optim.SGD(model.parameters(), lr=learning_rate)

fit(5,model, F.cross_entropy, optimizer, train_loader, val_loader, accuracy)

fit(5,model, F.cross_entropy, optimizer, train_loader, val_loader, accuracy)

fit(5,model, F.cross_entropy, optimizer, train_loader, val_loader, accuracy)

fit(5,model, F.cross_entropy, optimizer, train_loader, val_loader, accuracy)

fit(5,model, F.cross_entropy, optimizer, train_loader, val_loader, accuracy)

# Testing with individual images

test_dataset = MNIST(root='data/', train = False, transform = transforms.ToTensor())

img, label = test_dataset[0]
plt.imshow(img[0], cmap= 'gray')
print('Shape:', img.shape)
print('Label:',label)

def predict_image(img, model):
  xb = img.unsqueeze(0)
  yb = model(xb)
  _, preds = torch.max(yb, dim=1)
  return preds[0].item()

predict_image(img,model)

