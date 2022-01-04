#!/usr/bin/env python3
# coding:utf-8

import os
import sys
import shutil
import argparse
from pprint import pprint
from typing import List, Tuple

try:
    from distutils.core import setup
    from Cython.Build import cythonize
    from Cython.Distutils import build_ext
except ModuleNotFoundError:
    print(
        "You don't seem to have cython installed."
        "Please install it first by command 'pip install cython'"
    )
    sys.exit(1)


def get_args() -> Tuple[str, bool, List]:
    parser = argparse.ArgumentParser(
        description="python code compile tool", add_help=True
    )
    parser.add_argument("PACKAGE", help="package to compile")
    parser.add_argument(
        "--clean", action="store_true", help="clean compiled python files"
    )
    parser.add_argument(
        "--execution_file",
        action="append",
        help="The executable file that does not compile, "
        "defaults to the first level of the py file "
        "in the compilation directory",
    )
    args, _ = parser.parse_known_args()
    return args.PACKAGE, args.clean, args.execution_file


def convert_execution_files(files: List[str]) -> List[str]:
    execution_files = []
    for file in files:
        if os.path.isfile(file):
            fpath = os.path.abspath(file)
            execution_files.append(fpath)
        else:
            print("execution_file must be given a file")
            sys.exit(-1)
    print("== THE FOLLOWING PYTHON FILES ARE EXECUTION FILES ==")
    pprint(execution_files)
    return execution_files


def get_execution_files(package_dir: str) -> List[str]:
    """
    获取执行文件，执行文件不进行编译
    编译目录下第一层的 py 文件为执行文件
    """
    execution_files = []
    for f in os.listdir(package_dir):
        fpath = os.path.abspath(os.path.join(package_dir, f))
        if f.endswith(".py") and os.path.isfile(fpath):
            execution_files.append(fpath)
    print("== THE FOLLOWING PYTHON FILES ARE EXECUTION FILES ==")
    pprint(execution_files)
    return execution_files


def get_compile_files(package_dir: str, execution_files: List[str]) -> List[str]:
    """
    获取编译文件
    """
    compile_files = []
    for path, dirs, files in os.walk(package_dir):
        # 自动生成 __init__.py
        if "__init__.py" not in files and not os.path.samefile(path, package_dir):
            with open(os.path.join(path, "__init__.py"), "w") as f:
                f.write("#!/usr/bin/env python3\n")
                f.write("# coding:utf-8\n")

        for fname in files:
            fpath = os.path.abspath(os.path.join(path, fname))
            if (
                os.path.splitext(fname)[-1] == ".py"
                and os.path.splitext(fname)[0] != "__init__"
                and fpath not in execution_files
            ):
                compile_files.append(fpath)
    print("== THE FOLLOWING PYTHON FILES WILL BE COMPILED ==")
    pprint(compile_files)
    return compile_files


def clean(file_list: List[str]) -> None:
    for f in file_list:
        os.remove(f)


class MyBuildExt(build_ext):
    def __init__(self, *args, **kwargs) -> None:
        super().__init__(*args, **kwargs)
        # 编译扩展模块的目录
        self.build_lib = package_dir
        # 忽略 build-lib，把编译好的文件放到源代码目录下，与 Python 文件一起。
        self.inplace = False
        self.debug = False

    def run(self):
        print("COMPILING STARTED ...")
        super().run()
        print("COMPILING FINISHED !!")

        # get_outputs()：编译产生的 so 文件列表
        outputs = self.get_outputs()
        if len(outputs) > 0:
            print("== COMPILED OUTPUTS ==")
            pprint(outputs)
        else:
            print("== COMPILED NOTHING ==")

        # get_source_files(): 编译的 c 文件列表
        for source in self.get_source_files():
            os.remove(source)

        # build_temp：编译产生的临时文件的存放目录
        if os.path.exists(self.build_temp):
            shutil.rmtree(self.build_temp)


if __name__ == "__main__":
    package_dir, is_clean, execution_files = get_args()
    # print(package_dir, is_clean)

    if not os.path.isdir(package_dir):
        print("PACKAGE must be given a directory")
        sys.exit(-1)

    if execution_files:
        execution_files = convert_execution_files(execution_files)
    else:
        execution_files = get_execution_files(package_dir)
    compile_files = get_compile_files(package_dir, execution_files)

    setup(
        ext_modules=cythonize(
            compile_files,
            compiler_directives={
                # 支持 keyword 参数
                "always_allow_keywords": True,
                # 设置 python 大版本，2 or 3
                "language_level": 3,
            },
        ),
        cmdclass={"build_ext": MyBuildExt},
        script_args=["build_ext"],
    )

    if is_clean:
        clean(compile_files)
