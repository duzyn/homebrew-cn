require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.16.1.tar.gz"
  sha256 "8459860005fd72d01bfd0a52e64c0e4ac355578a2e7076df7b2a13f3c0463513"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0be01b867f34b4dea2d70efa4e3870c4a5035c0e6ce1e6e30e6e76ca9c1a67e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb75b8a4a5abcf2be63eacc77c3be9dc36d5baffab52757491a885c8adc4c76d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14c12f82f117fecfa3aeaf1e74ca1ff04ca5c8f79c6a4c7c716af36e5c796db7"
    sha256 cellar: :any_skip_relocation, ventura:        "0c6744a81ce92c5993b77b22de08e46629dd4b101114c7b945708ea2bdd31f80"
    sha256 cellar: :any_skip_relocation, monterey:       "8514b779aec711db3932f0940fa158cc30b9e7a4c0145b4b73191d875b7e6694"
    sha256 cellar: :any_skip_relocation, big_sur:        "33076b970506d26422443deeb45a9b456a785fa8fb5b7a06504f74dd1ad6d336"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a66e4d2403105bd7d0d7cee3d459fe00e875a5e5142143ae4a03dceb064f7901"
  end

  depends_on "go" => :build
  depends_on "node@16" => :build # Switch back to node with https://github.com/vercel/pkg/issues/1364

  def install
    Language::Node.setup_npm_environment

    ldflags = %W[
      -s -w
      -X github.com/hasura/graphql-engine/cli/v2/version.BuildVersion=#{version}
      -X github.com/hasura/graphql-engine/cli/v2/plugins.IndexBranchRef=master
    ]

    # Based on `make build-cli-ext`, but only build a single host-specific binary
    cd "cli-ext" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "prebuild"
      system "./node_modules/.bin/pkg", "./build/command.js", "--output", "./bin/cli-ext-hasura", "-t", "host"
    end

    cd "cli" do
      arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
      os = OS.kernel_name.downcase

      cp "../cli-ext/bin/cli-ext-hasura", "./internal/cliext/static-bin/#{os}/#{arch}/cli-ext"
      system "go", "build", *std_go_args(output: bin/"hasura", ldflags: ldflags), "./cmd/hasura/"

      generate_completions_from_executable(bin/"hasura", "completion", base_name: "hasura", shells: [:bash, :zsh])
    end
  end

  test do
    system bin/"hasura", "init", "testdir"
    assert_predicate testpath/"testdir/config.yaml", :exist?
  end
end
