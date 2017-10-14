class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.6.1/onig-6.6.1.tar.gz"
  sha256 "8f9731f9e48666236a1678e2b4ead69be682eefba3983a714b6b57cf5ee14372"

  bottle do
    cellar :any
    sha256 "a8c7f05b57a3e2af9d3128493bbdd728065dc85f46f3dee755230a632738939d" => :high_sierra
    sha256 "04434c6981d707f34b7dfe8b6d224d079cc8c2e2f1b1a7898f4a8d5c8b9c1255" => :sierra
    sha256 "a427aa562f87e2d3d0081e757993340fe150c4240c64f23376ecb1910c17c7a9" => :el_capitan
    sha256 "ff7a92976e22cde9cb1be7d8010d5ea617d6e024a6dbc430c43b170ab5d6bbe8" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{prefix}/, shell_output("#{bin}/onig-config --prefix")
  end
end
