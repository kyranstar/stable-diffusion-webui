
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
sudo mv civitai-downloader/download.sh /usr/local/bin/download-model
chmod +x /usr/local/bin/download-model

download-model https://civitai.com/api/download/models/76907 stable-diffusion-webui/models/Stable-diffusion/
download-model https://civitai.com/api/download/models/46137 stable-diffusion-webui/models/Stable-diffusion/

# Download all controlnet models
mkdir stable-diffusion-webui/extensions/controlnet/models
git lfs clone https://huggingface.co/lllyasviel/ControlNet-v1-1
mv ControlNet-v1-1/*.pth stable-diffusion-webui/extensions/controlnet/models/
rm -rf ControlNet-v1-1
git lfs clone https://huggingface.co/monster-labs/control_v1p_sd15_qrcode_monster
mv control_v1p_sd15_qrcode_monster/*.safetensors stable-diffusion-webui/extensions/controlnet/models/
rm -rf control_v1p_sd15_qrcode_monster
git lfs clone https://huggingface.co/Nacholmo/controlnet-qr-pattern-v2
mv controlnet-qr-pattern-v2/automatic1111/*.safetensors stable-diffusion-webui/extensions/controlnet/models/
rm -rf controlnet-qr-pattern-v2
bash <(curl -sSL https://g.bodaay.io/hfd) -m Nacholmo/controlnet-qr-pattern-v2:safetensors -s stable-diffusion-webui/extensions/controlnet/models

