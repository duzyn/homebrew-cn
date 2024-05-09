require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://mirror.ghproxy.com/https://github.com/svg/svgo/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "fb74c2cca6171c86339581f5f77644096d4fb912cfedc89218fdd2ebb3084fee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97b463c725dee94559f00a56c08a73023bba0d2dc327af5b5c86ff9d1a441914"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4bc28c7f8a98d9212521169165a10ff281386620d577dd1f9c33fada5948a9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8be7cf626081ed2158f5ea5a437e04967b847931edd8727c5a52afb3a43fc2fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1face1b3016ddb6f3f40c4c57f170c1ed1bb512c2be878fe5398094504b6a53"
    sha256 cellar: :any_skip_relocation, ventura:        "91f89cabc947223a23e1e5afbf7b0aca5af086b50d9b2f7a1123a45db868e23a"
    sha256 cellar: :any_skip_relocation, monterey:       "f7ce0f74fbe84df5970e536c8896620d5c7014158df34d1f719e07224811d050"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9926ecf0440fd41b17e9d656483e5c7dd4c1d43110f646ebf2624141cae4bf36"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    cp test_fixtures("test.svg"), testpath
    system bin/"svgo", "test.svg", "-o", "test.min.svg"
    assert_match(/^<svg /, (testpath/"test.min.svg").read)
  end
end
