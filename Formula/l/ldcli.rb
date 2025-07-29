class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://mirror.ghproxy.com/https://github.com/launchdarkly/ldcli/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "00437d61ed1e51d221352fc6523db16cc2e6fd68321ca9c781ddbb2af32810df"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bdaeea10cfb5f06ac61bf0b5d65f8cef3d7899081237f0e3b6f493b67a07251"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0efad73e90312acafe4254e1c852f53648238e3223c25da17a86699bafbc2ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4967ca9326575268cf1b2323ccd9b3701bfea654d03a21018025db1aaf2e8f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a629d22647be00cbc17fd0c34e66643af9f772164d4e955e45d6156d931c895e"
    sha256 cellar: :any_skip_relocation, ventura:       "38b9e449039ffc767d6f08b03bbdac68b420b58b24a644f17914b52d75aa9632"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2231a18d314dd1e7d9d04e3a61beefb9439b077f5b46cfaca6c985cfa78fbc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "856c043224a0d7906b4d40b172ec17bba43083604efab428c274468b43c0be93"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ldcli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ldcli --version")

    assert_match "Invalid account ID header",
      shell_output("#{bin}/ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1")
  end
end
