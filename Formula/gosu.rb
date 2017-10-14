class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "http://gosu-lang.org/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.14.6.tar.gz"
  sha256 "cb7cddb44025ecf6d601c15df148e103eeb5316402debb22395d261ba34669fe"
  head "https://github.com/gosu-lang/gosu-lang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8aa5ec8782193ef8abc8dd1d461b08aadad62c498ab5837a37d57702d45afbc" => :high_sierra
    sha256 "9655ec17694b5410a1deb620c8d6c03c5ddc0532814d11ce0bcf9487c9b5f5ac" => :sierra
    sha256 "fd311848681a64d3727889d47c061a52a55d64dc5236df1b06c0628a0bf71837" => :el_capitan
    sha256 "dee97ff03b12443a4fcaab053ca8860377279e9b8676f4b487f57e7095422d1e" => :yosemite
  end

  depends_on :java => "1.8+"
  depends_on "maven" => :build

  skip_clean "libexec/ext"

  def install
    system "mvn", "package"
    libexec.install Dir["gosu/target/gosu-#{version}-full/gosu-#{version}/*"]
    (libexec/"ext").mkpath
    bin.install_symlink libexec/"bin/gosu"
  end

  test do
    (testpath/"test.gsp").write 'print ("burp")'
    assert_equal "burp", shell_output("#{bin}/gosu test.gsp").chomp
  end
end
