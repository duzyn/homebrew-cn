class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.15.1",
      revision: "88cc526a2d3e52dcbfa52c9dd25eb09ed95470e4"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "825661df57e3e38be6d12dfd976f747c328826d82269af2a59e63f5ff05b8d7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a343aa281e5232d9cae13ad2f0ad81a670b75ca09dad8f47d4712a14ee8c712c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6d162c9df83112a06126a76714d32374df20db70929e0448dc44c30469380b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef9e7125f699169a726917adeb44ba8df0326c7fc49465c81557d86200caf3d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c930434b7cafeee5d6e62911787548215daf8b860b4a9eb6c81bb1fabfa3e20"
    sha256 cellar: :any_skip_relocation, ventura:        "9ac22f43258b3f1f77ec83b92331a687670b2248a942b7d136d709ef52f4934c"
    sha256 cellar: :any_skip_relocation, monterey:       "07f76647512f57c4b23124dfc2178b3d89d446716a24bb685a639f0c152c10f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21283d120a1efad996dcf66430b7d311f1ea4981cc29046eaa1c0a0ec787f853"
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
      exec bin/"auditbeat", "-path.config", testpath/"config", "-path.data", testpath/"data"
    end
    sleep 5
    touch testpath/"files/touch"

    sleep 30

    assert_predicate testpath/"data/beat.db", :exist?

    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"
  end
end
