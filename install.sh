#!/bin/bash

# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump | gzip`
set -o pipefail
# Turn on traces, useful while debugging but commented out by default.
: "${DEBUG:="false"}"
if [[ "$DEBUG" == "true" ]]; then
    set -o xtrace
fi

SCRIPT_DIR="$(dirname "$(readlink -f "${0}")")"

# 安装 Homebrew
/bin/bash -c "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | sed -e 's|https://github.com|https://ghproxy.com/https://github.com|g')"

# 关闭从 API 安装，使用 Homebrew v4.0 之前默认的行为
export HOMEBREW_NO_INSTALL_FROM_API=True
export HOMEBREW_BREW_GIT_REMOTE="https://ghproxy.com/https://github.com/homebrew/brew"
export HOMEBREW_CORE_GIT_REMOTE="https://ghproxy.com/https://github.com/homebrew/homebrew-core"
export HOMEBREW_BOTTLE_DOMAIN="https://ghproxy.com/https://github.com/homebrew/homebrew-bottles"
# 其他镜像
# 阿里云
# export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/brew.git"
# export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/homebrew-core.git"
# export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.aliyun.com/homebrew/homebrew-bottles"
# 清华大学
# export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
# export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
# export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_PIP_INDEX_URL="https://mirrors.aliyun.com/pypi/simple/"

# 添加本应用库
brew tap --custom-remote --force-auto-update duzyn/cn https://ghproxy.com/https://github.com/duzyn/homebrew-cn

cd "$(brew --repo duzyn/cn)"
git config pull.rebase true

# 保存配置到 `.zshrc` 或 `.bash_profile`
tee "$SCRIPT_DIR/config" &>/dev/null <<"EOF"
# 关闭从 API 安装，使用 Homebrew v4.0 之前默认的行为
export HOMEBREW_NO_INSTALL_FROM_API=True
export HOMEBREW_BREW_GIT_REMOTE="https://ghproxy.com/https://github.com/homebrew/brew"
export HOMEBREW_CORE_GIT_REMOTE="https://ghproxy.com/https://github.com/homebrew/homebrew-core"
export HOMEBREW_BOTTLE_DOMAIN="https://ghproxy.com/https://github.com/homebrew/homebrew-bottles"
# 其他镜像
# 阿里云
# export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/brew.git"
# export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/homebrew-core.git"
# export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.aliyun.com/homebrew/homebrew-bottles"
# 清华大学
# export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
# export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
# export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_PIP_INDEX_URL="https://mirrors.aliyun.com/pypi/simple/"
EOF

if [[ -e "$HOME/.bash_profile" ]]; then
    if ! grep "HOMEBREW_NO_INSTALL_FROM_API" "$HOME/.bash_profile" &>/dev/null; then
        cat "$SCRIPT_DIR/config" >> "$HOME/.bash_profile"
    fi
fi

if [[ -e "$HOME/.zshrc" ]]; then
    if ! grep "HOMEBREW_NO_INSTALL_FROM_API" "$HOME/.zshrc" &>/dev/null; then
        cat "$SCRIPT_DIR/config" >> "$HOME/.zshrc"
    fi
fi

rm "$SCRIPT_DIR/config"

echo "homebrew and homebrew-cn is installed successfully."
exit 0
