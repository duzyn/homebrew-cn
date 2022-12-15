class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.11.0.tar.gz"
  sha256 "1d4138752fa168e05a24dec5c60be4fd564c62a414b99c47d523159f6efd2adf"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(?:-ci\d)?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "def478b2976caa4417f5794a2fd54cbf8b7a98171fb566c9f5e35aef16edefd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd1ef12983e20bc4af252f3a9b0a7fc5129ffbc8ac5ac057b6af48cdf8a23957"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61bc462ba939d574fd38760c575747d7d5465ff0f6fd1cc544655d83b026a6ce"
    sha256 cellar: :any_skip_relocation, ventura:        "5cb6b3ce5d2907f2488bf378a084f129518714908140797e709616cb0195a103"
    sha256 cellar: :any_skip_relocation, monterey:       "b5caa8c0d7c35ed714cde08bda7a6db6aea9b995b4a56fd7a96a398dc702547e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b8ef1e4db72929f5917060549d47c9b738038f3fc381bcf1f19a0688f800f32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc77a09312ccff8b106ffc337dc79361b73736d95d5153084555e89891a8818d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.Version=v#{version}", "-trimpath", "-o", bin/"chamber"
    prefix.install_metafiles
  end

  test do
    ENV.delete "AWS_REGION"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "MissingRegion", output

    ENV["AWS_REGION"] = "us-west-2"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "NoCredentialProviders", output
  end
end
