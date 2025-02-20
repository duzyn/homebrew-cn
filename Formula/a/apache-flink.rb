class ApacheFlink < Formula
  desc "Scalable batch and stream data processing"
  homepage "https://flink.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=flink/flink-1.20.1/flink-1.20.1-bin-scala_2.12.tgz"
  mirror "https://archive.apache.org/dist/flink/flink-1.20.1/flink-1.20.1-bin-scala_2.12.tgz"
  version "1.20.1"
  sha256 "5fc4551cd11aee83a9569392339c43fb32a60847db456e1cb4fa64c8daae0186"
  license "Apache-2.0"
  head "https://github.com/apache/flink.git", branch: "master"

  livecheck do
    url "https://flink.apache.org/downloads/"
    regex(/href=.*?flink[._-]v?(\d+(?:\.\d+)+)-bin[^"' >]*?\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fbe2fb53fc2f5ac4138833d16af72d80e6ee2f8a3ba38b5fa41cf993d5710ea0"
  end

  depends_on "openjdk@11"

  def install
    inreplace "conf/config.yaml" do |s|
      s.sub!(/^env:/, "env.java.home: #{Language::Java.java_home("11")}\n\\0")
    end
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/flink"
  end

  test do
    (testpath/"log").mkpath
    (testpath/"input").write "foo bar foobar"
    expected = <<~EOS
      (foo,1)
      (bar,1)
      (foobar,1)
    EOS
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"
    ENV.prepend "FLINK_LOG_DIR", testpath/"log"
    system libexec/"bin/start-cluster.sh"
    system bin/"flink", "run", "-p", "1",
           libexec/"examples/streaming/WordCount.jar", "--input", testpath/"input",
           "--output", testpath/"result"
    system libexec/"bin/stop-cluster.sh"
    assert_path_exists testpath/"result"
    result_files = Dir[testpath/"result/*/*"]
    assert_equal 1, result_files.length
    assert_equal expected, (testpath/result_files.first).read
  end
end
