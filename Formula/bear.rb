class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.3.9.tar.gz"
  sha256 "9adad7e6a028c2dbce7ddb5515a2804d938a3ab0d1e1f669dd6371c8fd8aa4e4"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "01aeeb567ec5623f17345ceaec813d0ff2bc52389e8c438b257f4a5ae7d65f76" => :high_sierra
    sha256 "d504102efc72abe5b1c7b07e58469237ba26002691f74650b2d2adcadbee796e" => :sierra
    sha256 "b9943598534d2deb9a2cacdc8b831941938ee4e6624661f68595cdb3d72f04b1" => :el_capitan
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/bear", "true"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end
