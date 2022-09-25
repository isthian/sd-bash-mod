#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"
echo " "

echo "First run enter 'chmod +x scriptname.sh && bash scriptname.sh' "
echo "Run ArkiSDA-U.sh to pull latest AUTOMATIC1111 repo." 
echo "Run ArkiSDA-R.sh (default mode) or ArkiSD-RT.sh (Textual Inversion Mode) to launch SD-WebUI."
echo "Run ArkiSDA-RT.sh script after to launch SD with Textual Inversion embeddings."
echo " "
echo "paste direct download link to model.ckpt:"

read CHECKPOINT

echo "Updating Packages..."

#Package Updating
sudo apt-get update
sudo apt install python3-pip -y
sudo apt-get upgrade -y

# Anaconda Installation
PIP_EXISTS_ACTION=i
cd ~/tmp
wget https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh
bash Anaconda3-2022.05-Linux-x86_64.sh -b -u
cd ~/anaconda3
PIP_EXISTS_ACTION=w
pip install opencv-python
PIP_EXISTS_ACTION=i

source ~/anaconda3/bin/activate 
conda init bash
cd

echo " "
echo " "
echo " "
echo "Installing AUTOMATIC1111 SD-WebUI..."

# AUTOMATIC1111 Installation
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
cd /home/user/stable-diffusion-webui/
mkdir models
cd models
wget $CHECKPOINT 
cd ..

echo " Almost there ... "
echo " Don't hit Ctrl+C! "

conda env create -f environment-wsl2.yaml
conda activate automatic
mkdir embeddings
mkdir repositories
git clone https://github.com/CompVis/stable-diffusion.git repositories/stable-diffusion
git clone https://github.com/CompVis/taming-transformers.git repositories/taming-transformers
git clone https://github.com/sczhou/CodeFormer.git repositories/CodeFormer
git clone https://github.com/salesforce/BLIP.git repositories/BLIP
pip3 install transformers==4.19.2 diffusers invisible-watermark 
pip3 install git+https://github.com/crowsonkb/k-diffusion.git 
pip3 install git+https://github.com/TencentARC/GFPGAN.git 
pip3 install -r repositories/CodeFormer/requirements.txt 
pip3 install -r requirements.txt  

wget https://github.com/TencentARC/GFPGAN/releases/download/v1.3.0/GFPGANv1.3.pth
cd /home/user/stable-diffusion-webui/models/

cd /home/user/stable-diffusion-webui/

echo " "
echo "Installing Local Tunnel..."

# Local Tunnel Installation
sudo apt install npm -y
sudo apt install nodejs -y
sudo npm cache clean -f
sudo npm install -g n
sudo n stable
sudo npm install -g localtunnellt 00=
echo "Click link below to access SD-WebUI locally after setup finishes and displays localhost link."
lt --port 7860 &
 	
echo "Initializing AUTOMATIC1111's SD-WebUI..."
python3 webui.py 
