# disable the restart dialogue and install several packages
sudo sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
sudo apt-get update
sudo apt install wget git python3 python3-venv build-essential net-tools awscli -y

# install CUDA (from https://developer.nvidia.com/cuda-downloads)
wget https://developer.download.nvidia.com/compute/cuda/12.0.0/local_installers/cuda_12.0.0_525.60.13_linux.run
#wget https://developer.download.nvidia.com/compute/cuda/12.2.2/local_installers/cuda_12.2.2_535.104.05_linux.run
sudo sh cuda_12.0.0_525.60.13_linux.run --silent

# tool to download models
sudo apt install -y aria2

sudo apt-get install libjpeg8-dev

# install perf tools
sudo apt install -y --no-install-recommends google-perftools

# install git-lfs
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get install git-lfs
sudo -u ubuntu git lfs install --skip-smudge

# install extensions
git clone https://github.com/zanllp/sd-webui-infinite-image-browsing stable-diffusion-webui/extensions/infinite-image-browser
git clone https://github.com/alemelis/sd-webui-ar stable-diffusion-webui/extensions/aspect-ratio
git clone https://github.com/ilian6806/stable-diffusion-webui-state stable-diffusion-webui/extensions/state
git clone https://github.com/DominikDoom/a1111-sd-webui-tagcomplete.git stable-diffusion-webui/extensions/tag-autocomplete
git clone https://github.com/richrobber2/canvas-zoom stable-diffusion-webui/extensions/canvas-zoom
git clone https://github.com/Coyote-A/ultimate-upscale-for-automatic1111 stable-diffusion-webui/extensions/ultimate-upscale
git clone https://github.com/Mikubill/sd-webui-controlnet stable-diffusion-webui/extensions/controlnet

# change ownership of the web UI so that a regular user can start the server
sudo chown -R ubuntu:ubuntu stable-diffusion-webui/
sudo chmod -R 777 stable-diffusion-webui/

sudo chmod 777 /etc/
mkdir /etc/nginx
touch /etc/nginx/nginx.conf
cat 'http { fastcgi_read_timeout 999999; proxy_read_timeout 999999; }' > /etc/nginx/nginx.conf
# touch server_started_marker.txt

# start the server as user 'ubuntu'
# sudo -u ubuntu nohup bash stable-diffusion-webui/webui.sh --share > log.txt