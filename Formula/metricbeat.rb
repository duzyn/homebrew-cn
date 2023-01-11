class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.6.0",
      revision: "561a3e1839f1a50ce832e8e114de399b2bee2542"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4f6d2e116fa2760b488fb2107696b29b7b056809c3ee4569d8295194c06ec23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2f9a31f1f40853d29bba08468529dc4d91f1930e63924d9eb7d399b8e25fb88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9860a29d5d77a55fc39fc6dac86c6ab5e70e52a4695c3d3080ff2e12741b96ac"
    sha256 cellar: :any_skip_relocation, ventura:        "5f778d9ca231ce35a27780a8938c5c7e39d99b0b87c28149aa88ed65d8796bee"
    sha256 cellar: :any_skip_relocation, monterey:       "2a21de175f4da1d57fcb045ecf3c86c6adcf6e0e1ec8eb4b7f087f37a2e4c1f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "17669af656913855f337c498faa9e4c925fed4e54c1073ba326bdc6fba92164c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c36ef206de57b4b1b02626e5e15ee2bee8777ac43d6ba37563fab2b5e51175b"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "metricbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "mg.Deps(CollectDocs, FieldsDocs)", ""

      system "mage", "-v", "build"
      ENV.deparallelize
      system "mage", "-v", "update"

      (etc/"metricbeat").install Dir["metricbeat.*", "fields.yml", "modules.d"]
      (libexec/"bin").install "metricbeat"
      prefix.install "build/kibana"
    end

    (bin/"metricbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/metricbeat \
        --path.config #{etc}/metricbeat \
        --path.data #{var}/lib/metricbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/metricbeat \
        "$@"
    EOS

    chmod 0555, bin/"metricbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"metricbeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin/"metricbeat"
  end

  test do
    (testpath/"config/metricbeat.yml").write <<~EOS
      metricbeat.modules:
      - module: system
        metricsets: ["load"]
        period: 1s
      output.file:
        enabled: true
        path: #{testpath}/data
        filename: metricbeat
    EOS

    (testpath/"logs").mkpath
    (testpath/"data").mkpath

    fork do
      exec bin/"metricbeat", "-path.config", testpath/"config", "-path.data",
                             testpath/"data"
    end

    sleep 15

    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"

    (testpath/"data").glob("metricbeat-*.ndjson") do |file|
      s = JSON.parse(file.read.lines.first.chomp)
      assert_match "metricbeat", s["@metadata"]["beat"]
    end
  end
end
