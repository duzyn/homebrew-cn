class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https://www.djangoproject.com/"
  url "https://mirror.ghproxy.com/https://github.com/django/django/archive/refs/tags/4.2.8.tar.gz"
  sha256 "051ec8e52a9b834dba1d5df6158384616c800374aa3b9a4c03c1bdc175d9e1ac"
  license "BSD-3-Clause"
  head "https://github.com/django/django.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "00ee639f083bf713c1cc4a184087bf2cacb383f991b3c34bf33378299e026f63"
  end

  def install
    bash_completion.install "extras/django_bash_completion" => "django"
  end

  test do
    assert_match "-F _django_completion",
      shell_output("bash -c 'source #{bash_completion}/django && complete -p django-admin'")
  end
end
