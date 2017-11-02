class Sdl2Gfx < Formula
  desc "SDL2 graphics drawing primitives and other support functions"
  homepage "http://cms.ferzkopp.net/index.php/software/13-sdl-gfx"
  url "https://www.ferzkopp.net/Software/SDL2_gfx/SDL2_gfx-1.0.3.tar.gz"
  sha256 "a4066bd467c96469935a4b1fe472893393e7d74e45f95d59f69726784befd8f8"

  bottle do
    cellar :any
    sha256 "d52ce733fb3dc06e64529bf39687bdd9ed314b50e56bd98db9b1e8f78cfa6462" => :high_sierra
    sha256 "128cb3987760ae5602e11520be79aeddc9717a827e66e93658556c92a1f4f56c" => :sierra
    sha256 "bee90056a343bd99bbd437b8ccf22ae112780602f533c3de23c384ac86063977" => :el_capitan
    sha256 "a3dc0c6eb41221f71781038f6705c36761c9489947eb418adc013e7a6ab00045" => :yosemite
    sha256 "e7888e8bbdbda56ec2941b53a74482d1d74c3e321b632af1099d909d209497cd" => :mavericks
  end

  depends_on "sdl2"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make", "install"
  end
end
