class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.18.2.tar.gz"
  sha256 "4e055f92f3d5123d415f6f3ccf5ede9989f16d9e1f71cc7998ad244a3d3562f4"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "ada91b1d5e0c63e1be55688050ba63251b171fc6ce64781e2a688ec96d93b243"
    sha256 arm64_monterey: "01950e650dc9556ce1b11e7665aac287899b712182bab0252146ba0cd94b25c2"
    sha256 arm64_big_sur:  "ab6e44394432ce7e272d710d3b693dc618a071326a728becd641c980b672eab4"
    sha256 ventura:        "0a5fb06dc2e07cb9202db7ad824d39f91363c409f26095e5ec6c4f927b828ec0"
    sha256 monterey:       "cd40b2daa326e8f285665a617ccb6418735902332dc48d0fcb9d43f57882dd4d"
    sha256 big_sur:        "8bef2d618c5b327880509fa77ef67b830b455303f870811e9e85a55e4813143c"
    sha256 x86_64_linux:   "e2280983209caa4b708a28353c385b4ee383347a6565f6d14b3d5fa56cfe40b1"
  end

  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "python@3.11"
  depends_on "scalapack"
  depends_on "suite-sparse"

  uses_from_macos "python" => :build

  conflicts_with "petsc", because: "petsc must be installed with either real or complex support, not both"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-debugging=0",
                          "--with-scalar-type=complex",
                          "--with-x=0",
                          "--CC=mpicc",
                          "--CXX=mpicxx",
                          "--F77=mpif77",
                          "--FC=mpif90",
                          "MAKEFLAGS=$MAKEFLAGS"
    system "make", "all"
    system "make", "install"

    # Avoid references to Homebrew shims
    rm_f lib/"petsc/conf/configure-hash"

    if OS.mac? || File.foreach("#{lib}/petsc/conf/petscvariables").any? { |l| l[Superenv.shims_path.to_s] }
      inreplace lib/"petsc/conf/petscvariables", "#{Superenv.shims_path}/", ""
    end
  end

  test do
    flags = %W[-I#{include} -L#{lib} -lpetsc]
    flags << "-Wl,-rpath,#{lib}" if OS.linux?
    system "mpicc", share/"petsc/examples/src/ksp/ksp/tutorials/ex1.c", "-o", "test", *flags
    output = shell_output("./test")
    # This PETSc example prints several lines of output. The last line contains
    # an error norm, expected to be small.
    line = output.lines.last
    assert_match(/^Norm of error .+, Iterations/, line, "Unexpected output format")
    error = line.split[3].to_f
    assert (error >= 0.0 && error < 1.0e-13), "Error norm too large"
  end
end
