class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Feature-rich command-line audio/video downloader"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/2f/79/acfe1c2bf64ed83e1b465e6550c0f5bc2214ea447a900b102f5ca6e4186e/yt_dlp-2024.10.22.tar.gz"
  sha256 "47b82a1fd22411b5c95ef2f0a1ae1af4e6dfd736ea99fdb2a0ea41445abc62ba"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a80da0ccb4ef7b822d425db9099e795ba00241e15cf45c91fe62a616889dac1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd8f8cb7a65d9801e3ca44b2dddb09a3986ca067d420986ecb7060ad816b0191"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38a61fdb6070a33faed2d3be323bf5332559bc01828017254de16cebbe8d5335"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9579fa9bd9bc78e3df7e92a4ad259ef7fef0b49aa533bc23d6def01b9c24b8d"
    sha256 cellar: :any_skip_relocation, ventura:       "a3249d1c0069a7cb62432e2c034f1086485c44e99288ce0258ca576017e6ba09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8445d420e7e46dfa4c7e701033df42ac3572ef4f22c6aa1770ed71487e5f348"
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
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
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
    url "https://files.pythonhosted.org/packages/11/dc/e66551683ade663b5f07d7b3bc46434bf703491dbd22ee12d1f979ca828f/pycryptodomex-3.21.0.tar.gz"
    sha256 "222d0bd05381dd25c32dd6065c071ebf084212ab79bab4599ba9e6a3e0009e6c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/e2/73/9223dbc7be3dcaf2a7bbf756c351ec8da04b1fa573edaf545b95f6b0c7fd/websockets-13.1.tar.gz"
    sha256 "a3b3366087c1bc0a2795111edcadddb8b3b59509d5db5d7ea3fdd69f954a8878"
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
