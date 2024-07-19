class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://mirror.ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.63.1.tar.gz"
  sha256 "3652d570fa954140f7f2814408020ca74aad1d44bf35022598baa376ba8f3e7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e045cd6a5f8f759be0808833f566e22b90df9195ef7cecabf5bce05344a90d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a061b393937c0388061bb6e9d24bfb905c18489cbff4c3cfca0cb6546df4da1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c93e61acbb5e642a909d43a9cbcc942d07df91d8d1a7e85def9c781fb388c32"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2af7dc48c6611ea7bae105588708ae882d584f7b8a9339799b03dedd58e7553"
    sha256 cellar: :any_skip_relocation, ventura:        "7425b7ddee39a27e85f1aa58ae624181d7bbb907bfe8bc8fd2b9e83333ad8765"
    sha256 cellar: :any_skip_relocation, monterey:       "2b914463047c5fe82515af48de5930505bb4d37f8bf79f8e7812f4b7c0734bff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d8b107eaf828baa2c6fd278a120302fe82b897d90e77d6351df9f9891fd80f6"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
