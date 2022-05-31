# -*- coding: utf-8 -*-
"""GPU-Pytorch.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1sMmCECSMWdMUfmTfpPsrUrN-2rfVkP98
"""

import torch

torch.cuda.is_available()

def get_default_device():
  # Pick GPU if available otherwise CPU
  if torch.cuda.is_available():
    return torch.device('cuda')
  else:
    torch.device('cpu')

device = get_default_device()
print(device)

# Now let's define a function that can move data and model to a chosen device

def to_device(data, device):
  # Move tensors to chosen device
  if isinstance(data, list(tuple)):
    return [to_device(x, device) for x in data]
  return data.to(device, non_blocking = True)

class DeviceDataLoader():
  # Wrap a dataloader to move data to a device
  def __init__(self,dl,device):
    self.dl = dl
    self.device = device
  def __iter__(self):
    # Yield a batch of data after moving it to device
    for b in self.dl:
      yield to_device(b, self.device)
  def __len__(self):
    # Number of batches
    return len(self.dl)