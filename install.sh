#!/bin/bash

set -e
#获取当前目录
current_dir="$(cd "$(dirname "$0")" && pwd)"
#获取内网ip
local_ip=$(hostname -I|cut -d" " -f 1)

#判断是否存在安装配置文件,没有则创建一个
if [ -f ${current_dir}/install.conf ];then
echo ${local_ip} >> ${current_dir}/install.conf
source ${current_dir}/install.conf
else
touch ${current_dir}/install.conf
echo ${local_ip} >> ${current_dir}/install.conf
source ${current_dir}/install.conf
fi

install_conf=${current_dir}/install.conf
echo $install_conf;

#判断是否存在安装目录
if [ -f /usr/local/bin/abctl ];then
base_dir=$(cat /usr/local/bin/abctl | grep base_dir= | awk -F= '{print $2}' 2>/dev/null)
echo "存在已安装的, 安装目录为 ${base_dir}"
elif [ -f $install_conf ] && [ $(cat $install_conf | grep base_dir= | awk -F= '{print $2}' 2>/dev/null) ];then
base_dir=$(cat $install_conf | grep base_dir= | awk -F= '{print $2}' 2>/dev/null)
echo "安装目录为 ${base_dir}, 开始进行安装"
else
base_dir=${current_dir}
fi


#将安装配置文件导入到.env环境变量文件中
cd ${base_dir}
cat install.conf >> .env
#下载abctl
echo "$(curl -fsSL https://github.com/youtaqiu/abctl-shell/raw/main/abctl)" >> ${base_dir}/abctl
#安装abctl指令(aalab_server的自定义命令)
cp abctl /usr/local/bin && chmod +x /usr/local/bin/abctl
ln -s /usr/local/bin/abctl /usr/bin/abctl 2>/dev/null
cp -f ${current_dir}/install.conf ${base_dir}/install.conf.example
source ${current_dir}/install.conf
