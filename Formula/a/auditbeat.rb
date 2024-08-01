class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.14.3",
      revision: "71819961045386b23edc18455f1b54764292816c"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70df98e82c88804d711219d7eb66ba8bd013bae3551b3a0029e7883b010c8b17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9d5bb5199b07a506bcd30eb6e2db9fe3be02550cca6645fee4eda96180277fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a38ed72ae3785b6a0f4d3e4f68a874b10ce7741499f1e61887f2e31d3c84c2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "15cc2244f40000e093786cb82743dc9e35e4697ca9a4282687980110d893ca58"
    sha256 cellar: :any_skip_relocation, ventura:        "1a27fcd9291c39d4489a7795051f68f46ec422f843b474764b056d5a5fba3c6d"
    sha256 cellar: :any_skip_relocation, monterey:       "3dbb75dbefa3570f37dc012758d8168277f1cd90257170fd0bcd87108739b30e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4471ae6817487b3371b5bbdd19dec664d8d738a417676bc8f22f35a26942d3dd"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build

  def install
    # remove non open source files
    rm_r("x-pack")

    cd "auditbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "devtools.GenerateModuleIncludeListGo, Docs)",
                               "devtools.GenerateModuleIncludeListGo)"

      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      system "mage", "-v", "update"

      (etc/"auditbeat").install Dir["auditbeat.*", "fields.yml"]
      (libexec/"bin").install "auditbeat"
      prefix.install "build/kibana"
    end

    (bin/"auditbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/auditbeat \
        --path.config #{etc}/auditbeat \
        --path.data #{var}/lib/auditbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/auditbeat \
        "$@"
    EOS

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
    (testpath/"config/auditbeat.yml").write <<~EOS
      auditbeat.modules:
      - module: file_integrity
        paths:
          - #{testpath}/files
      output.file:
        path: "#{testpath}/auditbeat"
        filename: auditbeat
    EOS
    fork do
      exec "#{bin}/auditbeat", "-path.config", testpath/"config", "-path.data", testpath/"data"
    end
    sleep 5
    touch testpath/"files/touch"

    sleep 30

    assert_predicate testpath/"data/beat.db", :exist?

    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"
  end
end
