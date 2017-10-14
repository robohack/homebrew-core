class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "http://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_38.tar.gz"
  sha256 "3d1dcc6d21d3972c7251990380d6dfa8ac7ac4f89d9392ed101b9fb0e7adda9a"

  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "3689cf4810f948236adf7d09f95ab4989ca57ba84c8c3078882adac2439274c1" => :high_sierra
    sha256 "cfa95bae86eb8a38e64b563e825670b4b40ffd8a71b73cd2ad5a25c98bbb9e60" => :sierra
    sha256 "1358e74feebd3b7c99a459d7420414f58d402ceec43c45f2c726ae735f233150" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on :macos => :el_capitan # needs thread-local storage

  needs :cxx11

  def install
    ENV.cxx11

    system "cmake", ".", *std_cmake_args
    system "make", "install"

    pkgshare.install "test/"
  end

  test do
    system "#{bin}/wasm-opt", "#{pkgshare}/test/passes/O.wast"
    system "#{bin}/asm2wasm", "#{pkgshare}/test/hello_world.asm.js"
  end
end
