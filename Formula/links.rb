class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.14.tar.bz2"
  sha256 "f70d0678ef1c5550953bdc27b12e72d5de86e53b05dd59b0fc7f07c507f244b8"
  revision 1

  bottle do
    cellar :any
    sha256 "c5548c20d4e677218f870fb19c2275f51b3a737da1fd78532b88cf90af4e4dd5" => :high_sierra
    sha256 "5a8045be375cb674122da0342e04f47ff14c3360e1f7eebe9f827284aba318ed" => :sierra
    sha256 "3a74e6b5c260ee7ac380cf0e15e0c718fb6c06c113ac2311a0dae9b1be755fe3" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "xz"
  depends_on "openssl"
  depends_on :x11 => :optional

  # rest only really needed if --with-x11: XXX but impossible to use:  if build.with? "x11"
  depends_on "libtiff" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  # note: librsvg pulls in lots of really big stuff, but is quite useful, e.g. for Wikipedia
  depends_on "librsvg" => :recommended

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --with-ssl=#{Formula["openssl"].opt_prefix}
      --without-lzma
    ]

    if build.with? "x11"
      args << "--enable-graphics"
      args << "--with-x"
      if build.without? "libpng"
        args << "--disable-png-pkgconfig"
      end
      if build.without? "libtiff"
        args << "--without-libtiff"
      else
        args << "--with-libtiff"
      end
      if build.without? "jpeg"
        args << "--without-libjpeg"
      else
        args << "--with-libjpeg"
      end
      if build.without? "librsvg"
        args << "--without-librsvg"
        args << "--disable-svg-pkgconfig"
      else
        args << "--with-librsvg"
      end
    end
    system "./configure", *args
    system "make", "install"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"links", "-dump", "https://duckduckgo.com"
  end
end
