#!/usr/bin/env python
# coding:utf-8

import os
import shutil
import argparse
from typing import Set, Tuple

import numpy as np
from PIL import Image
from PIL import UnidentifiedImageError


def get_args() -> Tuple[str, bool]:
    parser = argparse.ArgumentParser(
        description="Tool to clean up duplicate images", add_help=True
    )
    parser.add_argument("directory", help="directory to cleanup")
    parser.add_argument("--clean", action="store_true", help="delete useless files")
    args, _ = parser.parse_known_args()
    return args.directory, args.clean


def get_moved_files(dir_path: str) -> Set:
    """
    获取要移动的文件（夹），包括:
        - 文件夹
        - 损坏的图片
        - 非图像文件
        - 重复的图片
    """
    removed_files = set()
    file_map = {}
    for file in os.listdir(dir_path):
        file_path = os.path.join(dir_path, file)
        # 过滤文件
        if os.path.isfile(file_path):
            # 按文件大小进行分组
            # 不同大小的图片一定不一样，所以只需对比相同大小的图片即可，缩小范围
            size = os.path.getsize(file_path)
            file_map.setdefault(size, []).append(file_path)
        else:
            removed_files.add(file_path)
    for files in file_map.values():
        duplicate_files = set()
        m = len(files)
        for i in range(m):
            if files[i] in duplicate_files:
                continue
            # 损坏图像文件/非图像文件处理
            try:
                img1 = Image.open(files[i])
            except UnidentifiedImageError:
                duplicate_files.add(files[i])
                continue
            image1 = np.array(img1)
            for j in range(i + 1, m):
                if files[j] in duplicate_files:
                    continue
                # 损坏图像文件/非图像文件处理
                try:
                    img2 = Image.open(files[j])
                except UnidentifiedImageError:
                    duplicate_files.add(files[j])
                    continue
                # 判断图片尺寸是否相同
                if img1.size == img2.size:
                    # 判断图片内容是否相同
                    image2 = np.array(img2)
                    if np.array_equal(image1, image2):
                        duplicate_files.add(files[j])
        removed_files = removed_files | duplicate_files
    return removed_files


def move(removed_files: Set, tmp_path: str) -> None:
    """
    移动到临时文件夹
    """
    for file in removed_files:
        shutil.move(file, tmp_path)


if __name__ == "__main__":
    dir_path, is_clean = get_args()
    tmp_path = os.path.join(dir_path, ".tmp")
    os.makedirs(tmp_path, exist_ok=True)
    removed_files = get_moved_files(dir_path)
    move(removed_files, tmp_path)
    if is_clean:
        shutil.rmtree(tmp_path)
