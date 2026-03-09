# Verify GPU visibility (Should show B100/B200/Blackwell)
nvidia-smi

# Check CUDA version (Expect 12.8+ or 13.0 for Spark)
nvcc --version

# Create working directory
mkdir -p ~/gpt/spark/comfy
cd ~/gpt/spark/comfy

# Install Python 3.11.9 if not present
pyenv install -s 3.11.9

# Create and activate virtualenv
pyenv virtualenv 3.11.9 spark-comfy
pyenv local spark-comfy

# Upgrade base tools
pip install -U pip setuptools wheel