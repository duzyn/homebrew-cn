class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://mirror.ghproxy.com/https://github.com/snapcore/snapd/releases/download/2.67.1/snapd_2.67.1.vendor.tar.xz"
  version "2.67.1"
  sha256 "fe04e3fc21be6c7c2d042e9d8c15383210f400b664dfe870dd1a0aafd2247fec"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96a201322ee3c92193cad3ae5fe806f891647a311f926781c9de570ec68e5160"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96a201322ee3c92193cad3ae5fe806f891647a311f926781c9de570ec68e5160"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96a201322ee3c92193cad3ae5fe806f891647a311f926781c9de570ec68e5160"
    sha256 cellar: :any_skip_relocation, sonoma:        "10e8630955b5e1d696f23bb1d8dde66233a1898c27d30f6e8c06c0717db06f84"
    sha256 cellar: :any_skip_relocation, ventura:       "10e8630955b5e1d696f23bb1d8dde66233a1898c27d30f6e8c06c0717db06f84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08ab6ed3453075d59cc6d30353ceadd6695b72da5dd36f6652e348926888f798"
  end

  depends_on "go" => :build
  depends_on "squashfs"

  def install
    system "./mkversion.sh", version.to_s
    tags = OS.mac? ? ["-tags=nosecboot"] : []
    system "go", "build", *std_go_args(ldflags: "-s -w"), *tags, "./cmd/snap"

    bash_completion.install "data/completion/bash/snap"
    zsh_completion.install "data/completion/zsh/_snap"

    (man8/"snap.8").write Utils.safe_popen_read(bin/"snap", "help", "--man")
  end

  test do
    (testpath/"pkg/meta").mkpath
    (testpath/"pkg/meta/snap.yaml").write <<~YAML
      name: test-snap
      version: 1.0.0
      summary: simple summary
      description: short description
    YAML
    system bin/"snap", "pack", "pkg"
    system bin/"snap", "version"
  end
end
