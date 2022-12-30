class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v2.15.tar.gz"
  sha256 "bceaa85b6eba6df636461ee90aee64493a9a504673860b1efbebae790b6a5bcf"
  license "MIT"
  head "https://github.com/willbryant/kitchen_sync.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "72270a99acb57c8f5f63fc2dd0de4ffdcd5750b155d1ab2e5a751bfdec65039a"
    sha256 cellar: :any,                 arm64_monterey: "00c5f90a86f576cce38ed4decae7ffefaaef76584cc6be0e1cbc4843c74f3b83"
    sha256 cellar: :any,                 arm64_big_sur:  "829c9e1cb5247833dfc517e1fbf13edff93220767089fee9472f1393167a76da"
    sha256 cellar: :any,                 ventura:        "c211e4ce78880536b1d2e80fed160cdb12fcf191d150b96e4ac8795a6457f421"
    sha256 cellar: :any,                 monterey:       "443a9801c2a9f68c98a3290ad020737f8c1f4a75e933d68dbe9c060de3efef53"
    sha256 cellar: :any,                 big_sur:        "8351752c6f632f829f454299d2710d736aa231689451dd7e63c7572a9c33dfc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dab9b6d113c8c392d14069c0fa3c3a215404fe0a87e44853c15b018792003088"
  end

  depends_on "cmake" => :build
  depends_on "libpq"
  depends_on "mysql-client"

  fails_with gcc: "5"

  def install
    system "cmake", ".",
                    "-DMySQL_INCLUDE_DIR=#{Formula["mysql-client"].opt_include}/mysql",
                    "-DMySQL_LIBRARY_DIR=#{Formula["mysql-client"].opt_lib}",
                    "-DPostgreSQL_INCLUDE_DIR=#{Formula["libpq"].opt_include}",
                    "-DPostgreSQL_LIBRARY_DIR=#{Formula["libpq"].opt_lib}",
                    *std_cmake_args

    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/ks --from mysql://b/ --to mysql://d/ 2>&1", 1)

    assert_match "Unknown MySQL server host", output
    assert_match "Kitchen Syncing failed.", output
  end
end
