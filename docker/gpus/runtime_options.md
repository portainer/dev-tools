### NVIDIA_VISIBLE_DEVICES https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/user-guide.html#gpu-enumeration

docker run --rm --gpus all nvidia/cuda nvidia-smi
docker run --rm --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=all nvidia/cuda nvidia-smi

docker run --rm --gpus 2 nvidia/cuda nvidia-smi

docker run --gpus '"device=1,2"' nvidia/cuda nvidia-smi --query-gpu=uuid --format-csv
docker run --rm --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=1,2 nvidia/cuda nvidia-smi --query-gpu=uuid --format=csv


0,1,2, or GPU-fef8089b: a comma-separated list of GPU UUID(s) or index(es).
all: all GPUs will be accessible, this is the default value in base CUDA container images.
none: no GPU will be accessible, but driver capabilities will be enabled.
void or empty or unset: nvidia-container-runtime will have the same behavior as runc (i.e. neither GPUs nor capabilities are exposed)



### NVIDIA_DRIVER_CAPABILITIES https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/user-guide.html#driver-capabilities

docker run --rm --gpus 'all,"capabilities=compute,utility"' nvidia/cuda:11.0-base nvidia-smi
docker run --rm --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=all -e NVIDIA_DRIVER_CAPABILITIES=compute,utility nvidia/cuda nvidia-smi


compute: required for CUDA and OpenCL applications.
compat32: required for running 32-bit applications.
graphics: required for running OpenGL and Vulkan applications.
utility: required for using nvidia-smi and NVML.
video: required for using the Video Codec SDK.
display: required for leveraging X11 display.

compute,video or graphics,utility: a comma-separated list of driver features the container needs.
all: enable all available driver capabilities.
empty or unset: use default driver capability: utility




### constraints https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/user-guide.html#constraints

NOT SUPPORTED YET
https://github.com/moby/moby/blob/master/daemon/nvidia_linux.go#L70