# alpine 无法安装 OpenCV: https://github.com/opencv/opencv-python/issues/268
# 选择使用 Debian:slim-buster 镜像
FROM python:3.7-slim-buster

ARG DEBIAN_FRONTEND=noninteractive

COPY @SERVICE_NAME@ /@SERVICE_NAME@

WORKDIR /@SERVICE_NAME@

RUN apt update && \
    # 设置时区
    apt install -y tzdata && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    # 安装 Python 包
    pip install -r requirements.txt && \
    # 清理镜像
    find /@SERVICE_NAME@ -name __pycache__ -type d | xargs rm -rf && \
    rm -rf ~/.cache/pip && \
    apt autoremove -y && \
    apt clean

EXPOSE 8080

CMD ["/bin/bash", "run.sh"]
