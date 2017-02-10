class Fkmc < Formula
  desc "Falicov Kimball Monte Carlo"
  homepage "https://github.com/aeantipov/fk_mc"
  url "https://github.com/aeantipov/fk_mc/archive/v0.6.tar.gz"
  sha256 "983eca963ada388e366bb8cf3a700bde7a3efe96089cb9a6c288cb5ab088f660"
  revision 1
  head "https://github.com/aeantipov/fk_mc.git"

  option "with-test",   "Build and run shipped tests"
  option "with-doc",    "Build documentation"

  depends_on "cmake" => [:build]
  depends_on :mpi => [:cc, :cxx, :recommended]
  depends_on "aeantipov/aeantipov/gftools"
  depends_on "homebrew/science/alpscore"
  depends_on "arpack"
  depends_on "boost" => ["c++11", "with-mpi"]
  depends_on "fftw"

  def install
    ENV.cxx11
    args = std_cmake_args
    args.delete "-DCMAKE_BUILD_TYPE=None"
    args << "-DCMAKE_BUILD_TYPE=Release"

    args << ("-DTesting=" + ((build.with? "test") ? "ON" : "OFF"))

    mkdir "tmp" do
      args << ".."
      system "cmake", *args
      system "make"
      system "make", "test" if build.with? "test"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/fk_mc_cubic1d"
  end
end
