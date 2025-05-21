class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://mirror.ghproxy.com/https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.41.3.tar.gz"
  sha256 "534eb0da0636d289b373e3f8545a88b05089c64e8bd5671513a0c9c79d8dbf28"
  license "MIT"
  head "https://github.com/Infisical/infisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44297783607d0c66519fbcf057b7bc51047232d92808ee6c84b61957d23d5eed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44297783607d0c66519fbcf057b7bc51047232d92808ee6c84b61957d23d5eed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44297783607d0c66519fbcf057b7bc51047232d92808ee6c84b61957d23d5eed"
    sha256 cellar: :any_skip_relocation, sonoma:        "da984eccbcd05002910b1345d806002ed7923b1da467c84c8c0832ae9c98de8b"
    sha256 cellar: :any_skip_relocation, ventura:       "da984eccbcd05002910b1345d806002ed7923b1da467c84c8c0832ae9c98de8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26f69cba18de8dc7194ccf608df520ed4e0b1a5d242af09c45f9f150941c9daa"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical init 2>&1", 1)
    assert_match "You must be logged in to run this command.", output
  end
end
