class Mdds < Formula
  desc "Multi-dimensional data structure and indexing algorithm"
  homepage "https://gitlab.com/mdds/mdds"
  url "https://kohei.us/files/mdds/src/mdds-1.3.0.tar.bz2"
  sha256 "00aa92a28af9f1168a8e5c38e46f311abb65ef5b113ef56078ff104b94211460"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5df2f3ea7306b6b473fbf378feb8ce21ab7f9c4868f050e2a4b68b31b65ac11" => :high_sierra
    sha256 "f91e37bf2763a0290807e0e8034db690695b0a60611665dc844bf2a1352de73e" => :sierra
    sha256 "f91e37bf2763a0290807e0e8034db690695b0a60611665dc844bf2a1352de73e" => :el_capitan
    sha256 "f91e37bf2763a0290807e0e8034db690695b0a60611665dc844bf2a1352de73e" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "boost"
  needs :cxx11

  def install
    # Gets it to work when the CLT is installed
    inreplace "configure.ac", "$CPPFLAGS -I/usr/include -I/usr/local/include",
                              "$CPPFLAGS -I/usr/local/include"
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mdds/flat_segment_tree.hpp>
      int main() {
        mdds::flat_segment_tree<unsigned, unsigned> fst(0, 4, 8);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-std=c++11",
                    "-I#{include.children.first}"
    system "./test"
  end
end
