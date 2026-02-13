FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Intel HD 530 drivers and dependencies
RUN apt-get update && apt-get install -y \
    intel-media-va-driver-non-free \
    i965-va-driver \
    vainfo \
    intel-opencl-icd \
    ocl-icd-opencl-dev \
    clinfo \
    wget \
    gpg-agent \
    && wget -qO - https://repositories.intel.com/graphics/intel-graphics.key | gpg --dearmor --output /usr/share/keyrings/intel-graphics.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/graphics/ubuntu jammy main" | tee /etc/apt/sources.list.d/intel-graphics.list \
    && apt-get update \
    && apt-get install -y intel-level-zero-gpu level-zero \
    && apt-get install -y \
        python3.10 \
        python3-pip \
        libopencv-dev \
        python3-opencv \
        libglib2.0-0 \
        libsm6 \
        libxext6 \
        libxrender-dev \
        libgomp1 \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir \
    opencv-python==4.8.1.78 \
    numpy==1.24.3 \
    paho-mqtt==1.6.1 \
    pillow==10.0.0 \
    pyyaml==6.0 \
    scikit-learn==1.3.0

WORKDIR /app

COPY analyzer/aquarium_analyzer.py /app/
COPY config/analyzer_config.yaml /app/config.yaml

ENV LIBVA_DRIVER_NAME=i965
ENV LIBVA_DRIVERS_PATH=/usr/lib/x86_64-linux-gnu/dri
ENV OCL_ICD_VENDORS=/etc/OpenCL/vendors

RUN echo '#!/bin/bash\n\
echo "========================================"\n\
echo "Aquarium AI Analyzer - HD 530"\n\
echo "========================================"\n\
vainfo 2>&1 | head -10\n\
echo ""\n\
clinfo -l 2>&1 | head -5\n\
echo ""\n\
echo "Starting analyzer..."\n\
python3 /app/aquarium_analyzer.py\n\
' > /app/entrypoint.sh && chmod +x /app/entrypoint.sh

CMD ["/app/entrypoint.sh"]
