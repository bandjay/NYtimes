# -*- coding: utf-8 -*-
"""
Created on Sat Apr 01 02:54:17 2017

@author: jaycb
"""
import pandas as pd
import os
os.chdir("C:/Users/jaycb/Desktop/NYtimes")
df=pd.read_csv("full_data.csv",sep=",",index_col=False)
df=df['lead_paragraph']
df.to_csv("lead_para.txt",index_label=False,header=None,index=False)

