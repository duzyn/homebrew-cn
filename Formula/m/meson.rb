class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://mirror.ghproxy.com/https://github.com/mesonbuild/meson/releases/download/1.5.0/meson-1.5.0.tar.gz"
  sha256 "45d7b8653c1e5139df35b33be2dd5b2d040c5b2c6129f9a7c890d507e33312b8"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e7fe0a4e6ae2f009bd1c7c648b8c7715e9ed021e96b471bd28109b36095eac4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e7fe0a4e6ae2f009bd1c7c648b8c7715e9ed021e96b471bd28109b36095eac4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e7fe0a4e6ae2f009bd1c7c648b8c7715e9ed021e96b471bd28109b36095eac4"
    sha256 cellar: :any_skip_relocation, sonoma:         "04682d921a967d0d36f0d056a44e6cb2e9888e83b4d15f727a90fcd65a79f40b"
    sha256 cellar: :any_skip_relocation, ventura:        "04682d921a967d0d36f0d056a44e6cb2e9888e83b4d15f727a90fcd65a79f40b"
    sha256 cellar: :any_skip_relocation, monterey:       "04682d921a967d0d36f0d056a44e6cb2e9888e83b4d15f727a90fcd65a79f40b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25a373c667fb817cbbbe23f2fd1301069409903cfca7c15a9c20f75c16283810"
  end

  depends_on "ninja"
  depends_on "python@3.12"

  def install
    python3 = "python3.12"
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."

    bash_completion.install "data/shell-completions/bash/meson"
    zsh_completion.install "data/shell-completions/zsh/_meson"
    vim_plugin_dir = buildpath/"data/syntax-highlighting/vim"
    (share/"vim/vimfiles").install %w[ftdetect ftplugin indent syntax].map { |dir| vim_plugin_dir/dir }

    # Make the bottles uniform. This also ensures meson checks `HOMEBREW_PREFIX`
    # for fulfilling dependencies rather than just `/usr/local`.
    mesonbuild = prefix/Language::Python.site_packages(python3)/"mesonbuild"
    inreplace_files = %w[
      coredata.py
      dependencies/boost.py
      dependencies/cuda.py
      dependencies/qt.py
      scripts/python_info.py
      utils/universal.py
    ].map { |f| mesonbuild/f }
    inreplace_files << (bash_completion/"meson")

    # Passing `build.stable?` ensures a failed `inreplace` won't fail HEAD installs.
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX, build.stable?
  end

  test do
    (testpath/"helloworld.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<~EOS
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    system bin/"meson", "setup", "build"
    assert_predicate testpath/"build/build.ninja", :exist?

    system bin/"meson", "compile", "-C", "build", "--verbose"
    assert_equal "hi", shell_output("build/hello").chomp
  end
end
