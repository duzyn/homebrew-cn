require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.48.0.tgz"
  sha256 "29af852c2c20ae658a8070eef1b8a933326ffd524800b3569bab96aecf4594f6"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f6362a5c64a2aae5a85d95e0a57c6406227a5c058c942dae1bd8e320be606352"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a7eb4c652d099b6206ff13a3ec31f00f26a148021e30b56fd543459ca2cf14f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "861329d4ec21accaa2ba4eef7a06d7efe8f10d1b81ef12fd9857c093c5e66eaa"
    sha256 cellar: :any_skip_relocation, sonoma:         "20c39343f27d80f2023b0d5926145c514c1311846cd23e22d2123e7a397329ad"
    sha256 cellar: :any_skip_relocation, ventura:        "ae19acafdedb2b56c899e7cd8ffa29c8876b3c4abb17d9194b87c252b8054873"
    sha256 cellar: :any_skip_relocation, monterey:       "db8aef0b8766cddf146f439a71e3462b317b3591e5413e5c0319401fb86c53d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c84a3ba2c4fe5b17b745776a4f27d69de910cf300ff81d335040cbd3cedf3dd"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
