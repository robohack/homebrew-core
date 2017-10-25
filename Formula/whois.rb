class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/w/whois/whois_5.2.18.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/w/whois/whois_5.2.18.tar.xz"
  sha256 "c35d0d26aff37107c244a8ad54fd42e497ec0b90f76309e9beb7078b827c97d5"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "efbf2c5eae16825f831095a2589b59e7a485aa8a2e786052c4b94bbffb0e1356" => :high_sierra
    sha256 "532e5b0a21d134aa714abbf1f80835e1256e037901540026579c395e0c515c72" => :sierra
    sha256 "cf7bca8cc4c6275a3753794c42b5fe916535d25e9a4465c81616984636a3cb37" => :el_capitan
    sha256 "73b75963251f3c420d2d24972447d015028dc3d1f872a2b335f5aea8f4b0977c" => :yosemite
  end

  def install
    system "make", "whois", "HAVE_ICONV=1", "whois_LDADD+=-liconv"
    bin.install "whois"
    man1.install "whois.1"
  end

  def caveats; <<~EOS
    Debian whois has been installed as `whois` and may shadow the
    system binary of the same name.
    EOS
  end

  test do
    system "#{bin}/whois", "brew.sh"
  end
end
