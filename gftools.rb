class Gftools < Formula
  desc "Greens Functions DSL"
  homepage "http://github.com/aeantipov/gftools"
  url "https://github.com/aeantipov/gftools/archive/1.1.2.tar.gz"
  sha256 "6531eec8b240f157e080293b48eca09e87a2cb1314d57c3139d62a6db5d576ca"
  revision 1
  head "https://github.com/aeantipov/gftools.git", :using => :git

  option "with-test",   "Build and run shipped tests"
  option "with-doc",    "Build documentation"

  depends_on "cmake" => :build
  depends_on "eigen" 
  depends_on "boost" => ["c++11"]

  def install
    ENV.cxx11
    args = std_cmake_args
    args << ("-DDocumentation=" + ((build.with? "doc") ? "ON" : "OFF"))
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
    #ENV.cxx11
    system "curl","-o","test.cpp","https://raw.githubusercontent.com/aeantipov/gftools/master/example/basic_ops.cpp"
    d1 = %x(brew --prefix eigen)
    args_compile = ["-std=c++11", "-stdlib=libc++", "-I"+d1.chomp+"/include/eigen3",
      "test.cpp", "-o", "test"
    ]
    system ENV.cxx, *args_compile
    system "./test"
  end
end
