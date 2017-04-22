class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.14.tar.bz2"
  sha256 "f70d0678ef1c5550953bdc27b12e72d5de86e53b05dd59b0fc7f07c507f244b8"

  bottle do
    cellar :any
    sha256 "dce0530efd47157b5ab5e96ffe91324134fa5dc957ed1343e38dd04de209a5d9" => :sierra
    sha256 "334ae37d4e41f8bfcf86e8a4ec543db97a357f315cf4778b41c8039e2ce78a3c" => :el_capitan
    sha256 "61690764c8f0b3f4246b8099e0b1216a2585f70c97c53d5dbd8d2fd04efb19c9" => :yosemite
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
