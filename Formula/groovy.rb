class Groovy < Formula
  desc "Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-binary-4.0.7.zip"
  sha256 "efae81322fc28b63f30edb27aa308600f08bda73fb63b51c92a89825be87fade"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/"
    regex(/href=.*?apache-groovy-binary[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71c9fff296f7a2206c8dc42e36d6913cf4b3aabecc790da092b4342fd779d155"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dba7d5a36e6f54db64875643ab3d6db155e476db532d40ed0340f1cc91f768c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2381ad6d7ce0c5b9c1cb1dabd37a879cbf086b64c71e9fd32795c50876b8d2d"
    sha256 cellar: :any_skip_relocation, ventura:        "40ae8ac2c0c3101beee86b3b7b20d2c193a711f97a165310c2aaf420a7ab79dd"
    sha256 cellar: :any_skip_relocation, monterey:       "456fc7ad52a991a869bc2dd2bb01b3595b178f1572753fb0af54fa40f0a62cbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "39e26d3cf79852279dbb2ef65d46ee87522f9299e44bda910bd414f287e5b97e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23004194b1ab7d1b19fef4950ad261e6779b93ade33a02f961b4b92f77e94a3a"
  end

  depends_on "openjdk"

  on_macos do
    # Temporary build dependencies for compiling jansi-native
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "maven" => :build

    # jansi-native is used to build native binary to support Apple Silicon.
    # Source version is from jline-2.14.6 -> jansi-1.12 -> jansi-native-1.6
    # TODO: Remove once updated to jline-3.x: https://issues.apache.org/jira/browse/GROOVY-8162
    resource "jansi-native" do
      url "https://github.com/fusesource/jansi-native/archive/refs/tags/jansi-native-1.6.tar.gz"
      sha256 "f4075ad012c9ed79eaa8d3240d869e10d94ca8b130f3e7dac2ba3978dce0fb21"

      # Update pom.xml to replace unsupported Java 6 source and to disable universal binary
      patch :DATA
    end
  end

  conflicts_with "groovysdk", because: "both install the same binaries"

  def install
    if OS.mac?
      jline_jar = buildpath/"lib/jline-2.14.6.jar"
      resource("jansi-native").stage do
        system "mvn", "-Dplatform=osx", "prepare-package"
        system "zip", "-d", jline_jar, "META-INF/native/*"
        system "jar", "-uvf", jline_jar,
                      "-C", "target/generated-sources/hawtjni/lib",
                      "META-INF/native/osx64/libjansi.jnilib"
      end
    end

    # Don't need Windows files.
    rm_f Dir["bin/*.bat"]

    libexec.install "bin", "conf", "lib"
    bin.install Dir["#{libexec}/bin/*"] - ["#{libexec}/bin/groovy.ico"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      You should set GROOVY_HOME:
        export GROOVY_HOME=#{opt_libexec}
    EOS
  end

  test do
    output = shell_output("#{bin}/grape install org.activiti activiti-engine 5.16.4")
    assert_match "found org.activiti#activiti-engine;5.16.4", output
    assert_match "65536\n===> null\n", pipe_output("#{bin}/groovysh", "println 64*1024\n:exit\n")
  end
end

__END__
diff --git a/pom.xml b/pom.xml
index 369cc8c..6dbac6f 100644
--- a/pom.xml
+++ b/pom.xml
@@ -151,8 +151,8 @@
         <groupId>org.apache.maven.plugins</groupId>
         <artifactId>maven-compiler-plugin</artifactId>
         <configuration>
-          <source>1.5</source>
-          <target>1.5</target>
+          <source>1.7</source>
+          <target>1.7</target>
         </configuration>
       </plugin>
       
@@ -306,35 +306,5 @@
       </build>
     </profile>
     
-
-    <!-- Profile which enables Universal binaries on OS X -->
-    <profile>
-      <id>mac</id>
-      <activation>
-        <os><family>mac</family></os>
-      </activation>
-      <build>
-        <plugins>
-          <plugin>
-            <groupId>org.fusesource.hawtjni</groupId>
-            <artifactId>maven-hawtjni-plugin</artifactId>
-            <configuration>
-              <osgiPlatforms>
-                <osgiPlatform>osname=MacOS;processor=x86-64</osgiPlatform>
-                <osgiPlatform>osname=MacOS;processor=x86</osgiPlatform>
-                <osgiPlatform>osname=MacOS;processor=PowerPC</osgiPlatform>
-                <osgiPlatform>*</osgiPlatform>
-              </osgiPlatforms>
-              <configureArgs>
-                <arg>--with-universal</arg>
-              </configureArgs>
-              <platform>osx</platform>
-            </configuration>
-          </plugin>
-        </plugins>
-      </build>
-    </profile>
-    
-    
   </profiles>
 </project>
