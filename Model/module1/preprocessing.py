//mounting to drive
from google.colab import drive
drive.mount('/content/drive')
%cd drive/MyDrive/

//preprocessing
import glob
import random
import os
from torch.utils.data import Dataset
from skimage import io, color
from skimage.transform import rescale, resize, downscale_local_mean
import random
import numpy as np
import torch
import matplotlib.pyplot as plt

import imageio.v2 as imageio
class ImageDataset(Dataset):
    def __init__(self, root):

        #setting path to the shadowed and shadow free dataset
        self.files_A = sorted(glob.glob('GTAV/Train_temp/shadow_1' + '/*.*'))
        self.files_B = sorted(glob.glob('GTAV/Train_temp/shadow_0' + '/*.*'))

    def __getitem__(self, index):
        i = random.randint(0, 48)
        j = random.randint(0, 48)
        k=random.randint(0,100)

        #processing shadowed image
        item_A = color.rgb2lab(imageio.imread(self.files_A[index % len(self.files_A)])) #convert to lab image
        item_A=item_A[:,:,0] #selecting L channel
        item_A=resize(item_A,(448,448)) #resizing
        item_A=item_A[i:i+400,j:j+400]  #cropping
        if k>50:
            item_A=np.fliplr(item_A) #flipping randomly
        item_A=np.asarray(item_A)/50.0-1.0  #normalizing between -1 and 1 to make it 0 centered
        item_A=torch.from_numpy(item_A).float() #converting to tensor
        item_A=item_A.view(400,400,1) #reshaping
        item_A=item_A.transpose(0, 1).transpose(0, 2).contiguous() #switching values along axes

        #processing unshadowed image
        item_B = color.rgb2lab(imageio.imread(self.files_B[random.randint(0, len(self.files_B) - 1)]))
        item_B=item_B[:,:,0]
        item_B=resize(item_B,(448,448))
        item_B=item_B[i:i+400,j:j+400]
        if k>50:
            item_B=np.fliplr(item_B)
        item_B=np.asarray(item_B)/50.0-1.0
        item_B=torch.from_numpy(item_B).float()
        item_B=item_B.view(400,400,1)
        item_B=item_B.transpose(0, 1).transpose(0, 2).contiguous()
        return {'A': item_A, 'B': item_B}

    def __len__(self):
        return max(len(self.files_A), len(self.files_B))



