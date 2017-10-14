class GnuplotAT4 < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/4.6.7/gnuplot-4.6.7.tar.gz"
  sha256 "26d4d17a00e9dcf77a4e64a28a3b2922645b8bbfe114c0afd2b701ac91235980"
  revision 1

  bottle do
    sha256 "858c52906786fc159c6990adac2a3fb871a9c477145aa2b5d063fbe9016943d4" => :high_sierra
    sha256 "6cd2fac81f5d126176e64b4930419fb5c08d871c23241d357bcb960f0f7fc66c" => :sierra
    sha256 "05c8929edada3b90266c4cb44ef4d69861fa6883cf7b8121f66089f148506875" => :el_capitan
    sha256 "2c56072a9b684840d6255ac2652a3b9fd87b2f5b115e471e5981ff33a3e4e54c" => :yosemite
  end

  keg_only :versioned_formula

  option "with-pdflib-lite", "Build the PDF terminal using pdflib-lite"
  option "with-wxmac", "Build the wxWidgets terminal using pango"
  option "with-cairo", "Build the Cairo based terminals"
  option "without-lua", "Build without the lua/TikZ terminal"
  option "with-test", "Verify the build with make check (1 min)"
  option "without-emacs", "Do not build Emacs lisp files"
  option "with-aquaterm", "Build with AquaTerm support"
  option "with-x11", "Build with X11 support"

  depends_on "pkg-config" => :build
  depends_on "lua" => :recommended
  depends_on "gd" => :recommended
  depends_on "readline"
  depends_on "libpng"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "fontconfig"
  depends_on "pango" if (build.with? "cairo") || (build.with? "wxmac")
  depends_on "pdflib-lite" => :optional
  depends_on "wxmac" => :optional
  depends_on :x11 => :optional

  def install
    if build.with? "aquaterm"
      # Add "/Library/Frameworks" to the default framework search path, so that an
      # installed AquaTerm framework can be found. Brew does not add this path
      # when building against an SDK (Nov 2013).
      ENV.prepend "CPPFLAGS", "-F/Library/Frameworks"
      ENV.prepend "LDFLAGS", "-F/Library/Frameworks"
    else
      inreplace "configure", "-laquaterm", ""
    end

    # Help configure find libraries
    readline = Formula["readline"].opt_prefix
    pdflib = Formula["pdflib-lite"].opt_prefix
    gd = Formula["gd"].opt_prefix

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-readline=#{readline}
      --without-latex
    ]

    args << "--with-pdf=#{pdflib}" if build.with? "pdflib-lite"
    args << (build.with?("gd") ? "--with-gd=#{gd}" : "--without-gd")

    if build.without? "wxmac"
      args << "--disable-wxwidgets"
      args << "--without-cairo" if build.without? "cairo"
    end

    args << "--without-lua" if build.without? "lua"
    args << (build.with?("emacs") ? "--with-lispdir=#{elisp}" : "--without-lisp-files")
    args << (build.with?("aquaterm") ? "--with-aquaterm" : "--without-aquaterm")
    args << (build.with?("x11") ? "--with-x" : "--without-x")

    # From latest gnuplot formula on core:
    # > The tutorial requires the deprecated subfigure TeX package installed
    # > or it halts in the middle of the build for user-interactive resolution.
    # > Per upstream: "--with-tutorial is horribly out of date."
    args << "--without-tutorial"

    system "./configure", *args
    ENV.deparallelize # or else emacs tries to edit the same file with two threads
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  def caveats
    if build.with? "aquaterm"
      <<-EOS.undent
        AquaTerm support will only be built into Gnuplot if the standard AquaTerm
        package from SourceForge has already been installed onto your system.
        If you subsequently remove AquaTerm, you will need to uninstall and then
        reinstall Gnuplot.
      EOS
    end
  end

  test do
    system "#{bin}/gnuplot", "-e", <<-EOS.undent
        set terminal png;
        set output "#{testpath}/image.png";
        plot sin(x);
    EOS
    assert_predicate testpath/"image.png", :exist?
  end
end
