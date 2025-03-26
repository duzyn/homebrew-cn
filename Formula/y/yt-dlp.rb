class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Feature-rich command-line audio/video downloader"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/ca/a2/7b89b34081f2ec88ba6cde546dcb389001f5df44eeb540793b1eb68e615f/yt_dlp-2025.3.25.tar.gz"
  sha256 "c7f42516f9df31daef53cca2590239401cf31db7c4eaca67667cfd82f2e0ae27"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f410fbcf7453ba2cbafe182dd625aa5e00ad23eb5e38c8a98b6a757c76ed6b4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea50658f2e24df627d742121963153537008ac47e812f3b629f0931a433b2198"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a5da2b04105afd8dc5a611f02ee3aec16b51f2ebaeb3e54df5d0829277aabf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc2014267fb860368194f4ba980b83e800481785e2137d8650efa7a6b1c7373a"
    sha256 cellar: :any_skip_relocation, ventura:       "569d15b41eb39fcf111cc6206f0ebca97eed70a0b04ae64e2b9c8025722227eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de81bb69e1716bdda096f77e45868e98b3e822c33ab30838d868cfdf8b3a9ff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb032bd98a6a249764d7e1a4325bad30f46035ee4489217e6b7f80f5e2182907"
  end

  head do
    url "https://github.com/yt-dlp/yt-dlp.git", branch: "master"

    depends_on "pandoc" => :build

    on_macos do
      depends_on "make" => :build
    end
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/81/e6/64bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77/mutagen-1.47.0.tar.gz"
    sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/ba/d5/861a7daada160fcf6b0393fb741eeb0d0910b039ad7f0cd56c39afdd4a20/pycryptodomex-3.22.0.tar.gz"
    sha256 "a1da61bacc22f93a91cbe690e3eb2022a03ab4123690ab16c46abb693a9df63d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/e6/26d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1/websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  def install
    system "gmake", "lazy-extractors", "pypi-files" if build.head?
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/yt-dlp.1"
    bash_completion.install libexec/"share/bash-completion/completions/yt-dlp"
    zsh_completion.install libexec/"share/zsh/site-functions/_yt-dlp"
    fish_completion.install libexec/"share/fish/vendor_completions.d/yt-dlp.fish"
  end

  test do
    system bin/"yt-dlp", "https://mirror.ghproxy.com/https://raw.githubusercontent.com/Homebrew/brew/refs/heads/master/Library/Homebrew/test/support/fixtures/test.gif"

    # YouTube tests fail bot detection
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"yt-dlp", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    system bin/"yt-dlp", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
