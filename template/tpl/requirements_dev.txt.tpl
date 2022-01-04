--index-url https://pypi.tuna.tsinghua.edu.cn/simple/
--extra-index-url https://mirrors.aliyun.com/pypi/simple/

flake8==4.0.1
black==21.12b0

--requirement @SERVICE_NAME@/requirements.txt
--requirement test/requirements.txt
