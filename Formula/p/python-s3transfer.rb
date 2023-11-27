class PythonS3transfer < Formula
  desc "Amazon S3 Transfer Manager for Python"
  homepage "https://github.com/boto/s3transfer"
  url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
  sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ab3ecf930e4429888b484b4217f27aa2dc9b9cc0acf857fc653be6a64d151b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65c291f330ae5c09e74f4b6f482ba61ebf08628d46e4ee0b6ec15bdbb86660a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f75dc5dabf48bcb7e010ed3b346c449e63044b97b6ecd1f169ae492b0f54f259"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5e16fa54b81847adda42d9f7a3e20584a242113d7fcc1591951a51c6d80e963"
    sha256 cellar: :any_skip_relocation, ventura:        "93c32c226644f4b82e9c40c6e75befc15d5bbfcddcd0322484df35dd19496fc0"
    sha256 cellar: :any_skip_relocation, monterey:       "4bd2c86da96ef113d2d1e1f73ce911dc9261f64e1940b48e70aa3449963a75b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "676d534f485605f2ebd504ebeca6d0243df62155c1f5286530f70a6999436bd7"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-botocore"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from s3transfer.manager import TransferManager"
    end
  end
end
