class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.25.3",
      revision: "5779ad7c8901c1e48cf324cec430c26212684b45"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9cc1bb08bdb30d86310d574dab37e713759cc590c2fa03d8d08fa3cadd89bda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afe2df1ed5955a4a422b62700403a876466c49779502a47e76a33ed9d6396f8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "048b6cafe82040b1dc38496e4afbca9d9364557aeb75d2a6de3f7d82298d5cfe"
    sha256 cellar: :any_skip_relocation, ventura:        "720fa37a6898491c46f3370a8b1fcfd2f2ac93aa3c37172471f004d43a98655f"
    sha256 cellar: :any_skip_relocation, monterey:       "aa0d5515f8d01ea53b389860b74aa28923bc152c73b77d9d3ba914af32ff936e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c4412ea73523bcc662e2a741181f3a7604a3c42a97c6dc6498e150d2b85080d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21a0933993cb9b27b0eba0e5fa33dc8aee57c80143e7ce9915922f7cea686a98"
  end

  depends_on "go"

  def install
    ENV["GOBIN"] = bin
    system "make", "install"

    generate_completions_from_executable(bin/"operator-sdk", "completion")
  end

  test do
    if build.stable?
      version_output = shell_output("#{bin}/operator-sdk version")
      assert_match "version: \"v#{version}\"", version_output
      commit_regex = /[a-f0-9]{40}/
      assert_match commit_regex, version_output
    end

    mkdir "test" do
      output = shell_output("#{bin}/operator-sdk init --domain=example.com --repo=github.com/example/memcached")
      assert_match "$ operator-sdk create api", output

      output = shell_output("#{bin}/operator-sdk create api --group c --version v1 --kind M --resource --controller")
      assert_match "$ make manifests", output
    end
  end
end
