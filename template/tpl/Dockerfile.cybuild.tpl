FROM python:3.7 as builder

WORKDIR /

COPY . /

RUN pip install cython==3.0.0a11 -i https://pypi.tuna.tsinghua.edu.cn/simple/ && \
    python /build/lib/cybuild.py /@SERVICE_NAME@ \
    --clean \
    --execution_file /@SERVICE_NAME@/main.py \
    --execution_file /@SERVICE_NAME@/app/config/cfg.py \
    --execution_file /@SERVICE_NAME@/app/config/log_cfg.py

FROM python:3.7-slim-buster

ARG DEBIAN_FRONTEND=noninteractive

COPY --from=builder /@SERVICE_NAME@ /@SERVICE_NAME@

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
