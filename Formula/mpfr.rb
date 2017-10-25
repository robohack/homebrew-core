class Mpfr < Formula
  desc "C library for multiple-precision floating-point computations"
  homepage "http://www.mpfr.org/"
  url "https://ftp.gnu.org/gnu/mpfr/mpfr-3.1.6.tar.xz"
  mirror "https://ftpmirror.gnu.org/mpfr/mpfr-3.1.6.tar.xz"
  sha256 "7a62ac1a04408614fccdc506e4844b10cf0ad2c2b1677097f8f35d3a1344a950"

  bottle do
    cellar :any
    sha256 "ff2f02099a071f15f73ac776026c30e33bb43f9b389b19b87f575cd9bd4ac0bb" => :high_sierra
    sha256 "a8f99b5754688942fdb644a6c00f37d3c4311bcd4477f58b6dc356b0f32ee29d" => :sierra
    sha256 "853b75811634d2d0f10772dd68f0b81b46af29dab53588edcac1cd2bebc16a3c" => :el_capitan
    sha256 "e1687f23e9e15cad619bd857ecb06de89add3f9f392e426484c10daa0a4c7ec0" => :yosemite
  end

  depends_on "gmp"

  fails_with :clang do
    build 421
    cause <<~EOS
      clang build 421 segfaults while building in superenv;
      see https://github.com/Homebrew/homebrew/issues/15061
    EOS
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mpfr.h>
      #include <math.h>
      #include <stdlib.h>

      int main() {
        mpfr_t x, y;
        mpfr_inits2 (256, x, y, NULL);
        mpfr_set_ui (x, 2, MPFR_RNDN);
        mpfr_root (y, x, 2, MPFR_RNDN);
        mpfr_pow_si (x, y, 4, MPFR_RNDN);
        mpfr_add_si (y, x, -4, MPFR_RNDN);
        mpfr_abs (y, y, MPFR_RNDN);
        if (fabs(mpfr_get_d (y, MPFR_RNDN)) > 1.e-30) abort();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-L#{Formula["gmp"].opt_lib}",
                   "-lgmp", "-lmpfr", "-o", "test"
    system "./test"
  end
end
