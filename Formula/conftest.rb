class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.37.0.tar.gz"
  sha256 "19cb13fc6d1d5e9d6c80b0db348b4ed7a6a15ae726da3a94469eb451ded4d2ff"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82f3f1c30321428e05a8246140195245f454b4a7d349e97d0f78b7ccc20f9bb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4deddabc1d7731acb1ba392068b58dd0c5a47d681a544b739ec911547370eba2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a32ef38e884ef772fdb9560202d4bb6e7f7b7e551ee62f6d32de1ef96480b881"
    sha256 cellar: :any_skip_relocation, ventura:        "1f84d88a712c3e3b419d596c03eedbfb293ba1b707f3465e337faf38c04db85a"
    sha256 cellar: :any_skip_relocation, monterey:       "3a157c84d02d24bc167509d1ed0034ca07b36e2ae673e624a9a17d3c9fbf56b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "db7776c2fe68ea106926e2b07834fdbc32088f353a1e839c70d7382f195ac4ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dcc91a436b33b8f11ec806bd53ff2dbb9c2b9cc6192c5df0f066c5ae1ec3fc3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/open-policy-agent/conftest/internal/commands.version=#{version}")

    generate_completions_from_executable(bin/"conftest", "completion")
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system "#{bin}/conftest", "verify", "-p", "test.rego"
  end
end
