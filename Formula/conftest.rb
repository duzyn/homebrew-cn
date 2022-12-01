class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.36.0.tar.gz"
  sha256 "90a84d0f1aee5e71cddd524ff943f487eac7ec923699de764e941174a8bdb509"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e9b4da42c6b8ccb560216d132f56be1c64905187a875c5796079cd2e4136cd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fdf528f893a892802eac0b8de8015bcbfad4c0c675c3f3c0410d2f753189e0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59d38ccdd00f249e679c78ad48c8eeed3054e9ab121312d9ab7f165b114d543d"
    sha256 cellar: :any_skip_relocation, ventura:        "70aee7271381fff3c811e8b093a7d7eda71c33804120ba07b8486faa76ff19ca"
    sha256 cellar: :any_skip_relocation, monterey:       "73ddf1ff5fd12f9fac4030617c04bda3656ede559fc811794af5a819a1583d5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "424a29d510e67a5feac9e5784640a4bd2c2f71bb1e74de91be652a1bd06dcbd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4022d0bd4d418412b3111a4e29eeb5201230bfdec0158247433bd5a5afcfebd6"
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
