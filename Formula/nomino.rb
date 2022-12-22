class Nomino < Formula
  desc "Batch rename utility"
  homepage "https://github.com/yaa110/nomino"
  url "https://github.com/yaa110/nomino/archive/1.3.0.tar.gz"
  sha256 "826bfa9b17ea1f298cd653ec55016255dbfe2fea4c712dbe1e5af8df4cd674ba"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yaa110/nomino.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c673b8643644c72952fa354f4677677e13ab782eb006f088cb0c5b05363fcbc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6da4cba837b0cd0bb0fef1bba68f43dc7cd75dce0c5482e1fa59264cb07e2567"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77d909db2b337aa52532367887604eb39001130eb4d76b034dcde22898c599ea"
    sha256 cellar: :any_skip_relocation, ventura:        "2ea9efa75257a060c83745b3ab840c9b015790f2ce62514cd9b5c99edf66ec3e"
    sha256 cellar: :any_skip_relocation, monterey:       "98ad2fd3a87ee7be7401e8558ae9560c66a7681fc7f18d1317a41583171380f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cc92cd86b5dbccbb97319e56753c6a4989b4c8486d5d4c4a799fbe03fc3a20f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db8c1ab3396d603048a23d1b2f8115480154f810b8003a7db52fd92100e7dae3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (1..9).each do |n|
      (testpath/"Homebrew-#{n}.txt").write n.to_s
    end

    system bin/"nomino", "-e", ".*-(\\d+).*", "{}"

    (1..9).each do |n|
      assert_equal n.to_s, (testpath/"#{n}.txt").read
      refute_predicate testpath/"Homebrew-#{n}.txt", :exist?
    end
  end
end
