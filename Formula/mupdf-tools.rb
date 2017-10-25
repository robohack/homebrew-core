class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  revision 1
  head "https://git.ghostscript.com/mupdf.git"

  stable do
    url "https://mupdf.com/downloads/mupdf-1.11-source.tar.gz"
    sha256 "209474a80c56a035ce3f4958a63373a96fad75c927c7b1acdc553fc85855f00a"

    # Upstream already. Remove on next stable release.
    patch do
      url "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/mupdf/mupdf_1.11+ds1-1.1.debian.tar.xz"
      mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/m/mupdf/mupdf_1.11+ds1-1.1.debian.tar.xz"
      sha256 "cb274532e34f818b2f1871fee6303cfffda37251937dd7d731a898b2ca736433"
      apply "patches/0003-Fix-698539-Don-t-use-xps-font-if-it-could-not-be-loa.patch",
            "patches/0004-Fix-698540-Check-name-comment-and-meta-size-field-si.patch",
            "patches/0005-Fix-698558-Handle-non-tags-in-tag-name-comparisons.patch"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f3c3654922260e4e2b0c7bb3b10cbf048b618712ff3cda5325a6661d82f02ad4" => :high_sierra
    sha256 "b758f982d165d1a78caf8ce612de4103f0fa5312d1ef5ea78003beece2698504" => :sierra
    sha256 "b3058793714bb01bf5281bd1a64b914dffc1bcbe3938665ec59f41036828fb7b" => :el_capitan
    sha256 "1984e3b0e8e71d4b1add14be7d1f4b9625b1a0dbe67c64fd67f0db237d5e78c5" => :yosemite
  end

  def install
    # Work around bug: https://bugs.ghostscript.com/show_bug.cgi?id=697842
    inreplace "Makerules", "RANLIB_CMD := xcrun", "RANLIB_CMD = xcrun"

    system "make", "install",
           "build=release",
           "verbose=yes",
           "HAVE_X11=no",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}",
           "HAVE_GLFW=no" # Do not build OpenGL viewer: https://bugs.ghostscript.com/show_bug.cgi?id=697842

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mutool draw -F txt #{test_fixtures("test.pdf")}")
  end
end
