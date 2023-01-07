class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  # vim should only be updated every 50 releases on multiples of 50
  url "https://github.com/vim/vim/archive/v9.0.1150.tar.gz"
  sha256 "aaa03eaeb68e8ee39137c5ffb8d41b4cce58f53860724829aba6385454b98c69"
  license "Vim"
  head "https://github.com/vim/vim.git", branch: "master"

  # The Vim repository contains thousands of tags and the `Git` strategy isn't
  # ideal in this context. This is an exceptional situation, so this checks the
  # first page of tags on GitHub (to minimize data transfer).
  livecheck do
    url "https://github.com/vim/vim/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 arm64_ventura:  "27b4e6c90ec728a08129d20de9d1d96751bbcc0542c075b044d8ecde698f2c91"
    sha256 arm64_monterey: "5e5e1c4a5a9d47933f2c6fad5a1ccc8cf43de1d41d93a066c5dc565693ad9c6f"
    sha256 arm64_big_sur:  "a24e5980d860fa55051a966e743061d740cb8d44446c14e6d054a80671393e63"
    sha256 ventura:        "2bab3559a126371e19c3d9b3c2fab4105ef7d8ab8078e3979082d466204e5673"
    sha256 monterey:       "ea5f55bdbe3a6bf5797ffd944c96d8c7eca9c0658e9bc6f1179d48599d0dc5c8"
    sha256 big_sur:        "a3324cc214d44b3bcc399f5e55a319ad0a0942c122f987a35503785473f823c2"
    sha256 x86_64_linux:   "2954594016aab653d1af5705ada2932d91ee8f0b3a6c285c1db9154c445e4bd3"
  end

  depends_on "gettext"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python@3.11"
  depends_on "ruby"

  conflicts_with "ex-vi",
    because: "vim and ex-vi both install bin/ex and bin/view"

  conflicts_with "macvim",
    because: "vim and macvim both install vi* binaries"

  # fixes build issue with 9.0.1150, remove after next release
  patch do
    url "https://github.com/vim/vim/commit/5bcd29b84e4dd6435177f37a544ecbf8df02412c.patch?full_index=1"
    sha256 "6d1ae23897088cc13b31ac22f268e74fa063364b7c9a892dbee32397d4d62faf"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.11"].opt_libexec/"bin"

    # https://github.com/Homebrew/homebrew-core/pull/1046
    ENV.delete("SDKROOT")

    # vim doesn't require any Python package, unset PYTHONPATH.
    ENV.delete("PYTHONPATH")

    # We specify HOMEBREW_PREFIX as the prefix to make vim look in the
    # the right place (HOMEBREW_PREFIX/share/vim/{vimrc,vimfiles}) for
    # system vimscript files. We specify the normal installation prefix
    # when calling "make install".
    # Homebrew will use the first suitable Perl & Ruby in your PATH if you
    # build from source. Please don't attempt to hardcode either.
    system "./configure", "--prefix=#{HOMEBREW_PREFIX}",
                          "--mandir=#{man}",
                          "--enable-multibyte",
                          "--with-tlib=ncurses",
                          "--with-compiledby=Homebrew",
                          "--enable-cscope",
                          "--enable-terminal",
                          "--enable-perlinterp",
                          "--enable-rubyinterp",
                          "--enable-python3interp",
                          "--disable-gui",
                          "--without-x",
                          "--enable-luainterp",
                          "--with-lua-prefix=#{Formula["lua"].opt_prefix}"
    system "make"
    # Parallel install could miss some symlinks
    # https://github.com/vim/vim/issues/1031
    ENV.deparallelize
    # If stripping the binaries is enabled, vim will segfault with
    # statically-linked interpreters like ruby
    # https://github.com/vim/vim/issues/114
    system "make", "install", "prefix=#{prefix}", "STRIP=#{which "true"}"
    bin.install_symlink "vim" => "vi"
  end

  test do
    (testpath/"commands.vim").write <<~EOS
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :wq
    EOS
    system bin/"vim", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello python3", File.read("test.txt").chomp
    assert_match "+gettext", shell_output("#{bin}/vim --version")
  end
end
