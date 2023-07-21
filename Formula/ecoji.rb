class Ecoji < Formula
  desc "Encodes (and decodes) data as emojis"
  homepage "https://github.com/keith-turner/ecoji"
  url "https://ghproxy.com/https://github.com/keith-turner/ecoji/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "59c78ddaef057bbfb06ea8522dfc51ea8bce3e8f149a3231823a37f6de0b4ed2"
  license "Apache-2.0"
  head "https://github.com/keith-turner/ecoji.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23b8840deb6010c46dbef2a199375627fbe0d29d0fdd4fe0f7b3bb7998a66742"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23b8840deb6010c46dbef2a199375627fbe0d29d0fdd4fe0f7b3bb7998a66742"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23b8840deb6010c46dbef2a199375627fbe0d29d0fdd4fe0f7b3bb7998a66742"
    sha256 cellar: :any_skip_relocation, ventura:        "262576c8572a6bf2b65b8fb0cb5091a2831616e84f586af9a88d72584f3b1c5c"
    sha256 cellar: :any_skip_relocation, monterey:       "262576c8572a6bf2b65b8fb0cb5091a2831616e84f586af9a88d72584f3b1c5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "262576c8572a6bf2b65b8fb0cb5091a2831616e84f586af9a88d72584f3b1c5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8faad5be2a6c052f1489356052b81fab7bbfa597c7285f93842e99fe4f46f60"
  end

  depends_on "go" => :build

  def install
    cd "cmd" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
    # system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd"
  end

  test do
    text = "Base64 is so 1999"
    encoded_text = "🧏📩🧈🐇🧅📘🔯🚜💞😽♏🐊🎱🤾☕"
    assert_equal encoded_text, pipe_output("#{bin}/ecoji -e", text).chomp
    assert_equal text, pipe_output("#{bin}/ecoji -d", encoded_text).chomp
  end
end
