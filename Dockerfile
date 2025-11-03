# Base image
FROM python:3.10-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    libgl1 \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir \
    torch==2.0.1 \
    torchvision==0.15.2 \
    transformers==4.35.0 \
    timm==0.9.16 \
    numpy==1.24.3 \
    opencv-python==4.8.0.76 \
    decord==0.6.0 \
    av==12.0.0 \
    boto3==1.28.85 \
    kfp==2.9.0

# Pre-download the VIVIT model and processor
# Use VivitModel and VivitImageProcessor (not AutoModel/AutoProcessor)
RUN python -c "from transformers import VivitModel, VivitImageProcessor; \
    print('Downloading VIVIT model...'); \
    VivitModel.from_pretrained('google/vivit-b-16x2-kinetics400'); \
    VivitImageProcessor.from_pretrained('google/vivit-b-16x2-kinetics400'); \
    print('VIVIT model cached successfully!')"

# Set working directory
WORKDIR /app

# Default command (fix the JSON warning)
CMD ["python"]