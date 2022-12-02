class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.34.tar.gz"
  sha256 "a036406c7d20c31e168ba90540ebb27c4c107f8915bd15a971496194200e137f"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29e909dbbace9b27a8de317484598cdb3f08a54e40e570dab53969980ef4ccb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d51597ee31edafd9b73565c758a957175b720be6e9f6194295c146610c945cc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5cb37560d4df6402405a4d219a882a59b6d8d2e01e4cba46d06002c8771ce42e"
    sha256 cellar: :any_skip_relocation, ventura:        "69652b87256cb9e82e10c59dd6e9a7c51a680cff482816a1b3b9ba0a338cd0c3"
    sha256 cellar: :any_skip_relocation, monterey:       "b4b56b8a2a428153438d7734ee17bebde04438da3b7b1044f0fe9e64e293b7ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3e97817d4a3963bed4da63d96c2f3e932c2b9f10a67153169406e96a752ed6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2035d2e5034675d024ca05c1639e135d63e02b2f44c54ddab5a6bc621c147a3"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "dist/local/act"
  end

  test do
    (testpath/".actrc").write <<~EOS
      -P ubuntu-latest=node:12.6-buster-slim
      -P ubuntu-12.04=node:12.6-buster-slim
      -P ubuntu-18.04=node:12.6-buster-slim
      -P ubuntu-16.04=node:12.6-stretch-slim
    EOS

    system "git", "clone", "https://github.com/stefanzweifel/laravel-github-actions-demo.git"

    cd "laravel-github-actions-demo" do
      system "git", "checkout", "v2.0"

      pull_request_jobs = shell_output("#{bin}/act pull_request --list")
      assert_match "php-cs-fixer", pull_request_jobs

      push_jobs = shell_output("#{bin}/act push --list")
      assert_match "phpinsights", push_jobs
      assert_match "phpunit", push_jobs
    end
  end
end
