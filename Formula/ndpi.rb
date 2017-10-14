class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "http://www.ntop.org/products/ndpi/"
  url "https://github.com/ntop/nDPI/archive/2.0.tar.gz"
  sha256 "a42a60ebd64bc8606f780204222893027f6dce0e3b460d7be655e5e065f5f3fa"
  revision 1
  head "https://github.com/ntop/nDPI.git", :branch => "dev"

  bottle do
    cellar :any
    sha256 "0cc0a288965cf60916c9732edf73332797a1931314659786acb1a944fad43ee1" => :high_sierra
    sha256 "ae229a6b0c648df903a9036ef9c5a8ce801a97e95158ece953669da55009a40b" => :sierra
    sha256 "855da8002f3632da5d0b576c148eabe708e598b80d9f533e07c8d0f8e43ede72" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "json-c"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"ndpiReader", "-i", test_fixtures("test.pcap")
  end
end
