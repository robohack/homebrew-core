class Konoha < Formula
  desc "Static scripting language with extensible syntax"
  homepage "https://github.com/konoha-project/konoha3"
  url "https://github.com/konoha-project/konoha3/archive/v0.1.tar.gz"
  sha256 "e7d222808029515fe229b0ce1c4e84d0a35b59fce8603124a8df1aeba06114d3"
  revision 2

  bottle do
    sha256 "02bc662f7d21b3a4a0de5fe3ab0687ad686ca7dc67fe22374abd75a34a33f78b" => :high_sierra
    sha256 "a0b2f23dfd7fac28740fdc3dbe0d4ea1fe832fd8902f8d71eae2546067107102" => :sierra
    sha256 "7c839e3fe6f917798f2724f3acb3cc530f5373394a6e3f74e0d59d991ac7a9d5" => :el_capitan
  end

  head do
    url "https://github.com/konoha-project/konoha3.git"

    depends_on "openssl"
  end

  option "with-test", "Verify the build with make test (May currently fail)"

  deprecated_option "tests" => "with-test"

  depends_on "cmake" => :build
  depends_on :mpi => [:cc, :cxx]
  depends_on "pcre"
  depends_on "json-c"
  depends_on "sqlite"
  depends_on "mecab" if MacOS.version >= :mountain_lion
  depends_on :python if MacOS.version <= :snow_leopard # for python glue code

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      # `make test` currently fails. Reported upstream:
      # https://github.com/konoha-project/konoha3/issues/438
      system "make", "test" if build.with? "test"
      system "make", "install"
    end
  end

  test do
    (testpath/"test").write "System.p(\"Hello World!\");"
    output = shell_output("#{bin}/konoha #{testpath}/test")
    assert_match "(test:1) Hello World!", output
  end
end
