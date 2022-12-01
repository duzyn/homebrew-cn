class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (real)"
  homepage "https://petsc.org/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.18.2.tar.gz"
  sha256 "4e055f92f3d5123d415f6f3ccf5ede9989f16d9e1f71cc7998ad244a3d3562f4"
  license "BSD-2-Clause"

  livecheck do
    url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/"
    regex(/href=.*?petsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "7e9e9f25f9651cf77bedf7628bf355599e6c0ddad56f70343edcf9099fe67317"
    sha256 arm64_monterey: "18afb6110dd79f015f5a28e23896368e38f55f6ba14d2cf457f40bf02aa83629"
    sha256 arm64_big_sur:  "a6ec6b423f0696dc8deb9bb48c5379ebb571ee65655ef866775677f4c3dc0429"
    sha256 ventura:        "f3c083f827adc95fa4fd92c1acabdd5e245e5c767ecdef1bbcb87e4cb28f8087"
    sha256 monterey:       "df309e0307682be772d1a3a943c6d0a57852b2d18a1fd83edb0f1ab86996cd64"
    sha256 big_sur:        "6698b93e48aa77b7728bca262718427499720e92c4ea526b3c1a103a63f95d17"
    sha256 x86_64_linux:   "1d4c43eb6fa9f7f1de73aaaacd45a8025c4801210c5c00f86cb946d2b4f55b9e"
  end

  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "scalapack"
  depends_on "suite-sparse"

  uses_from_macos "python" => :build

  conflicts_with "petsc-complex", because: "petsc must be installed with either real or complex support, not both"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-debugging=0",
                          "--with-scalar-type=real",
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
    system "mpicc", pkgshare/"examples/src/ksp/ksp/tutorials/ex1.c", "-o", "test", *flags
    output = shell_output("./test")
    # This PETSc example prints several lines of output. The last line contains
    # an error norm, expected to be small.
    line = output.lines.last
    assert_match(/^Norm of error .+, Iterations/, line, "Unexpected output format")
    error = line.split[3].to_f
    assert (error >= 0.0 && error < 1.0e-13), "Error norm too large"
  end
end
