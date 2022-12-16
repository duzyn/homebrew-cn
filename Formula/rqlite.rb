class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.13.0.tar.gz"
  sha256 "0adf1776a5b8d9583d1bcfdf28e3f92d78b33dc8dbf094af75e6b60a02993865"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8de0886aa58ad38e9343b7f86355e62e578d0a32847b854960c3ac895577cc72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3333feb4e90beef8cd104da4e5866d95c05edb889e9db9643d2b8baf71cddd33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d6f1fddaad1203cb7caec7d9179ad1943102abe970a3270770b0eed68c09978"
    sha256 cellar: :any_skip_relocation, ventura:        "b8be25989ab51e73d88697ee8d303a1d247d0c27aa32a46709b43702cce75deb"
    sha256 cellar: :any_skip_relocation, monterey:       "7d35d06afaf86abc797b22bf3f83ea5a5f1f23e16e413a783df9fcd794288ea1"
    sha256 cellar: :any_skip_relocation, big_sur:        "b01cf201ea563c358be242c936b3992af16b91dc9eb7bece5af41403997d951a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbc9e5039c9ef4c7e46986dc61be56ee5cef57b884664a4713070528eff45e52"
  end

  depends_on "go" => :build

  def install
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/cmd, "./cmd/#{cmd}"
    end
  end

  test do
    port = free_port
    fork do
      exec bin/"rqlited", "-http-addr", "localhost:#{port}",
                          "-raft-addr", "localhost:#{free_port}",
                          testpath
    end
    sleep 5

    (testpath/"test.sql").write <<~EOS
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    EOS
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output
  end
end
