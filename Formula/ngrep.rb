class Ngrep < Formula
  desc "Network grep"
  homepage "https://ngrep.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngrep/ngrep/1.45/ngrep-1.45.tar.bz2"
  sha256 "aea6dd337da8781847c75b3b5b876e4de9c58520e0d77310679a979fc6402fa7"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2a8f05ed5acd9e0c44d72c10c8da509b34f27ff892ded76e4b80a974630ea66f" => :high_sierra
    sha256 "76d47db6c682e4e6791591bb0dc3316d8cc102163f064257490e738da04577cc" => :sierra
    sha256 "f4688b249e7038b5ee288af4cc589a22914f1e1f2ba943fdbbebd9cc8acc078b" => :el_capitan
    sha256 "e028924a9424a6f61a53c2cb850da0e1adfbde9914c63d85e0cae7cc9a88ed82" => :yosemite
    sha256 "a86b9021fa54635f144c7de70ea7dba6bd35a872f19cae877c341a00730c9d17" => :mavericks
  end

  # https://sourceforge.net/p/ngrep/bugs/27/
  patch do
    url "https://launchpadlibrarian.net/44952147/ngrep-fix-ipv6-support.patch"
    sha256 "f1bcc0a344e5f454207254746cab5b1d216d3de3efaf08f59732f2182d42bbb1"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-ipv6",
                          "--prefix=#{prefix}",
                          # this line required to make configure succeed
                          "--with-pcap-includes=#{MacOS.sdk_path}/usr/include/pcap",
                          # this line required to avoid segfaults
                          # see https://github.com/jpr5/ngrep/commit/e29fc29
                          # https://github.com/Homebrew/homebrew/issues/27171
                          "--disable-pcap-restart"
    system "make", "install"
  end
end
