
%% 函数实现
close all;clear all;clc;

in_image=imread('qingdao.jpg');
inv_m7 = invariable_moment(in_image)    %%Hu矩
%%
img=imread('qingdao.jpg');
img=rgb2gray(img);
[A_nm,zmlist,cidx,V_nm] = zernike(img);
A_nm    %%Zernike矩