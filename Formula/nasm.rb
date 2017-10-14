class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "http://www.nasm.us/"
  url "http://www.nasm.us/pub/nasm/releasebuilds/2.13.01/nasm-2.13.01.tar.xz"
  sha256 "aa0213008f0433ecbe07bb628506a5c4be8079be20fc3532a5031fd639db9a5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb072a7cb278fa0c89c4aa2c2ffbe501fdca499075f2b1e4ff90c62d25ad79ae" => :high_sierra
    sha256 "3bf967e428595a156fe97185a07d82bba91c3b2003b08f329bf94fb87136f463" => :sierra
    sha256 "138c9fd695681960f7eecb1ce352723bbb313afb1fdd4a7966427c4b5199e22b" => :el_capitan
    sha256 "821356bf15a266e2c3d45ef019c237422ced030696ca5f0b0f69a6974e7bd8fa" => :yosemite
  end

  head do
    url "git://repo.or.cz/nasm.git"
    depends_on "autoconf" => :build
    depends_on "asciidoc" => :build
    depends_on "xmlto" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "manpages" if build.head?
    system "make", "rdf"
    system "make", "install", "install_rdf"
  end

  test do
    (testpath/"foo.s").write <<-EOS
      mov eax, 0
      mov ebx, 0
      int 0x80
    EOS

    system "#{bin}/nasm", "foo.s"
    code = File.open("foo", "rb") { |f| f.read.unpack("C*") }
    expected = [0x66, 0xb8, 0x00, 0x00, 0x00, 0x00, 0x66, 0xbb,
                0x00, 0x00, 0x00, 0x00, 0xcd, 0x80]
    assert_equal expected, code
  end
end
