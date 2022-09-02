#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd


# In[2]:


import numpy as np


# In[5]:


data = pd.read_csv("C:/Users/amans/Downloads/Wednesday-14-02-2018_TrafficForML_CICFlowMeter/Wednesday-14-02-2018_TrafficForML_CICFlowMeter.csv")


# In[6]:


data.head()


# In[7]:


data.shape


# In[8]:


data[data.columns].isnull().sum()


# In[9]:


n = data.nunique(axis=0) 


# In[10]:


n


# In[11]:


data.dtypes


# In[12]:


data.columns


# In[15]:


data.describe()


# In[20]:


data.groupby(['Label']).count()


# In[21]:


data['Label'].value_counts()


# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:




