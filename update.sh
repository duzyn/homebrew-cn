#!/usr/bin/env bash

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

cd "$SCRIPT_DIR" || exit 1

: "${TEST:="false"}"
if [[ "$TEST" == "true" ]]; then
    git clone --depth 1 https://mirror.ghproxy.com/https://github.com/Homebrew/homebrew-core
    git clone --depth 1 https://mirror.ghproxy.com/https://github.com/Homebrew/homebrew-cask
    git clone --depth 1 https://mirror.ghproxy.com/https://github.com/Homebrew/homebrew-cask-versions
fi

rm -rf ./Formula ./Casks ./Aliases
mkdir -p ./Formula ./Casks ./Aliases
cp -r ./homebrew-core/Formula/* ./Formula/
cp -r ./homebrew-core/Aliases/* ./Aliases/
cp -r ./homebrew-cask/Casks/* ./Casks/
cp -r ./homebrew-cask-versions/Casks/* ./Casks/
rm -rf ./homebrew-core ./homebrew-cask ./homebrew-cask-versions

for file in ./Formula/**/*.rb ./Casks/**/*.rb; do
    perl -pi -e 's#(github\.com/.+/releases/download)#mirror.ghproxy.com/https://\1#g;
                 s#(raw\.githubusercontent\.com)#mirror.ghproxy.com/https://\1#g;
                 s#(github\.com/.+/raw)#mirror.ghproxy.com/https://\1#g;
                 s#(github\.com/.+/archive)#mirror.ghproxy.com/https://\1#g;
                 s#(downloads\.sourceforge\.net/.*)"#\1?use_mirror=jaist"#g;
                 s#download\.kde\.org#mirrors.ustc.edu.cn/kde#g;
                 s#(www\.)?7-zip\.org/a#mirror.nju.edu.cn/7-zip#g;
                 s#mirror\.ctan\.org#mirrors.aliyun.com/CTAN#g;
                 s#nodejs\.org/dist#npmmirror.com/mirrors/node#g;
                 s#www\.python\.org/ftp/python#npmmirror.com/mirrors/python#g;
                 s#go\.dev/dl#mirrors.aliyun.com/golang#g;
                 s#download\.videolan\.org#mirrors.aliyun.com/videolan#g;
                 s#media\.inkscape\.org/dl/resources/file#mirror.nju.edu.cn/inkscape#g;
                 s#dbeaver\.io/files#mirror.ghproxy.com/https://github.com/dbeaver/dbeaver/releases/download#g;
                 s#cdn-fastly\.obsproject\.com/downloads/obs-studio-(.+)-macos#mirrors.nju.edu.cn/github-release/obsproject/obs-studio/OBS%20Studio%20\1/obs-studio-\1-macos#g;
                 s#download\.gimp\.org/gimp#mirrors.aliyun.com/gimp/gimp#g;
                 s#download\.blender\.org#mirrors.aliyun.com/blender#g;
                 s#download\.virtualbox\.org/virtualbox#mirror.nju.edu.cn/virtualbox/#g;
                 s#www\.wireshark\.org/download#mirror.nju.edu.cn/wireshark/#g;
                 s#archive\.torproject\.org/tor-package-archive#tor.ybti.net/dist#g;
                 s#download\.calibre-ebook\.com/#mirror.ghproxy.com/https://github.com/kovidgoyal/calibre/releases/download/v#g' "$file"
done
