class PythonBotocore < Formula
  desc "Low-level, data-driven core of boto 3"
  homepage "https://botocore.amazonaws.com/v1/documentation/api/latest/index.html"
  url "https://files.pythonhosted.org/packages/ea/2f/4a00df4431399806b46d37c30a7009991c8e1117a46e94d4f37073bf4eaf/botocore-1.32.5.tar.gz"
  sha256 "75a68f942cd87baff83b3a20dfda11b3aeda48aad32e4dcd6fe8992c0cb0e7db"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc12682a86adf13deddf6547f35c7f390e9ecce00053655cb5d887307eca6b2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7dfc4dc521cb5183b5f19ffe66e220d3345fff7d1dbba78a3e9ede9aea6d697"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b34cd7eb6d729f0dd095637cd1a8c554b760f345ce99eee76140582a5a71150d"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ff69a93eb1117bd3b97cd115fe22c4d48624117822ef61e97971877c34f9b29"
    sha256 cellar: :any_skip_relocation, ventura:        "453e26e7090f689ec16f7b2269ca54eb312e8aeb02f2ca5b17bb322d9d1207b3"
    sha256 cellar: :any_skip_relocation, monterey:       "88614949168dadf9ffa3007acd70b8bdb5ddd537818a7c817139bf415d8b6ef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9eb6a09ad38ef044f9a15cfbee72af4ea8668b0011ed129abaffcf58815e57c"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-dateutil"
  depends_on "python-jmespath"
  depends_on "python-urllib3"
  depends_on "six"

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
      system python_exe, "-c", "from botocore.config import Config"
    end
  end
end
