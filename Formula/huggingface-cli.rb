class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/index"
  url "https://files.pythonhosted.org/packages/2f/64/beeb8ef2f852abbd93887a87899899829a7a386b6f91631194f574d02b4d/huggingface_hub-0.11.1.tar.gz"
  sha256 "8b9ebf9bbb1782f6f0419ec490973a6487c6c4ed84293a8a325d34c4f898f53f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37f1df297a29a58beb44e3ec2e9c135d363647d3df4f8b27ed084c06b6cc3f28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6caa47e400b9b5efa7cbc0809a0bb2cae4a7249e406bf6da309777542c97ff0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02a387c7f47106a942f0442e26320155c15cfb3baf40c5dd0a478c1214bf78fc"
    sha256 cellar: :any_skip_relocation, ventura:        "a7db708e5f0073ec896b15c60528f78750b6e18c2ed71243dd9f4766d4be5f73"
    sha256 cellar: :any_skip_relocation, monterey:       "c7f79f55ec35c7e2d1e3c1d098d389dbad654cac782dd629105867094e126444"
    sha256 cellar: :any_skip_relocation, big_sur:        "abf9bf474356171a44cb629453bd1823e669c3cc3f9dfad3d0b9ede2ac9cdeb0"
    sha256 cellar: :any_skip_relocation, catalina:       "ee3f3237485e3d6d0a128fc0eb718e33fb0a169b01b1b5dde2a81d44e84aca82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6922bb81c0e2ef307008d886f8f5c8894f8714d3af924ee8d7a2b8fe46bd1587"
  end

  depends_on "git-lfs"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/95/55/b897882bffb8213456363e646bf9e9fa704ffda5a7d140edf935a9e02c7b/filelock-3.8.0.tar.gz"
    sha256 "55447caa666f2198c5b6b13a26d2084d26fa5b115c00d065664b2124680c4edc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/c1/c2/d8a40e5363fb01806870e444fc1d066282743292ff32a9da54af51ce36a2/tqdm-4.64.1.tar.gz"
    sha256 "5f4f682a004951c1b450bc753c710e9280c5746ce6ffedee253ddbcbf54cf1e4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c2/51/32da03cf19d17d46cce5c731967bf58de9bd71db3a379932f53b094deda4/urllib3-1.26.13.tar.gz"
    sha256 "c083dd0dce68dbfbe1129d5271cb90f9447dea7d52097c6e0126120c521ddea8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    whoami_output = shell_output("#{bin}/huggingface-cli whoami")
    assert_match "Not logged in", whoami_output
    test_cache = testpath/"cache"
    test_cache.mkdir
    ENV["HUGGINGFACE_HUB_CACHE"] = test_cache.to_s
    ENV["NO_COLOR"] = "1"
    scan_output = shell_output("#{bin}/huggingface-cli scan-cache")
    assert_match "Done in 0.0s. Scanned 0 repo(s) for a total of 0.0.", scan_output
  end
end
