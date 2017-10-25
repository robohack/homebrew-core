class LibbitcoinBlockchain < Formula
  desc "Bitcoin Blockchain Library"
  homepage "https://github.com/libbitcoin/libbitcoin-blockchain"
  url "https://github.com/libbitcoin/libbitcoin-blockchain/archive/v3.3.0.tar.gz"
  sha256 "c97762f37e30b0d41b5f9d70499dbf9ca70096924410e98a15781e4cb5c39966"
  revision 1

  bottle do
    sha256 "ac5a21d4105ccef391341699da7ce3f63630bb65dde7384ebabba0271be2935f" => :high_sierra
    sha256 "1ebd9eebbca6273bfdf5fade9b8ac192a62bc648d510600bd00c97417b7b7b61" => :sierra
    sha256 "dd97f3c44fb97d33d79efa1e784c34837260b94a859e7b777a247399ec2efd0e" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin"
  depends_on "libbitcoin-database"

  resource "libbitcoin-consensus" do
    url "https://github.com/libbitcoin/libbitcoin-consensus/archive/v3.3.0.tar.gz"
    sha256 "ae581f7c42a52fb6f4a233300f76f2a2d03a22eee6d4bfe22b233e9b52f029b4"
  end

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"
    ENV.prepend_create_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

    resource("libbitcoin-consensus").stage do
      system "./autogen.sh"
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}"
      system "make", "install"
    end

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <bitcoin/blockchain.hpp>
      int main() {
        static const auto default_block_hash = libbitcoin::hash_literal("14508459b221041eab257d2baaa7459775ba748246c8403609eb708f0e57e74b");
        const auto block = std::make_shared<const libbitcoin::message::block>();
        libbitcoin::blockchain::block_entry instance(block);
        assert(instance.block() == block);
        assert(instance.hash() == default_block_hash);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp",
                    "-I#{libexec}/include",
                    "-L#{lib}", "-L#{libexec}/lib",
                    "-lbitcoin", "-lbitcoin-blockchain", "-lboost_system",
                    "-o", "test"
    system "./test"
  end
end
