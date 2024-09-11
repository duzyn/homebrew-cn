class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://mirror.ghproxy.com/https://github.com/docker/cli/archive/refs/tags/v27.2.1.tar.gz"
  sha256 "cfd8b7b52a01e393a4e4bb584b367d0e7b8ebb4b25bf0f4b1d35b193197e8817"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4d749c41af20db8f943d3415cf57d55cc932f3301af10aca65cf8cda90e67b23"
  end

  # These used to also be provided by the `docker` formula.
  link_overwrite "etc/bash_completion.d/docker"
  link_overwrite "share/fish/vendor_completions.d/docker.fish"
  link_overwrite "share/zsh/site-functions/_docker"

  def install
    bash_completion.install "contrib/completion/bash/docker"
    fish_completion.install "contrib/completion/fish/docker.fish"
    zsh_completion.install "contrib/completion/zsh/_docker"
  end

  test do
    assert_match "-F _docker",
      shell_output("bash -c 'source #{bash_completion}/docker && complete -p docker'")
  end
end
