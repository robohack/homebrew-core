class Agedu < Formula
  desc "Unix utility for tracking down wasted disk space"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/agedu/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-20170831.fc6b2b5.tar.gz"
  version "20170831"
  sha256 "dd2e6f82270c5bf6083c0d275251207607d8b68955511b3083cec477279267bf"
  head "https://git.tartarus.org/simon/agedu.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "499d9876e961a92695f103d7e460c3429801028e54a278628ddd26a47da45396" => :high_sierra
    sha256 "37e6846a31a0b84412e81f5da9d08e8a3a2f4cf47232318be0ef7dee26a8928b" => :sierra
    sha256 "7e4559ad6310ba5a8503c08a148eabfacc5622a7ee23ab45bc061fe4e3ef830d" => :el_capitan
    sha256 "3aefc8595aeef045386d807d53a07f80e1f1fd3955f2caa217e052aadc6c9b21" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "halibut" => :build

  def install
    system "./mkauto.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"agedu", "-s", "."
    assert_predicate testpath/"agedu.dat", :exist?
  end
end
