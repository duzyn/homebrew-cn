# homebrew-cn

中国用户能用的 Homebrew 应用库，每日同步 Homebrew 的官方库，加速应用的下载速度

## 安装 Homebrew

    /bin/bash -c "$(curl -fsSL https://cdn.jsdelivr.net/gh/duzyn/homebrew-cn/install.sh)"

## 设置 Homebrew Core

在 `.zshrc` 或 `.bash_profile` 中加入

    export HOMEBREW_CORE_GIT_REMOTE="https://ghproxy.com/github.com/Homebrew/homebrew-core"

## 添加应用库

    brew tap --custom-remote --force-auto-update duzyn/cn https://ghproxy.com/github.com/duzyn/homebrew-cn

## 安装应用

    brew install duzyn/cn/APPNAME

## 卸载 Homebrew

    /bin/bash -c "$(curl -fsSL https://cdn.jsdelivr.net/gh/duzyn/homebrew-cn/uninstall.sh)"

## 类似项目

[scoop-cn](https://github.com/duzyn/scoop-cn)
