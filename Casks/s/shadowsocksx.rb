cask "shadowsocksx" do
  version "2.6.3"
  sha256 "f0e263dd1d74b0b6977389f2b8b28c524bceccbc5ad24ca8a8164b92ede1c45a"

  url "https://mirror.ghproxy.com/https://github.com/shadowsocks/shadowsocks-iOS/releases/download/#{version}/ShadowsocksX-#{version}.dmg"
  name "ShadowsocksX"
  desc "Removed according to regulations"
  homepage "https://github.com/shadowsocks/shadowsocks-iOS/wiki/Shadowsocks-for-OSX-Help"

  app "ShadowsocksX.app"
end
