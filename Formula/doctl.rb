class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.90.0.tar.gz"
  sha256 "4c53d56baf2be785f916fcc9b8f7afdd9b85b0987130de880cba1b86abe7e1e3"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0193522ea8ae90011b5234edbfedbad2541aaf874cee4af53d80425ced82e8fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff2b681411b0027a4aedd14b43d4baafeff9b73e67ae1aaeb60f78a45fe892b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fa89331261a7ab01a89b5537f1767c86d22b59c1f5d0217dad883dac170f2ca"
    sha256 cellar: :any_skip_relocation, ventura:        "f40c43208a3507d7db66383af338c59928d41b0bbdaa7d69d685095781e1442d"
    sha256 cellar: :any_skip_relocation, monterey:       "9941c45d324ac9cd7e109402dbb46d737a912dc535aee7fec2658ef8a64c3f3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f75bfba070cccb7fa117359f0cc2ce00e32b982e3191b377076b9acfc8fddc5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e05c1bc518a196ef52d961efa70dc830777257acc07d3caf5357962febf9398"
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
