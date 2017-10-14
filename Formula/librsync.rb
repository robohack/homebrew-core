class Librsync < Formula
  desc "Library that implements the rsync remote-delta algorithm"
  homepage "https://librsync.github.io/"
  url "https://github.com/librsync/librsync/archive/v2.0.0.tar.gz"
  sha256 "b5c4dd114289832039397789e42d4ff0d1108ada89ce74f1999398593fae2169"
  revision 1

  bottle do
    sha256 "de4c71e13829b6344a859c01145f2cd599b4e456e9c1dac6049f657b3b42dcfe" => :high_sierra
    sha256 "f17fa395aecc8198c3a09d6eb483a45d0a2b091280f18b5c6576cf3c7b54557e" => :sierra
    sha256 "f9b52eb45dd0cc166e5d31e3a90cd02bd99c619a5893dd3c8129757528e410cb" => :el_capitan
    sha256 "31709e2fe6f0480a825209e7aa13602f768db43be57477738e2f7f7150213869" => :yosemite
    sha256 "bc7ada34fb6aae7fcb9a303a3daeda5861ab11e0a966425aaed2e549fd88e6b9" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "popt"

  def install
    # https://github.com/librsync/librsync/commit/1765ad0d416
    # https://github.com/librsync/librsync/issues/50
    # Safe to remove when the next stable release is cut.
    inreplace "src/search.c", "if (l == r) {", "if ((l == r) && (l <= bucket->r)) {"

    system "cmake", ".", *std_cmake_args
    system "make", "install"
    man1.install "doc/rdiff.1"
    man3.install "doc/librsync.3"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rdiff -V")
  end
end
