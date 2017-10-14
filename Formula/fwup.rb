class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.16.1/fwup-0.16.1.tar.gz"
  sha256 "4c53a3c25c2e7c55a3a4d73f56c819213260b16b68964a774457349c559fef49"

  bottle do
    cellar :any
    sha256 "e19e41c26047b1c27e1ff5c9188658a0d7088fa6a93e33a913f11915acd7ad38" => :high_sierra
    sha256 "a1d765a4f5151987ce46db594ccfa667423a5f4a959595f742284e04f8540fc4" => :sierra
    sha256 "84c89cc966ba10d384d45f5757291a3ea6fbd89815fed59ab4ec1cddbecabd0e" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "libarchive"
  depends_on "libsodium"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert_predicate testpath/"fwup-key.priv", :exist?, "Failed to create fwup-key.priv!"
    assert_predicate testpath/"fwup-key.pub", :exist?, "Failed to create fwup-key.pub!"
  end
end
