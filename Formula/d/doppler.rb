class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https://docs.doppler.com/docs"
  url "https://mirror.ghproxy.com/https://github.com/DopplerHQ/cli/archive/refs/tags/3.66.3.tar.gz"
  sha256 "36dd51dffc4045e27f902d0d0aa9b7c04ffd38e747a78869544b2d9c1117ba46"
  license "Apache-2.0"
  head "https://github.com/DopplerHQ/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1fd86a63fc71ed25da9b77db414f1720ff1353ee55a7e574fe4dfd66bcc5dce7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6720504b963ee14ccf878d7f0e83c9edab28ae6800217362eee38bca6700b162"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0223976f3fb7eed0b9f5df834cef061ab4f66a6764489b19952fd84bee7a67b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "91aa0be0b43b9079700aab0e63dbac965e0a42856d01c7995b0b8c4494221761"
    sha256 cellar: :any_skip_relocation, ventura:        "d767b73c28d9051a9378be9a1b2921bd5742f60f64d8f5bbd26c3f2e845a42da"
    sha256 cellar: :any_skip_relocation, monterey:       "d4dee64b7f22efbb5e5d68f725ac026a7fa5d7308789e32c0ca47ad59330f7ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baeea4d75398a216dd3f3a5ae1c4b1fd8f42331eb0a05197358c65b9d968d135"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/DopplerHQ/cli/pkg/version.ProgramVersion=dev-#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"doppler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doppler --version")

    output = shell_output("#{bin}/doppler setup 2>&1", 1)
    assert_match "Doppler Error: you must provide a token", output
  end
end
