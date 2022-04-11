# fastapi_build_template

- [fastapi_build_template](#fastapi_build_template)
  - [配置文件](#配置文件)
  - [生成模板](#生成模板)
  - [模板目录结构](#模板目录结构)
  - [模板项目相关命令](#模板项目相关命令)
    - [make init](#make-init)
    - [make clean](#make-clean)
    - [make lint](#make-lint)
    - [make format](#make-format)
    - [make build](#make-build)
    - [make run](#make-run)
    - [make build-docker](#make-build-docker)
    - [make run-docker](#make-run-docker)
    - [make help](#make-help)
  - [模板项目其他功能](#模板项目其他功能)
    - [图片去重](#图片去重)
    - [Cython 加密](#cython-加密)
    - [Locust 性能测试](#locust-性能测试)

该项目为 fastapi 服务构建模板，以 ai-service 为例。

## 配置文件

配置文件路径为 `fastapi_build_template/config`，以 *key=value* 形式提供如下配置：

| 配置名       | 说明     | 备注                                                                               |
| :----------- | :------- | :--------------------------------------------------------------------------------- |
| SERVICE_NAME | 服务名   |
| VERSION      | 版本号   |
| MAINTAINER   | 维护者   | 使用 "," 分割，与邮箱相互对应                                                      |
| EMAIL        | 邮箱     | 使用 "," 分割，与维护者相互对应                                                    |
| OUTPUT_DIR   | 输出路径 | 绝对路径和相对路径均可，默认值为当前目录下的 output 文件夹，若路径不存在会自动创建 |

## 生成模板

在项目目录下运行如下命令，一键生成模板：

```bash
$ make build

[2021-12-31 11:45:42] start to check ...

[2021-12-31 11:45:42] check finish !

[2021-12-31 11:45:42] start to cleanup ...

[2021-12-31 11:45:42] cleanup finish !

[2021-12-31 11:45:42] start to build ...
info: init service ...
info: generate service config ...
info: generate build config ...
info: cleanup template file ...

[2021-12-31 11:45:42] build finish !
```

> **注：** 其他命令可使用 `make help` 查看帮助

## 模板目录结构

生成的文件及其作用如下所示：

```txt
$ tree -a -L 3 output/
output/
├── .dockerignore
├── .flake8
├── .gitattributes
├── .gitignore
├── Makefile
├── README.md
├── ai-service ======================= 服务目录
│   ├── app ========================== 项目代码目录
│   │   ├── __init__.py
│   │   ├── application.py ----------- fastapi 应用文件
│   │   ├── config =================== 项目配置目录
│   │   ├── event ==================== 项目事件目录
│   │   ├── exception ================ 项目异常目录
│   │   ├── middleware =============== 项目中间件目录
│   │   ├── model ==================== 项目数据库 ORM 目录
│   │   ├── router =================== 项目路由目录
│   │   ├── schema =================== 项目 schema 目录
│   │   ├── service ================== 项目服务目录（业务逻辑实现）
│   │   └── util ===================== 项目工具目录
│   ├── checkpoint =================== 模型存放目录
│   │   └── .gitkeep
│   ├── log ========================== 项目日志目录
│   │   └── .gitkeep
│   ├── main.py ---------------------- fastapi 入口文件
│   ├── requirements.txt ------------- 生产环境 Python 依赖声明文件
│   ├── run.sh ----------------------- 项目启动脚本
│   └── tmp ========================== 项目临时文件目录
│       └── .gitkeep
├── build ============================ 项目构建目录
│   ├── config ----------------------- 项目构建配置文件
│   ├── docker ======================= 项目 Dockerfile 存放目录
│   │   ├── Dockerfile --------------- 镜像构建 Dockerfile
│   │   └── Dockerfile.cybuild ------- Cython 加密镜像构建 Dockerfile
│   └── lib ========================== 项目构建库目录
│       ├── build.sh ----------------- 构建运行环境脚本
│       ├── build_image.sh ----------- 构建 docker 镜像脚本
│       ├── cybuild.py --------------- Cython 加密脚本
│       └── run_container.sh --------- 运行 docker 容器脚本
├── lib ============================== 项目库目录
│   └── image_deduplicate.py --------- 图片去重脚本
├── requirements_dev.txt ------------- 开发环境 Python 依赖声明文件
├── test ============================= 测试代码目录
│   ├── csv ========================== locust 测试结果保存目录
│   │   └── .gitkeep
│   ├── locustfile.py ---------------- locust 测试代码
│   ├── log ========================== 测试日志目录
│   │   └── .gitkeep
│   ├── master.conf ------------------ locust 配置文件
│   └── requirements.txt ------------- 测试代码 Python 依赖声明文件
└── testcase ========================= 测试用例目录
    └── .gitkeep

22 directories, 29 files
```

## 模板项目相关命令

模板项目（即 fastapi_build_template 构建的项目）的命令如下所示：

```bash
output$ make
Usage:
        make <Target>

Target:
        init            init the dev env
        clean           cleanup service env
        lint            check python code
        format          format python code
        build           build service env
        run             startup service
        build-docker    build docker image
        run-docker      run docker container
        help            show this help info

Example:
        make init
        make clean
        make lint
        make format
        make build
        make run
        make build-docker
        make run-docker
        make help
```

> **注：** fastapi_build_template 构建的项目仅支持 Python 3.7+ 版本。

### make init

项目环境初始化，安装开发、测试、生产环境依赖。

### make clean

清理服务运行环境，清理 `__pycache__`。

### make lint

使用 flake8 进行 Python 静态代码检查，要求满足 PEP8。

### make format

使用 black 格式化 Python 代码以满足 PEP8。

### make build

本地构建服务运行环境，默认操作为根据 `output/ai-service/requirements.txt` 安装 Python 依赖。

> **注：** 项目 build 若存在额外操作，可在 `output/build/lib/build.sh` 的 `extra_operation` 中添加相关操作。

### make run

本地启动服务。

### make build-docker

构建 Docker 镜像，配置文件 `output/build/config` 以 *key=value* 形式提供如下构建配置：

| 配置名         | 说明                 | 备注                            |
| :------------- | :------------------- | :------------------------------ |
| IMAGE_NAME     | 镜像名               |
| IMAGE_TAG      | 镜像 tag             | 默认值为 latest                 |
| NO_CACHE       | 构建镜像时不使用缓存 | 可选项为 YES 和 NO，默认值为 NO |
| ALWAYS_PULL    | 始终尝试拉取最新镜像 | 可选项为 YES 和 NO，默认值为 NO |
| ENABLE_ENCRYPT | 是否加密             | 可选项为 YES 和 NO，默认值为 NO |

若配置文件中 `ENABLE_ENCRYPT` 为 NO，则使用 `output/build/docker/Dockerfile` 进行构建；

若配置文件中 `ENABLE_ENCRYPT` 为 YES，则使用 `output/build/docker/Dockerfile.cybuild` 进行构建。

> **注：** Dockerfile 的内容可根据实际情况进行修改。

### make run-docker

启动 Docker 容器，配置文件 `output/build/config` 以 *key=value* 形式提供如下启动配置：

| 配置名          | 说明                         | 备注                                           |
| :-------------- | :--------------------------- | :--------------------------------------------- |
| CONTAINER_NAME  | 容器名                       |
| PORT            | 映射端口                     | 默认值为 8080                                  |
| GPUS            | GPU 设备                     | 指定 GPU 编号使用 "," 分割，不填默认不使用 GPU |
| LOG_PATH        | 日志挂载路径                 | 绝对路径，不填默认不挂载                       |
| TMP_PATH        | 临时文件挂载路径             | 绝对路径，不填默认不挂载                       |
| IS_CLEANUP_TMP  | 是否清理临时文件             | 可选项为 YES 和 NO，默认值为 YES               |
| WEB_CONCURRENCY | uvicorn 的 worker 进程的数量 | 默认值为 1                                     |

执行 `make run-docker` 命令时，会显示当前配置下 Docker 容器启动命令，为后续单独部署提供参考。

命令输出内容如下所示：

```bash
output$ make run-docker
start to run docker ...
/root/fastapi_build_template/output/build/lib/run_container.sh
info: parse build config ...
info: run docker container ...
+ docker run -d --name ai-service --restart=always -p 8080:8080 -e WEB_CONCURRENCY=1 ai-service:latest
eab7cbfb152662ae3907809013871a8a4383118f21be67bd94dbf522f70d7c69
+ set +x
```

### make help

查看 `make` 命令的帮助信息。

## 模板项目其他功能

以下功能未收录到模板项目 `make` 命令中，需单独调用。

### 图片去重

使用模板项目开发 CV 相关服务时，可对收录的图片数据进行去重。

图片去重脚本路径为 `output/lib/image_deduplicate.py`，其帮助信息如下所示：

```bash
output$ ./lib/image_deduplicate.py -h
usage: image_deduplicate.py [-h] [--clean] directory

Tool to clean up duplicate images

positional arguments:
  directory   directory to cleanup

optional arguments:
  -h, --help  show this help message and exit
  --clean     delete useless files
```

> **注：** 脚本会将指定目录下所有无用的文件（文件夹、损坏的图片、非图像文件、重复的图片）移入目录下的 `.tmp` 文件夹（自动创建）。若添加了 `--clean` 参数，则会自动删除 `.tmp` 文件夹。

### Cython 加密

为防止服务源码泄露，可使用 Cython 将 py 文件转换为 so 文件进行加密。

Cython 加密脚本路径为 `output/build/lib/cybuild.py`，其帮助信息如下所示：

```bash
output$ ./build/lib/cybuild.py -h
usage: cybuild.py [-h] [--clean] [--execution_file EXECUTION_FILE] PACKAGE

python code compile tool

positional arguments:
  PACKAGE               package to compile

optional arguments:
  -h, --help            show this help message and exit
  --clean               clean compiled python files
  --execution_file EXECUTION_FILE
                        The executable file that does not compile, defaults to
                        the first level of the py file in the compilation
                        directory
```

> **注：** 若不指定 `--execution_file` 参数，脚本默认指定目录下的 py 文件为服务启动文件，不进行编译。

### Locust 性能测试

为方便对模板项目构建的服务进行性能测试，模板项目提供了 Locust 测试脚本模板，可根据服务接口进行性能测试脚本的编写。

Locust 测试脚本模板路径为 `output/test/locustfile.py`，启动配置文件为 `output/test/master.conf`。启动命令为：

```bash
output/test$ python locustfile.py
```

> **注：** Locust 性能测试脚本编写可参考 [Locust 官方文档](http://docs.locust.io/en/1.0b2/what-is-locust.html)
