class Gsmartcontrol < Formula
  desc "Graphical user interface for smartctl"
  homepage "https://gsmartcontrol.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gsmartcontrol/1.1.1/gsmartcontrol-1.1.1.tar.bz2"
  sha256 "2e39ad330829ae93824732f1b663303ac9ea1223f703901fae28549a3b2d7518"

  bottle do
    sha256 "62b9cb3cdc57d95a416bb09688ceed842cc419448e20537edbf7e1067318048e" => :high_sierra
    sha256 "42f4e4ef37720314a5fcaa58a4e4cb3ba9aaad76db90c45bbea3f45b88c44a10" => :sierra
    sha256 "d48b7d246ec5ff6af57db94f1a6a99c3d4110bb11899ea1a44a83b182afc6ae5" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "smartmontools"
  depends_on "gtkmm3"
  depends_on "pcre"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{sbin}/gsmartcontrol", "--version"
  end
end
