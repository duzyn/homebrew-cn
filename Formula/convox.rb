class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.9.1.tar.gz"
  sha256 "90066e7b984a75a9958360c58dafa0d9b9e44753f27b1c36ee74144c8585f311"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9cb499cd5aaf29accf13b8ad45018c1ff8929058fec5fd3d10084251cb942299"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f29ad17f66b0bdeb8767f2d6d328ec5e0644984ad1a7eb1d058e1d54009d0bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4f9253b59de77546443a1dec9c5e7ea11beab745ccd7229cb368f5be1998458"
    sha256 cellar: :any_skip_relocation, ventura:        "7262041b8d473c80674a6fa4e3f790b8dbbb8481cf51b55f90e16bb688d41759"
    sha256 cellar: :any_skip_relocation, monterey:       "f81cf75d2d0ce1fe09d0df4371928298d32cf40a35076950248ecd5dc3e5eee5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b561d8d71f2e2be7c71541bb0f69d8d2c7bb1d771840b5a940f29f5d0a8d5b42"
    sha256 cellar: :any_skip_relocation, catalina:       "9048f2cc8c95321298a38b2f8ccfe3859570c0580dc4d4afe02d2154fc6e6422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffb2d8e2b8eae76a53597402732f1aec38cf472d1e31ab6daf19d7fb7700a104"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
