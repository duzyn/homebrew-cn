class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.17.2",
      revision: "cf5c18e080581711e9189290187fbd721e962fac"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75de96a08d310e29cfc9b4ee13df28d64ac92699eb466ebd3d204c76171b67fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb5760b9ad3bf80ad747c96964929bfca5c720a883771f35d44a151bce3f18c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0af343470d0d9fe3f9dbc304ff68dd7bdc618865f6c0980bf0836d6a85c0b7c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "17a9ed4701c29583a9e95e40b27e8a488c41d1c364c8d594a37a15645c56a009"
    sha256 cellar: :any_skip_relocation, ventura:       "204f851567811c0e9b2535e3c5d706386f0be39b88cbc51b59c464b57cfbb2ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5b50b6489fa93a366c2d64203bdf22dbd2e2b086af35fa35ef85d386a1a57fe"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    # remove non open source files
    rm_r("x-pack")

    cd "auditbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "devtools.GenerateModuleIncludeListGo, Docs)",
                               "devtools.GenerateModuleIncludeListGo)"

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      pkgetc.install Dir["auditbeat.*", "fields.yml"]
      (libexec/"bin").install "auditbeat"
      prefix.install "build/kibana"
    end

    (bin/"auditbeat").write <<~SHELL
      #!/bin/sh
      exec #{libexec}/bin/auditbeat \
        --path.config #{etc}/auditbeat \
        --path.data #{var}/lib/auditbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/auditbeat \
        "$@"
    SHELL

    chmod 0555, bin/"auditbeat"
    generate_completions_from_executable(bin/"auditbeat", "completion", shells: [:bash, :zsh])
  end

  def post_install
    (var/"lib/auditbeat").mkpath
    (var/"log/auditbeat").mkpath
  end

  service do
    run opt_bin/"auditbeat"
  end

  test do
    (testpath/"files").mkpath
    (testpath/"config/auditbeat.yml").write <<~YAML
      auditbeat.modules:
      - module: file_integrity
        paths:
          - #{testpath}/files
      output.file:
        path: "#{testpath}/auditbeat"
        filename: auditbeat
    YAML

    pid = spawn bin/"auditbeat", "--path.config", testpath/"config", "--path.data", testpath/"data"
    sleep 5
    touch testpath/"files/touch"
    sleep 10
    sleep 20 if OS.mac? && Hardware::CPU.intel?

    assert_path_exists testpath/"data/beat.db"

    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
