class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https://yash.osdn.jp/"
  url "https://ja.osdn.net/frs/redir.php?f=%2Fyash%2F68578%2Fyash-2.46.tar.xz"
  mirror "http://dl.osdn.jp/yash/68578/yash-2.46.tar.xz"
  sha256 "93431d897ce2b176c9f97b879c70a426ebc125b073d5894c00cd746f3a8455cb"

  bottle do
    sha256 "e87b00b05515ee1f560cb6e6b420abe4c2f842df6b5bfd382e8c18624eec9d79" => :high_sierra
    sha256 "e480eb53b583ca70cd1976f62898d59c23551bb82c3bf830eb8c5efef64ed2ad" => :sierra
    sha256 "811d8ba86be74330f2611c17744f147c538551672d437da16c9dc5bf3f93a4dd" => :el_capitan
    sha256 "998a98901ab1b4917a5b4c03032d2e2a014d87a648dfcc8324e5f6e36beb7325" => :yosemite
  end

  depends_on "gettext"

  def install
    system "sh", "./configure",
            "--prefix=#{prefix}",
            "--enable-array",
            "--enable-dirstack",
            "--enable-help",
            "--enable-history",
            "--enable-lineedit",
            "--enable-nls",
            "--enable-printf",
            "--enable-socket",
            "--enable-test",
            "--enable-ulimit"
    system "make", "install"
  end

  test do
    system "#{bin}/yash", "-c", "echo hello world"
  end
end
