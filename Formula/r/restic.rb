class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.net/"
  url "https://mirror.ghproxy.com/https://github.com/restic/restic/archive/refs/tags/v0.16.5.tar.gz"
  sha256 "2e8a57f0d1d2b90d67253d1287159dc467bdb7f3b385be2db39e7213b44672be"
  license "BSD-2-Clause"
  head "https://github.com/restic/restic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6de5802d5fbb9d7a3986b2b98041f19c491dc108825d89e8248cb8794e2fb6e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6de5802d5fbb9d7a3986b2b98041f19c491dc108825d89e8248cb8794e2fb6e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6de5802d5fbb9d7a3986b2b98041f19c491dc108825d89e8248cb8794e2fb6e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "452623859042653ee69dc2f65bef94949b1bfd38e41d8bbe3cab5e78a37cc473"
    sha256 cellar: :any_skip_relocation, ventura:        "452623859042653ee69dc2f65bef94949b1bfd38e41d8bbe3cab5e78a37cc473"
    sha256 cellar: :any_skip_relocation, monterey:       "452623859042653ee69dc2f65bef94949b1bfd38e41d8bbe3cab5e78a37cc473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f96d24d127389558dd5297998b1fcc5b03d5e37bf5e97409c52af2cf7cadaa8"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build.go"

    mkdir "completions"
    system "./restic", "generate", "--bash-completion", "completions/restic"
    system "./restic", "generate", "--zsh-completion", "completions/_restic"
    system "./restic", "generate", "--fish-completion", "completions/restic.fish"

    mkdir "man"
    system "./restic", "generate", "--man", "man"

    bin.install "restic"
    bash_completion.install "completions/restic"
    zsh_completion.install "completions/_restic"
    fish_completion.install "completions/restic.fish"
    man1.install Dir["man/*.1"]
  end

  test do
    mkdir testpath/"restic_repo"
    ENV["RESTIC_REPOSITORY"] = testpath/"restic_repo"
    ENV["RESTIC_PASSWORD"] = "foo"

    (testpath/"testfile").write("This is a testfile")

    system "#{bin}/restic", "init"
    system "#{bin}/restic", "backup", "testfile"

    system "#{bin}/restic", "restore", "latest", "-t", "#{testpath}/restore"
    assert compare_file "testfile", "#{testpath}/restore/testfile"
  end
end
