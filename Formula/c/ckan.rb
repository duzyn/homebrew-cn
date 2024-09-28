class Ckan < Formula
  desc "Comprehensive Kerbal Archive Network"
  homepage "https://github.com/KSP-CKAN/CKAN/"
  url "https://mirror.ghproxy.com/https://github.com/KSP-CKAN/CKAN/releases/download/v1.35.0/ckan.exe"
  sha256 "55ebaf6b1740fa5fa32a0e1b52fefd84d9ce5e02d7289762318b26a53bd7e288"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eb8addf38bd16ea1aec5629845aa2628ba88416fe242baa01eff838066fd38dd"
  end

  depends_on "mono"

  def install
    (libexec/"bin").install "ckan.exe"
    (bin/"ckan").write <<~EOS
      #!/bin/sh
      exec mono "#{libexec}/bin/ckan.exe" "$@"
    EOS
  end

  def caveats
    <<~EOS
      To use the CKAN GUI, install the ckan-app cask.
    EOS
  end

  test do
    assert_match version.to_s, shell_output(bin/"ckan version")

    output = shell_output(bin/"ckan update", 1)
    assert_match "I don't know where a game instance is installed", output
  end
end
