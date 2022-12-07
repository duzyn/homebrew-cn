class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.6.12.tar.gz"
  sha256 "a5ed3849942e89b9e90c93e0df98ccc113f26e81ad8e73fd8182907106eae1a2"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f26a54b3e4be5284565a6d8d4e8ed991a0cc5c31519c6e3416de288279251802"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f26a54b3e4be5284565a6d8d4e8ed991a0cc5c31519c6e3416de288279251802"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f26a54b3e4be5284565a6d8d4e8ed991a0cc5c31519c6e3416de288279251802"
    sha256 cellar: :any_skip_relocation, ventura:        "d2fcb7a5962810e2c67e869866b13e14e8df5bc393f8d26c198020109c209da1"
    sha256 cellar: :any_skip_relocation, monterey:       "d2fcb7a5962810e2c67e869866b13e14e8df5bc393f8d26c198020109c209da1"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2fcb7a5962810e2c67e869866b13e14e8df5bc393f8d26c198020109c209da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0aba334bff88a83714b7746bf3d14449432f53f39c37105d50efbe289509c89c"
  end

  depends_on "python@3.11"

  uses_from_macos "sqlite" => :test

  def install
    libexec.install Dir["*"]

    files = [
      libexec/"lib/core/dicts.py",
      libexec/"lib/core/settings.py",
      libexec/"lib/request/basic.py",
      libexec/"thirdparty/magic/magic.py",
    ]
    inreplace files, "/usr/local", HOMEBREW_PREFIX

    %w[sqlmap sqlmapapi].each do |cmd|
      rewrite_shebang detected_python_shebang, libexec/"#{cmd}.py"
      bin.install_symlink libexec/"#{cmd}.py"
      bin.install_symlink bin/"#{cmd}.py" => cmd
    end
  end

  test do
    data = %w[Bob 14 Sue 12 Tim 13]
    create = "create table students (name text, age integer);\n"
    data.each_slice(2) do |n, a|
      create << "insert into students (name, age) values ('#{n}', '#{a}');\n"
    end
    pipe_output("sqlite3 school.sqlite", create, 0)
    select = "select name, age from students order by age asc;"
    args = %W[--batch -d sqlite://school.sqlite --sql-query "#{select}"]
    output = shell_output("#{bin}/sqlmap #{args.join(" ")}")
    data.each_slice(2) { |n, a| assert_match "#{n}, #{a}", output }
  end
end
