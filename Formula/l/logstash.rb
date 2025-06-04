class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https://www.elastic.co/products/logstash"
  url "https://mirror.ghproxy.com/https://github.com/elastic/logstash/archive/refs/tags/v9.0.2.tar.gz"
  sha256 "4832bd27b409ab1c11a148384020aff52a25cbb7a40c03266be596960591155d"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/elastic/logstash.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ba8e383cac8eb5798246c924bdef959e938e96c80180bdb838b9d4886077806"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb853eefffcdeb13d85400742cc510a2dd298dfcfa4aab236538b86a36e50caf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3300a397242f9912ac0b1d9c09ad92c64c8b87930d6f57ff9f88ef3b612f6825"
    sha256 cellar: :any,                 sonoma:        "26114af78c22a802e39dab8e884cb14ab42b4d26be591b9c953bc1d61ed5e28c"
    sha256 cellar: :any,                 ventura:       "eb9ee7b6d1f0ddebbb1f6105f32e1e41362a7bc3cfd540a23234599db21990d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e4914260b5aa4eddad31e665f130d4b23d48e0dbe24ce3d2598a6b6a6bb6cf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78e2290521d6c421a508fb0bba461b763df0555ce6a1613fae6b7a8c2eb13ce9"
  end

  depends_on "openjdk@21"

  uses_from_macos "ruby" => :build

  def install
    # remove non open source files
    rm_r("x-pack")
    ENV["OSS"] = "true"

    # Build the package from source
    system "rake", "artifact:no_bundle_jdk_tar"
    # Extract the package to the current directory
    mkdir "tar"
    system "tar", "--strip-components=1", "-xf", Dir["build/logstash-*.tar.gz"].first, "-C", "tar"
    cd "tar"

    inreplace "bin/logstash",
              %r{^\. "\$\(cd `dirname \$\{SOURCEPATH\}`/\.\.; pwd\)/bin/logstash\.lib\.sh"},
              ". #{libexec}/bin/logstash.lib.sh"
    inreplace "bin/logstash-plugin",
              %r{^\. "\$\(cd `dirname \$0`/\.\.; pwd\)/bin/logstash\.lib\.sh"},
              ". #{libexec}/bin/logstash.lib.sh"
    inreplace "bin/logstash.lib.sh",
              /^LOGSTASH_HOME=.*$/,
              "LOGSTASH_HOME=#{libexec}"

    # Delete Windows and other Arch/OS files
    paths_to_keep = OS.linux? ? "#{Hardware::CPU.arch}-#{OS.kernel_name}" : OS.kernel_name
    rm Dir["bin/*.bat"]
    Dir["vendor/jruby/tmp/lib/jni/*"].each do |path|
      rm_r path unless path.include? paths_to_keep
    end

    libexec.install Dir["*"]

    # Move config files into etc
    (etc/"logstash").install Dir[libexec/"config/*"]
    rm_r(libexec/"config")

    bin.install libexec/"bin/logstash", libexec/"bin/logstash-plugin"
    bin.env_script_all_files libexec/"bin", LS_JAVA_HOME: "${LS_JAVA_HOME:-#{Language::Java.java_home("21")}}"

    # remove non-native architecture pre-built libraries
    paths = [
      libexec/"vendor/jruby/lib/ruby/stdlib/libfixposix/binary",
    ]
    paths.each do |path|
      path.each_child { |dir| rm_r(dir) unless dir.to_s.include? Hardware::CPU.arch.to_s }
    end
    rm_r libexec/"vendor/jruby/lib/ruby/stdlib/libfixposix/binary/arm64-darwin" if OS.mac? && Hardware::CPU.arm?
  end

  def post_install
    ln_s etc/"logstash", libexec/"config" unless (libexec/"config").exist?
  end

  def caveats
    <<~EOS
      Configuration files are located in #{etc}/logstash/
    EOS
  end

  service do
    run opt_bin/"logstash"
    keep_alive false
    working_dir var
    log_path var/"log/logstash.log"
    error_log_path var/"log/logstash.log"
  end

  test do
    # workaround https://github.com/elastic/logstash/issues/6378
    (testpath/"config").mkpath
    ["jvm.options", "log4j2.properties", "startup.options"].each do |f|
      cp prefix/"libexec/config/#{f}", testpath/"config"
    end
    (testpath/"config/logstash.yml").write <<~YAML
      path.queue: #{testpath}/queue
    YAML
    (testpath/"data").mkpath
    (testpath/"logs").mkpath
    (testpath/"queue").mkpath

    data = "--path.data=#{testpath}/data"
    logs = "--path.logs=#{testpath}/logs"
    settings = "--path.settings=#{testpath}/config"

    output = pipe_output("#{bin}/logstash -e '' #{data} #{logs} #{settings} --log.level=fatal", "hello world\n")
    assert_match "hello world", output
  end
end
