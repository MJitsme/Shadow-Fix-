import argparse
import sys
import os
from os.path import exists, join as join_paths

import torch
import numpy as np
from skimage import io, color
from skimage.transform import resize

#from model_module1 import Generator_S2F
os.environ["CUDA_VISIBLE_DEVICES"]="4,5,3,1,2,7,0,6"

from argparse import Namespace
args_dict = {
    'input_nc': 1,
    'output_nc': 1,
    'cuda': True,  # or False depending on your preference
    'generator_A2B': '/content/drive/MyDrive/model_istda_lgsn_module1/netG_A2B.pth'
}
opt = Namespace(**args_dict)




## ISTD
opt.dataroot_A = '/content/drive/MyDrive/GTAV/Test_temp/shadow_1'
opt.im_suf_A = '.jpg'

if torch.cuda.is_available():
    opt.cuda = True
    device = torch.device('cuda:0')


netG_A2B = Generator_S2F(opt.input_nc, opt.output_nc)

if opt.cuda:
    netG_A2B.to(device)

netG_A2B.load_state_dict(torch.load(opt.generator_A2B))
netG_A2B.eval()

if not os.path.exists('model_istda_lgsn_module1/B'):
    os.makedirs('model_istda_lgsn_module1/B')

gt_list = [os.path.splitext(f)[0] for f in os.listdir(opt.dataroot_A) if f.endswith(opt.im_suf_A)]

for idx, img_name in enumerate(gt_list):
    print('predicting: %d / %d' % (idx + 1, len(gt_list)))
    # Set model input
    labimage = color.rgb2lab(io.imread(os.path.join(opt.dataroot_A, img_name + opt.im_suf_A)))
    img=labimage[:,:,0]
    h=img.shape[0]
    w=img.shape[1]
    img=resize(img,[480,640])
    img=np.asarray(img)/50.0-1.0
    img=torch.from_numpy(img).float()
    img=img.view(480,640,1)
    img=img.transpose(0, 1).transpose(0, 2).contiguous()
    img_var=img.unsqueeze(0).to(device)

    # Generate output
    temp_B=netG_A2B(img_var)
    fake_B=50.0*(temp_B.data+1.0)
    fake_B=fake_B.data.squeeze(0).cpu()
    fake_B=fake_B.transpose(0, 2).transpose(0, 1).contiguous().numpy()
    fake_B=resize(fake_B,(h,w))
    for i in range(0,h):
        for j in range(0,w):
            labimage[i,j,0]=fake_B[i,j]
    outputimage=color.lab2rgb(labimage)

    save_result = join_paths('./model_istda_lgsn_module1/B/%s'% (img_name + opt.im_suf_A))
    io.imsave(save_result, (outputimage * 255).astype(np.uint8))
    print('Generated images %04d of %04d' % (idx+1, len(gt_list)))
