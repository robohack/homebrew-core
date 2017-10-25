class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "http://primesieve.org/"
  url "https://github.com/kimwalisch/primesieve/archive/v6.2.tar.gz"
  sha256 "c4d1c358ab95b370dcac317fe1820e41d60460b22e450359ebc4bdd507bb2547"

  bottle do
    cellar :any
    sha256 "f03b9925f3e732b47989196b1a09ce1cefcd45c3181516630bdadd6de1549084" => :high_sierra
    sha256 "6497a4d9e833a240271d2934c9726a36e971d08b1d5a0097901eb2e9a2d8bb1f" => :sierra
    sha256 "b4d46e227db20da387247c244bf9a13dfe1c23b19b922cbcf20a4b47994eb059" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/primesieve", "100", "--count", "--print"
  end
end
