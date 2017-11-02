class Apr < Formula
  desc "Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=apr/apr-1.6.3.tar.bz2"
  sha256 "131f06d16d7aabd097fa992a33eec2b6af3962f93e6d570a9bd4d85e95993172"

  bottle do
    cellar :any
    sha256 "64527b35f69f53202253676c3727411fa3fb3a0ae1b71ca266c62d2a87faf3bd" => :high_sierra
    sha256 "5a0ef0c7992eaa6fc1ac332f72cdaebfb5fc0e9fd70a00606fc72e3a5c9d0afb" => :sierra
    sha256 "b5b9ef99e199a850bc0485fec5968ada7dece9d107df3af0014ecb7245cf5f68" => :el_capitan
    sha256 "cca4cfe47cf5e2f504c2bba59ddb991211b4ed778b2cadda74ea418305a5d942" => :yosemite
  end

  keg_only :provided_by_osx, "Apple's CLT package contains apr"

  def install
    ENV["SED"] = "sed" # prevent libtool from hardcoding sed path from superenv

    # https://bz.apache.org/bugzilla/show_bug.cgi?id=57359
    # The internal libtool throws an enormous strop if we don't do...
    ENV.deparallelize

    # Stick it in libexec otherwise it pollutes lib with a .exp file.
    system "./configure", "--prefix=#{libexec}"
    system "make", "install"
    bin.install_symlink Dir["#{libexec}/bin/*"]

    rm Dir[libexec/"lib/*.la"]

    # No need for this to point to the versioned path.
    inreplace libexec/"bin/apr-1-config", libexec, opt_libexec
  end

  test do
    assert_match opt_libexec.to_s, shell_output("#{bin}/apr-1-config --prefix")
  end
end
