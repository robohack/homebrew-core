class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nco/nco-4.6.9.tar.gz"
  sha256 "efdc0d65d3cc67d0d5dc521709dd0e60b24839e0ae7ded92aaec656890f6f416"

  bottle do
    cellar :any
    sha256 "32c324450faa69a002a28062d3abdab7bca6f743c416c2068ade9c20915748b6" => :high_sierra
    sha256 "3847acd4d49e672f56acf898111f4cf53ca9ad0d72789cd2189a670a3fcbbc74" => :sierra
    sha256 "d8fe7e747f0390abdbe492ba96f3d718f3273c5fd9d30f897b4cb018991d1fff" => :el_capitan
  end

  head do
    url "https://github.com/czender/nco.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "antlr@2" # requires C++ interface in Antlr2
  depends_on "gsl"
  depends_on "netcdf"
  depends_on "texinfo"
  depends_on "udunits"

  resource("example_nc") do
    url "https://www.unidata.ucar.edu/software/netcdf/examples/WMI_Lear.nc"
    sha256 "e37527146376716ef335d01d68efc8d0142bdebf8d9d7f4e8cbe6f880807bdef"
  end

  def install
    system "./autogen.sh" if build.head?

    inreplace "configure" do |s|
      # The Antlr 2.x program installed by Homebrew is called antlr2
      s.gsub! "for ac_prog in runantlr antlr", "for ac_prog in runantlr antlr2"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-netcdf4"
    system "make", "install"
  end

  test do
    testpath.install resource("example_nc")
    output = shell_output("#{bin}/ncks --json -M WMI_Lear.nc")
    assert_match "\"time\": 180", output
  end
end
