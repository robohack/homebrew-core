class Whatmp3 < Formula
  desc "Small script to create mp3 torrents out of FLACs"
  homepage "https://github.com/RecursiveForest/whatmp3"
  url "https://github.com/RecursiveForest/whatmp3/archive/v3.8.tar.gz"
  sha256 "0d8ba70a1c72835663a3fde9ba8df0ff7007268ec0a2efac76c896dea4fcf489"
  head "https://github.com/RecursiveForest/whatmp3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7b12026d65a3bb2a5e1b8ca2c834179ec24a7f082d5a67a5381bd21f3b595e3" => :high_sierra
    sha256 "4b9cae8fe803bbb26ee73e1724dba6e679d384fba7df680a42363b8f45a848d8" => :sierra
    sha256 "d50a1cb3c8406226f5b06750652ec7928243b9367723fe4def66332f412c719b" => :el_capitan
    sha256 "d50a1cb3c8406226f5b06750652ec7928243b9367723fe4def66332f412c719b" => :yosemite
  end

  depends_on :python3
  depends_on "flac"
  depends_on "mktorrent" => :recommended
  depends_on "lame" => :recommended
  depends_on "vorbis-tools" => :optional
  depends_on "mp3gain" => :optional
  depends_on "aacgain" => :optional
  depends_on "vorbisgain" => :optional
  depends_on "sox" => :optional

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    # Create dummy FLAC
    (testpath/"flac/file.flac").write "fLaC\x00\x00\x00\"\x04\x80\x04\x80\x00\x00\f\x00\x00\f\x01\xF4\x00\xF0\x00\x00\x00\x01\xF3\x8B\xE3\xDBM\x93\xE40\\~$\xBE\x94\xEF\x01\x9A\x84\x00\x00( \x00\x00\x00reference libFLAC 1.2.1 20070917\x00\x00\x00\x00\xFF\xF8d\b\x00\x00\xE3\x03\x01\xFD\xEC\x10"
    system "#{bin}/whatmp3", "--notorrent", "--V0", "flac"
    assert_predicate testpath/"V0/file.mp3", :exist?
  end
end
