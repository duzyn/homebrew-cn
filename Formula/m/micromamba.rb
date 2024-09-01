class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  stable do
    url "https://mirror.ghproxy.com/https://github.com/mamba-org/mamba/archive/refs/tags/micromamba-1.5.9.tar.gz"
    sha256 "9ac3fb39fffb9a57a7cc102e885cf49d9bac47ec6446c7d8c850f6fc87b26af6"

    # fmt 11 compatibility
    # https://github.com/mamba-org/mamba/commit/4fbd22a9c0e136cf59a4f73fe7c34019a4f86344
    # https://github.com/mamba-org/mamba/commit/d0d7eea49a9083c15aa73c58645abc93549f6ddd
    patch :DATA
  end

  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f6ab67da2075c6ece2233330975ba8f6bb0198db009c8310c6c2ac35a3715d76"
    sha256 cellar: :any,                 arm64_ventura:  "deb26d2fe125a58998a0937e8ea3991d4b3eda32c9f83143d8f588232a58874f"
    sha256 cellar: :any,                 arm64_monterey: "b47eb2f846abeb0cafb0357bd445f5c2205919e7d0a046cd5d9cb40f1817ba30"
    sha256 cellar: :any,                 sonoma:         "7645a88481eddb678e658c74e88485b50d91468910f26407446031039022708f"
    sha256 cellar: :any,                 ventura:        "d7da915cb1e55d78ba1503df36e27e3c2f2dc47813773c700723619127559548"
    sha256 cellar: :any,                 monterey:       "aed31e322d38c3891cc1de157eaea8bb11a0c583b776aaf64d65652fd1d9f0d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f346e5d3f6e55e3668e80b6ab5a3226c38e3f41b8a245736d1115eec0b81a16"
  end

  depends_on "cli11" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "spdlog" => :build
  depends_on "tl-expected" => :build

  depends_on "fmt"
  depends_on "libsolv"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "reproc"
  depends_on "xz"
  depends_on "yaml-cpp"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl", since: :ventura # uses curl_url_strerror, available since curl 7.80.0
  uses_from_macos "krb5"
  uses_from_macos "libarchive", since: :monterey
  uses_from_macos "zlib"

  resource "libarchive-headers" do
    on_monterey :or_newer do
      url "https://mirror.ghproxy.com/https://github.com/apple-oss-distributions/libarchive/archive/refs/tags/libarchive-121.40.3.tar.gz"
      sha256 "bb972360581fe5326ef5d313ec51579b1c1a4c8a6f20a5068851032a0fa74f33"
    end
  end

  def install
    args = %W[
      -DBUILD_LIBMAMBA=ON
      -DBUILD_SHARED=ON
      -DBUILD_MICROMAMBA=ON
      -DMICROMAMBA_LINKAGE=DYNAMIC
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    if OS.mac? && MacOS.version >= :monterey
      resource("libarchive-headers").stage do
        cd "libarchive/libarchive" do
          (buildpath/"homebrew/include").install "archive.h", "archive_entry.h"
        end
      end
      args << "-DLibArchive_INCLUDE_DIR=#{buildpath}/homebrew/include"
      ENV.append_to_cflags "-I#{buildpath}/homebrew/include"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      Please run the following to setup your shell:
        #{opt_bin}/micromamba shell init -s <your-shell> -p ~/micromamba
      and restart your terminal.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micromamba --version").strip

    python_version = "3.9.13"
    system bin/"micromamba", "create", "-n", "test", "python=#{python_version}", "-y", "-c", "conda-forge"
    assert_match "Python #{python_version}", shell_output("#{bin}/micromamba run -n test python --version").strip
  end
end

__END__
diff --git a/libmamba/include/mamba/core/mamba_fs.hpp b/libmamba/include/mamba/core/mamba_fs.hpp
index 65c515c..0f158a8 100644
--- a/libmamba/include/mamba/core/mamba_fs.hpp
+++ b/libmamba/include/mamba/core/mamba_fs.hpp
@@ -1379,7 +1379,7 @@ struct fmt::formatter<::fs::u8path>
     }
 
     template <class FormatContext>
-    auto format(const ::fs::u8path& path, FormatContext& ctx)
+    auto format(const ::fs::u8path& path, FormatContext& ctx) const
     {
         return fmt::format_to(ctx.out(), "'{}'", path.string());
     }
diff --git a/libmamba/include/mamba/specs/version.hpp b/libmamba/include/mamba/specs/version.hpp
index 4272f18..cf69cd4 100644
--- a/libmamba/include/mamba/specs/version.hpp
+++ b/libmamba/include/mamba/specs/version.hpp
@@ -168,7 +168,7 @@ struct fmt::formatter<mamba::specs::VersionPartAtom>
     }
 
     template <class FormatContext>
-    auto format(const ::mamba::specs::VersionPartAtom atom, FormatContext& ctx)
+    auto format(const ::mamba::specs::VersionPartAtom atom, FormatContext& ctx) const
     {
         return fmt::format_to(ctx.out(), "{}{}", atom.numeral(), atom.literal());
     }
@@ -188,7 +188,7 @@ struct fmt::formatter<mamba::specs::Version>
     }
 
     template <class FormatContext>
-    auto format(const ::mamba::specs::Version v, FormatContext& ctx)
+    auto format(const ::mamba::specs::Version v, FormatContext& ctx) const
     {
         auto out = ctx.out();
         if (v.epoch() != 0)
diff --git a/libmamba/src/api/install.cpp b/libmamba/src/api/install.cpp
index c749b24..672ee29 100644
--- a/libmamba/src/api/install.cpp
+++ b/libmamba/src/api/install.cpp
@@ -9,6 +9,7 @@
 #include <fmt/color.h>
 #include <fmt/format.h>
 #include <fmt/ostream.h>
+#include <fmt/ranges.h>
 #include <reproc++/run.hpp>
 #include <reproc/reproc.h>
 
diff --git a/libmamba/src/core/context.cpp b/libmamba/src/core/context.cpp
index 5d1b65b..6068f75 100644
--- a/libmamba/src/core/context.cpp
+++ b/libmamba/src/core/context.cpp
@@ -8,6 +8,7 @@
 
 #include <fmt/format.h>
 #include <fmt/ostream.h>
+#include <fmt/ranges.h>
 #include <spdlog/pattern_formatter.h>
 #include <spdlog/sinks/stdout_color_sinks.h>
 #include <spdlog/spdlog.h>
diff --git a/libmamba/src/core/query.cpp b/libmamba/src/core/query.cpp
index d1ac04c..017522a 100644
--- a/libmamba/src/core/query.cpp
+++ b/libmamba/src/core/query.cpp
@@ -13,6 +13,7 @@
 #include <fmt/color.h>
 #include <fmt/format.h>
 #include <fmt/ostream.h>
+#include <fmt/ranges.h>
 #include <solv/evr.h>
 #include <spdlog/spdlog.h>
 
diff --git a/libmamba/src/core/run.cpp b/libmamba/src/core/run.cpp
index ec84ed5..5584cf5 100644
--- a/libmamba/src/core/run.cpp
+++ b/libmamba/src/core/run.cpp
@@ -15,6 +15,7 @@
 #include <fmt/color.h>
 #include <fmt/format.h>
 #include <fmt/ostream.h>
+#include <fmt/ranges.h>
 #include <nlohmann/json.hpp>
 #include <reproc++/run.hpp>
 #include <spdlog/spdlog.h>
diff --git a/libmamba/tests/src/doctest-printer/array.hpp b/libmamba/tests/src/doctest-printer/array.hpp
index 123ffff..6b54468 100644
--- a/libmamba/tests/src/doctest-printer/array.hpp
+++ b/libmamba/tests/src/doctest-printer/array.hpp
@@ -8,6 +8,7 @@
 
 #include <doctest/doctest.h>
 #include <fmt/format.h>
+#include <fmt/ranges.h>
 
 namespace doctest
 {
diff --git a/libmamba/tests/src/doctest-printer/vector.hpp b/libmamba/tests/src/doctest-printer/vector.hpp
index 0eb5cf0..b397f9e 100644
--- a/libmamba/tests/src/doctest-printer/vector.hpp
+++ b/libmamba/tests/src/doctest-printer/vector.hpp
@@ -8,6 +8,7 @@
 
 #include <doctest/doctest.h>
 #include <fmt/format.h>
+#include <fmt/ranges.h>
 
 namespace doctest
 {
diff --git a/micromamba/src/run.cpp b/micromamba/src/run.cpp
index c3af4ea..7c561af 100644
--- a/micromamba/src/run.cpp
+++ b/micromamba/src/run.cpp
@@ -10,6 +10,7 @@
 
 #include <fmt/color.h>
 #include <fmt/format.h>
+#include <fmt/ranges.h>
 #include <nlohmann/json.hpp>
 #include <reproc++/run.hpp>
 #include <spdlog/spdlog.h>
diff --git a/libmamba/src/core/package_info.cpp b/libmamba/src/core/package_info.cpp
index 00d80e8..8726d1c 100644
--- a/libmamba/src/core/package_info.cpp
+++ b/libmamba/src/core/package_info.cpp
@@ -11,6 +11,7 @@
 #include <tuple>
 
 #include <fmt/format.h>
+#include <fmt/ranges.h>
 
 #include "mamba/core/package_info.hpp"
 #include "mamba/specs/archive.hpp"
diff --git a/libmamba/tests/src/core/test_satisfiability_error.cpp b/libmamba/tests/src/core/test_satisfiability_error.cpp
index bb33724..081367b 100644
--- a/libmamba/tests/src/core/test_satisfiability_error.cpp
+++ b/libmamba/tests/src/core/test_satisfiability_error.cpp
@@ -11,6 +11,7 @@
 
 #include <doctest/doctest.h>
 #include <fmt/format.h>
+#include <fmt/ranges.h>
 #include <nlohmann/json.hpp>
 #include <solv/solver.h>
 
diff --git a/libmambapy/src/main.cpp b/libmambapy/src/main.cpp
index 94d38ce..0e82ad8 100644
--- a/libmambapy/src/main.cpp
+++ b/libmambapy/src/main.cpp
@@ -7,6 +7,7 @@
 #include <stdexcept>
 
 #include <fmt/format.h>
+#include <fmt/ranges.h>
 #include <nlohmann/json.hpp>
 #include <pybind11/functional.h>
 #include <pybind11/iostream.h>
