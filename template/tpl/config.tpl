# ===== 镜像构建配置 =====
# 镜像名
IMAGE_NAME=@SERVICE_NAME@
# 镜像 tag，默认值为 latest
IMAGE_TAG=
# 构建镜像时不使用缓存，可选项为 YES 和 NO，默认值为 NO
NO_CACHE=NO
# 始终尝试拉取最新镜像，可选项为 YES 和 NO，默认值为 NO
ALWAYS_PULL=NO
# 是否加密，可选项为 YES 和 NO，默认值为 NO
ENABLE_ENCRYPT=NO

# ===== 容器运行配置 =====
# 容器名
CONTAINER_NAME=@SERVICE_NAME@
# 映射端口，默认值为 8080
PORT=8080
# GPU 设备，指定 GPU 编号使用 "," 分割，不填默认不使用 GPU
GPUS=
# 日志挂载路径，绝对路径，不填默认不挂载
LOG_PATH=
# 临时文件挂载路径，绝对路径，不填默认不挂载
TMP_PATH=
# 是否清理临时文件，可选项为 YES 和 NO，默认值为 YES
IS_CLEANUP_TMP=YES
# uvicorn 的 worker 进程的数量，默认值为 1
WEB_CONCURRENCY=1
