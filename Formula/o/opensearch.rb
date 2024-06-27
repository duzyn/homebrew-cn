class Opensearch < Formula
  desc "Open source distributed and RESTful search engine"
  homepage "https://github.com/opensearch-project/OpenSearch"
  url "https://mirror.ghproxy.com/https://github.com/opensearch-project/OpenSearch/archive/refs/tags/2.15.0.tar.gz"
  sha256 "047f0c26ec3ae54f6b0213d7191c346290c9d4ac2b8a6d21b0d947f9d36b83a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7009f5630e705c55d869bac1e8d71ab30c70d022f11a879a72a5a82b0524c3ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff23a724d03f9b84fb212fd339b28c5e94ba48ff4f621766f54a520bfce769ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c49d88837a1f367f7cf14679fc736305e1718151a73cfff2cbdd52f771784904"
    sha256 cellar: :any_skip_relocation, sonoma:         "decd137e07a6c3ac8edae50e87814a8a8eaa83ba779bc911c2bff9952d4b4abf"
    sha256 cellar: :any_skip_relocation, ventura:        "cf920fb2a2bda3823e9e97aa521abc0507be9ac2cdf0f7808d69f0c1a9c5e065"
    sha256 cellar: :any_skip_relocation, monterey:       "26f99356e867594f9e3293f671822bec39f064b5bd7d4a3eea622a630257d5ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "433074e2aa4a053ee92018502ddd37bf527b27c6353a02feb810b4343d2760da"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  # upstream patch PR, https://github.com/opensearch-project/OpenSearch/pull/14182
  patch :DATA

  def install
    platform = OS.kernel_name.downcase
    platform += "-arm64" if Hardware::CPU.arm?
    system "gradle", "-Dbuild.snapshot=false", ":distribution:archives:no-jdk-#{platform}-tar:assemble"

    mkdir "tar" do
      # Extract the package to the tar directory
      system "tar", "--strip-components=1", "-xf",
        Dir["../distribution/archives/no-jdk-#{platform}-tar/build/distributions/opensearch-*.tar.gz"].first

      # Install into package directory
      libexec.install "bin", "lib", "modules"

      # Set up Opensearch for local development:
      inreplace "config/opensearch.yml" do |s|
        # 1. Give the cluster a unique name
        s.gsub!(/#\s*cluster\.name: .*/, "cluster.name: opensearch_homebrew")

        # 2. Configure paths
        s.sub!(%r{#\s*path\.data: /path/to.+$}, "path.data: #{var}/lib/opensearch/")
        s.sub!(%r{#\s*path\.logs: /path/to.+$}, "path.logs: #{var}/log/opensearch/")
      end

      inreplace "config/jvm.options", %r{logs/gc.log}, "#{var}/log/opensearch/gc.log"

      # add placeholder to avoid removal of empty directory
      touch "config/jvm.options.d/.keepme"

      # Move config files into etc
      (etc/"opensearch").install Dir["config/*"]
    end

    inreplace libexec/"bin/opensearch-env",
              "if [ -z \"$OPENSEARCH_PATH_CONF\" ]; then OPENSEARCH_PATH_CONF=\"$OPENSEARCH_HOME\"/config; fi",
              "if [ -z \"$OPENSEARCH_PATH_CONF\" ]; then OPENSEARCH_PATH_CONF=\"#{etc}/opensearch\"; fi"

    bin.install libexec/"bin/opensearch",
                libexec/"bin/opensearch-keystore",
                libexec/"bin/opensearch-plugin",
                libexec/"bin/opensearch-shard"
    bin.env_script_all_files(libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix)
  end

  def post_install
    # Make sure runtime directories exist
    (var/"lib/opensearch").mkpath
    (var/"log/opensearch").mkpath
    ln_s etc/"opensearch", libexec/"config" unless (libexec/"config").exist?
    (var/"opensearch/plugins").mkpath
    ln_s var/"opensearch/plugins", libexec/"plugins" unless (libexec/"plugins").exist?
    (var/"opensearch/extensions").mkpath
    ln_s var/"opensearch/extensions", libexec/"extensions" unless (libexec/"extensions").exist?
    # fix test not being able to create keystore because of sandbox permissions
    system bin/"opensearch-keystore", "create" unless (etc/"opensearch/opensearch.keystore").exist?
  end

  def caveats
    <<~EOS
      Data:    #{var}/lib/opensearch/
      Logs:    #{var}/log/opensearch/opensearch_homebrew.log
      Plugins: #{var}/opensearch/plugins/
      Config:  #{etc}/opensearch/
    EOS
  end

  service do
    run opt_bin/"opensearch"
    working_dir var
    log_path var/"log/opensearch.log"
    error_log_path var/"log/opensearch.log"
  end

  test do
    port = free_port
    (testpath/"data").mkdir
    (testpath/"logs").mkdir
    fork do
      exec bin/"opensearch", "-Ehttp.port=#{port}",
                             "-Epath.data=#{testpath}/data",
                             "-Epath.logs=#{testpath}/logs"
    end
    sleep 60
    output = shell_output("curl -s -XGET localhost:#{port}/")
    assert_equal "opensearch", JSON.parse(output)["version"]["distribution"]

    system "#{bin}/opensearch-plugin", "list"
  end
end

__END__
diff --git a/buildSrc/src/main/java/org/opensearch/gradle/info/GlobalBuildInfoPlugin.java b/buildSrc/src/main/java/org/opensearch/gradle/info/GlobalBuildInfoPlugin.java
index 448ba8a..669a67e 100644
--- a/buildSrc/src/main/java/org/opensearch/gradle/info/GlobalBuildInfoPlugin.java
+++ b/buildSrc/src/main/java/org/opensearch/gradle/info/GlobalBuildInfoPlugin.java
@@ -199,7 +199,7 @@ public class GlobalBuildInfoPlugin implements Plugin<Project> {
     }

     private JvmInstallationMetadata getJavaInstallation(File javaHome) {
-        final InstallationLocation location = new InstallationLocation(javaHome, "Java home");
+        final InstallationLocation location = InstallationLocation.userDefined(javaHome, "Java home");

         try {
             try {
