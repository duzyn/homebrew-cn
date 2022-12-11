class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.26.0",
      revision: "cbeec475e4612e19f1047ff7014342afe93f60d2"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59040f8090c039a9772ccc74990b862c053aaaf2af330cc49602d4afc166b7f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "762896997182935b28ec10c7db022d13931b9122ad6dced4221122b023d21435"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45dae033c84c95a5f1a525c0f088fbd7ac788099c5b42ddd608b6b725d31c542"
    sha256 cellar: :any_skip_relocation, ventura:        "4effdbaea3d12d6b0b41ed5aa2b36a9e054e801ba586e3f22eb1f5c45eb8ee10"
    sha256 cellar: :any_skip_relocation, monterey:       "f1bf122bdff1aff2bcb660099c9d3df799f93123833167f4562e0c66da02c29f"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbfaf4086da9e76ef6739906c670951c56ad9f399c3b0de487668533d2a15258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0663ad39863a1ff712d24b8bc02544e54820f16a1c2d8a719324616f0aaeb86c"
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
