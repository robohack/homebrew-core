class Octave < Formula
  desc "High-level interpreted language for numerical computing"
  homepage "https://www.gnu.org/software/octave/index.html"
  url "https://ftp.gnu.org/gnu/octave/octave-4.2.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/octave/octave-4.2.1.tar.gz"
  sha256 "80c28f6398576b50faca0e602defb9598d6f7308b0903724442c2a35a605333b"
  revision 6

  bottle do
    rebuild 1
    sha256 "e4875e85815642672a9c7715283ea9d4c5fbc6d61c63eeb842780a86df38b52b" => :high_sierra
    sha256 "4adc5c84a3eada5c44a65daabb7fdfefae6a3e492f3ba02b17a9205f942063f8" => :sierra
    sha256 "06d173b089910c87709f1783b9d8fad8f624e4cbd2bd8cf93d39debd65ca1299" => :el_capitan
    sha256 "ba00325662c815e50d533ba964051dc17441915f2c4c74944f95e410d0b6099a" => :yosemite
  end

  head do
    url "https://hg.savannah.gnu.org/hgweb/octave", :branch => "default", :using => :hg
    depends_on :hg => :build
    depends_on "bison" => :build
    depends_on "icoutils" => :build
    depends_on "librsvg" => :build
    depends_on "sundials"
  end

  # Complete list of dependencies at https://wiki.octave.org/Building
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "gnu-sed" => :build # https://lists.gnu.org/archive/html/octave-maintainers/2016-09/msg00193.html
  depends_on "pkg-config" => :build
  depends_on :fortran
  depends_on "arpack"
  depends_on "epstool"
  depends_on "fftw"
  depends_on "fig2dev"
  depends_on "fltk"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "gl2ps"
  depends_on "glpk"
  depends_on "gnuplot"
  depends_on "graphicsmagick"
  depends_on "hdf5"
  depends_on "libsndfile"
  depends_on "libtool" => :run
  depends_on "pcre"
  depends_on "portaudio"
  depends_on "pstoedit"
  depends_on "qhull"
  depends_on "qrupdate"
  depends_on "readline"
  depends_on "suite-sparse"
  depends_on "veclibfort"
  depends_on :java => ["1.6+", :optional]

  # Dependencies use Fortran, leading to spurious messages about GCC
  cxxstdlib_check :skip

  def install
    if build.stable?
      # Remove for > 4.2.1
      # Remove inline keyword on file_stat destructor which breaks macOS
      # compilation (bug #50234).
      # Upstream commit from 24 Feb 2017 https://hg.savannah.gnu.org/hgweb/octave/rev/a6e4157694ef
      inreplace "liboctave/system/file-stat.cc",
        "inline file_stat::~file_stat () { }", "file_stat::~file_stat () { }"
      inreplace "scripts/java/module.mk",
        "-source 1.3 -target 1.3", "" # necessary for java >1.8
    end

    # Default configuration passes all linker flags to mkoctfile, to be
    # inserted into every oct/mex build. This is unnecessary and can cause
    # cause linking problems.
    inreplace "src/mkoctfile.in.cc", /%OCTAVE_CONF_OCT(AVE)?_LINK_(DEPS|OPTS)%/, '""'

    # allow for recent Oracle Java (>=1.8) without requiring the old Apple Java 1.6
    # this is more or less the same as in https://savannah.gnu.org/patch/index.php?9439
    inreplace "libinterp/octave-value/ov-java.cc",
      "#if ! defined (__APPLE__) && ! defined (__MACH__)", "#if 1" # treat mac's java like others
    inreplace "configure.ac",
      "-framework JavaVM", "" # remove framework JavaVM as it requires Java 1.6 after build

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-link-all-dependencies
      --enable-shared
      --disable-static
      --disable-docs
      --without-OSMesa
      --without-qt
      --with-hdf5-includedir=#{Formula["hdf5"].opt_include}
      --with-hdf5-libdir=#{Formula["hdf5"].opt_lib}
      --with-x=no
      --with-blas=-L#{Formula["veclibfort"].opt_lib}\ -lvecLibFort
      --with-portaudio
      --with-sndfile
    ]

    args << "--disable-java" if build.without? "java"

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "all"
    system "make", "install"
  end

  test do
    system bin/"octave", "--eval", "(22/7 - pi)/pi"
    # This is supposed to crash octave if there is a problem with veclibfort
    system bin/"octave", "--eval", "single ([1+i 2+i 3+i]) * single ([ 4+i ; 5+i ; 6+i])"
    # Test java bindings: check if javaclasspath is working, return error if not
    system bin/"octave", "--eval", "try; javaclasspath; catch; quit(1); end;" if build.with? "java"
  end
end
