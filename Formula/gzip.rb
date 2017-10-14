class Gzip < Formula
  desc "Popular GNU data compression program"
  homepage "https://www.gnu.org/software/gzip"
  url "https://ftp.gnu.org/gnu/gzip/gzip-1.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/gzip/gzip-1.8.tar.gz"
  sha256 "1ff7aedb3d66a0d73f442f6261e4b3860df6fd6c94025c2cb31a202c9c60fe0e"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c250a97a4992abbea840e20bba57ec9467d289ff3ea0ad170bb4900f6f57bd0" => :high_sierra
    sha256 "e51384ad9df99dbda85adc5ed68523661357cb038504f27a34e1851470b5416f" => :sierra
    sha256 "1fcddc90fa996157665322ea1520863e9367a97693334f4c9b60b2abcf958328" => :el_capitan
    sha256 "e240320b82c71f8367a696558a4863469b52fcb0ca8245ba0f0c83483f126507" => :yosemite
  end

  # Fix crash from usage of %n in dynamic format strings on High Sierra
  # Patch credit to Jeremy Huddleston Sequoia <jeremyhu@apple.com>
  if MacOS.version >= :high_sierra
    patch :p0 do
      url "https://raw.githubusercontent.com/macports/macports-ports/bc289fc24ab/archivers/gzip/files/secure_snprintf.patch"
      sha256 "57f972940a10d448efbd3d5ba46e65979ae4eea93681a85e1d998060b356e0d2"
    end
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/gzip", "foo"
    system "#{bin}/gzip", "-t", "foo.gz"
    assert_equal "test", shell_output("#{bin}/gunzip -c foo")
  end
end
