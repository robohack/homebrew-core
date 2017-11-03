class Ftp < Formula
  desc "User interface to the FTP protocol (built from macOS Sierra sources)"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/lukemftp/lukemftp-16.tar.gz"
  sha256 "ba35a8e3c2e524e5772e729f592ac0978f9027da2433753736e1eb1f1351ae9d"

  depends_on :xcode => :build

  def install
    cd "tnftp" do
      system "./configure",
             "--disable-dependency-tracking",
             "--prefix=#{prefix}",
             "--mandir=#{man}"
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match "#{bin}/ftp: illegal option -- ?",
                 shell_output("#{bin}/ftp -? 2>&1", 1)
  end
end
