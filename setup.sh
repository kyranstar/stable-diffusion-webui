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


# download the SD model v2.1 and move it to the SD model directory
sudo -u ubuntu git clone --depth 1 https://huggingface.co/stabilityai/stable-diffusion-2-1-base
cd stable-diffusion-2-1-base/
sudo -u ubuntu git lfs pull --include "v2-1_512-ema-pruned.ckpt"
sudo -u ubuntu git lfs install --force
cd ..
mv stable-diffusion-2-1-base/v2-1_512-ema-pruned.ckpt stable-diffusion-webui/models/Stable-diffusion/
rm -rf stable-diffusion-2-1-base/

# download the corresponding config file and move it also to the model directory (make sure the name matches the model name)
wget https://raw.githubusercontent.com/Stability-AI/stablediffusion/main/configs/stable-diffusion/v2-inference.yaml
cp v2-inference.yaml stable-diffusion-webui/models/Stable-diffusion/v2-1_512-ema-pruned.yaml

## Download additional models
git clone https://github.com/ashleykleynhans/civitai-downloader.git
mv civitai-downloader/download.sh /usr/local/bin/download-model
chmod +x /usr/local/bin/download-model

download-model https://civitai.com/api/download/models/76907 stable-diffusion-webui/models/Stable-diffusion/
download-model https://civitai.com/api/download/models/46137 stable-diffusion-webui/models/Stable-diffusion/

# Download all controlnet models
# can use this script: https://github.com/bodaay/HuggingFaceModelDownloader
mkdir stable-diffusion-webui/extensions/controlnet/models
bash <(curl -sSL https://g.bodaay.io/hfd) -m lllyasviel/ControlNet-v1-1:pth -s stable-diffusion-webui/extensions/controlnet/models
bash <(curl -sSL https://g.bodaay.io/hfd) -m monster-labs/control_v1p_sd15_qrcode_monster:safetensors -s stable-diffusion-webui/extensions/controlnet/models
bash <(curl -sSL https://g.bodaay.io/hfd) -m Nacholmo/controlnet-qr-pattern-v2:safetensors -s stable-diffusion-webui/extensions/controlnet/models

# change ownership of the web UI so that a regular user can start the server
sudo chown -R ubuntu:ubuntu stable-diffusion-webui/
sudo chmod -R 777 stable-diffusion-webui/

# touch server_started_marker.txt

# start the server as user 'ubuntu'
# sudo -u ubuntu nohup bash stable-diffusion-webui/webui.sh --share > log.txt