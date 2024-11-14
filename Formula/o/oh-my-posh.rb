class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://mirror.ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v24.4.0.tar.gz"
  sha256 "5c5381db204b3d9b4074a7628f8eb1c0737a0bd1afe1473d33fe16c4617b9f3f"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b266e06846bf269e848c70c4ad1c02282c8762f513c13595a0b73b5a77256b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e14bb9c6afa88c1a8f16cf2ad4704caddc32ed5b4082422910afd334104195d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "98aca6684cbad514d53a168bc7e37167d52f6daf4d4117be35f82746bff4d042"
    sha256 cellar: :any_skip_relocation, sonoma:        "714b34e922daba9663943da46a4e478dad1df92dd5c156c1731a6553cd454eda"
    sha256 cellar: :any_skip_relocation, ventura:       "4f575a7385ee45a88624004882f6c4400f83867435ebd2686e87e6908919471e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0018e5ddd973d743ab125246182ed6d6f096533736fce9e6ca7ace9c929d6619"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "Oh My Posh", shell_output("#{bin}/oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
  end
end
