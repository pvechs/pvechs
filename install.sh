#!/usr/bin/env bash

## 用来下载翻译文件并自动完成替换。

echo -e "本脚本用来自动安装Proxmox相关系统的中文翻译，支持以下系统：\n"
echo -e "[1] Proxmox Backup Server\n"
echo -e "[2] Proxmox Mail Gateway\n"
echo -e "[3] Proxmox VE\n"
read -p "请输入你要安装的系统：" choice
case choice in
    1) server=pbs;;
    2) server=pmg;;
    3) server=pve;;
    *) echo "选择错误，退出！" && exit 1;;
esac
target_file=/usr/share/${server}-i18n/${server}-lang-zh_CN.js
[[ ! -s $target_file.bak ]] && {
    cp $target_file $target_file.bak
    echo "已将原始翻译文件备份为 $target_file.bak"
} || echo "已经存在中文翻译文件备份 $target_file.bak"

dlurl=https://raw.githubusercontent.com/pvechs/pvechs/main/release/${server}-lang-zh_CN.js
wget $dlurl -O $target_file.new
[[ $? -eq 0 ]] && {
    mv $target_file.new $target_file
    echo "安装中文翻译文件成功"
} || echo "安装中文翻译文件失败，请检查是否可以正常访问 $dlurl"
