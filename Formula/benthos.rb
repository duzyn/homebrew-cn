class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/v4.11.0.tar.gz"
  sha256 "4326ea513d40b282a22d7c6a236e5b14677bcd32dde9074ec3ec4dc65e1dfe2b"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f133907fd628b313a8d7aa826cc95631ef7a0e5285a87b8889865946d7e7e579"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44f52ca7b419ff7d49378682eb6255def900276e370ba2305ee7d8519353ffed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7f92c0e0f638baf4ad305b85b6eeb1ffb702650b7c112998ee4dd2457785afa"
    sha256 cellar: :any_skip_relocation, ventura:        "ad85a8f56ba8ed5b6156667ac7a1acc5c9490da09d2b743eca4afb2419eea38f"
    sha256 cellar: :any_skip_relocation, monterey:       "36a32d51b7c92ff6db7bd0cb7f9676fd4e933d1816284bc14ae5dbb03a2cf283"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba214b16b3f5ac45b3dbb347e3f0d3e9071835bebc29d6d1aecaeb0be6c47769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03e3e1947e02aaec03c585483cb72c22abaeaa108d5940474e85256d5fa53b12"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "target/bin/benthos"
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~EOS
      ---
      logger:
        level: ERROR
      input:
        file:
          paths: [ ./sample.txt ]
      pipeline:
        threads: 1
        processors:
         - bloblang: 'root = content().decode("base64")'
      output:
        stdout: {}
    EOS
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end
