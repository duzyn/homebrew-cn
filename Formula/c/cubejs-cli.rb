class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.44.tgz"
  sha256 "309c38653dbc03939a8d45e9dd261039b4166163422e600abd446fc458176f5e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1e2e2a29c22c6425bcdf0c179c161d2e3b2c1d4dff59d51fdd99481cce970a89"
    sha256 cellar: :any,                 arm64_sonoma:  "1e2e2a29c22c6425bcdf0c179c161d2e3b2c1d4dff59d51fdd99481cce970a89"
    sha256 cellar: :any,                 arm64_ventura: "1e2e2a29c22c6425bcdf0c179c161d2e3b2c1d4dff59d51fdd99481cce970a89"
    sha256 cellar: :any,                 sonoma:        "3a71acc8f467b35ed53421d1ed554914ec2bb5396e2d378c1b768d252bb08056"
    sha256 cellar: :any,                 ventura:       "3a71acc8f467b35ed53421d1ed554914ec2bb5396e2d378c1b768d252bb08056"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23306b0dddccb157a2fbe5cecfb662fcaed8248dcae136e1ad5a78ca38135849"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a167ab64e959f2ccd407c519e6355e3495d296f77c75757a16562d009afb0e1f"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
