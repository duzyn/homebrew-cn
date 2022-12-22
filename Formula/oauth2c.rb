class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "a91d14b66be48f6e83803fa266a0cde783791d8a6ab5ab56040262ebc126923a"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d72b1840b622cb3a439503dce0ea0d3c6e8d99fa291b8e609cedbe2c46a3131"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27bbe25012c412fa1fa3dcf24a3dc2c7c138efd88be013e9537c9fe69290897d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e85a0ca6af326f74f0fa3dfd8d3d7a4a66e8d213ff4baf86bced6dbf0ed485c"
    sha256 cellar: :any_skip_relocation, ventura:        "217dd50c64ecd96dce2e627bf96781908d1c2f20c77f22a5d8d0f76195a1bd2c"
    sha256 cellar: :any_skip_relocation, monterey:       "c5292fef188dec847c48fa86d797340f04e246451991ed70f15ba160415de436"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1839e028f4f4ac50c66d24be63e3659cc8c11be09ff95f7cc6c1a0a7fff4ca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76b7e120bbaf780edf88cd38fd261d7944a066cfb83542cc055f1a9b8ca50772"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Authorization completed",
      shell_output("#{bin}/oauth2c https://oauth2c.us.authz.cloudentity.io/oauth2c/demo " \
                   "--client-id cauktionbud6q8ftlqq0 " \
                   "--client-secret HCwQ5uuUWBRHd04ivjX5Kl0Rz8zxMOekeLtqzki0GPc " \
                   "--grant-type client_credentials " \
                   "--auth-method client_secret_basic " \
                   "--scopes introspect_tokens,revoke_tokens")
  end
end
