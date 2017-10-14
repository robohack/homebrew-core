class TclTk < Formula
  desc "Tool Command Language"
  homepage "https://www.tcl.tk/"

  stable do
    url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.7/tcl8.6.7-src.tar.gz"
    mirror "ftp://ftp.tcl.tk/pub/tcl/tcl8_6/tcl8.6.7-src.tar.gz"
    version "8.6.7"
    sha256 "7c6b8f84e37332423cfe5bae503440d88450da8cc1243496249faa5268026ba5"

    resource "tk" do
      url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.7/tk8.6.7-src.tar.gz"
      mirror "ftp://ftp.tcl.tk/pub/tcl/tcl8_6/tk8.6.7-src.tar.gz"
      version "8.6.7"
      sha256 "061de2a354f9b7c7d04de3984c90c9bc6dd3a1b8377bb45509f1ad8a8d6337aa"
    end
  end

  bottle do
    sha256 "01e59553d910f320d358ae8ecaeff955300684c577edd0470b0c3a14a1c6f8c4" => :high_sierra
    sha256 "0a21606596e11bc27ae105548906cc161e0e8bd1ccd0546c1df0441ae2ab1a43" => :sierra
    sha256 "56d5506393587d99b78e458d3945833380682068091f75ea525c1d8a64d5ced9" => :el_capitan
    sha256 "4a3b7d78452c33e84d8c55eaf71bb758e25f0aa9e16112cdd6646ba458304baf" => :yosemite
  end

  devel do
    url "https://downloads.sourceforge.net/project/tcl/Tcl/8.7a1/tcl8.7a1-src.tar.gz"
    mirror "ftp://ftp.tcl.tk/pub/tcl/tcl8_7/tk8.7a1-src.tar.gz"
    version "8.7a1"
    sha256 "2bbd4e0bbdebeaf5dc6cc823d0805afb45c764292f6667d9ce2b9fcf5399e0dc"

    resource "tk" do
      url "https://downloads.sourceforge.net/project/tcl/Tcl/8.7a1/tk8.7a1-src.tar.gz"
      mirror "ftp://ftp.tcl.tk/pub/tcl/tcl8_7/tk8.7a1-src.tar.gz"
      sha256 "131e4bae43a15dff0324c0479358bb42cfd7b8de0e1ca8d93c9207643c7144dd"
    end
  end

  keg_only :provided_by_osx,
    "tk installs some X11 headers and macOS provides an (older) Tcl/Tk"

  option "without-tcllib", "Don't build tcllib (utility modules)"
  option "without-tk", "Don't build the Tk (window toolkit)"

  resource "tcllib" do
    url "https://downloads.sourceforge.net/project/tcllib/tcllib/1.18/tcllib-1.18.tar.gz"
    sha256 "72667ecbbd41af740157ee346db77734d1245b41dffc13ac80ca678dd3ccb515"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-threads
      --enable-64bit
    ]

    cd "unix" do
      system "./configure", *args
      system "make"
      system "make", "install"
      system "make", "install-private-headers"
      ln_s bin/"tclsh#{version.to_f}", bin/"tclsh"
    end

    if build.with? "tk"
      ENV.prepend_path "PATH", bin # so that tk finds our new tclsh

      resource("tk").stage do
        cd "unix" do
          system "./configure", *args, "--enable-aqua=yes",
                                "--without-x", "--with-tcl=#{lib}"
          system "make"
          system "make", "install"
          system "make", "install-private-headers"
          ln_s bin/"wish#{version.to_f}", bin/"wish"
        end
      end
    end

    if build.with? "tcllib"
      resource("tcllib").stage do
        system "./configure", "--prefix=#{prefix}",
                              "--mandir=#{man}"
        system "make", "install"
      end
    end
  end

  test do
    assert_equal "honk", pipe_output("#{bin}/tclsh", "puts honk\n").chomp
  end
end
