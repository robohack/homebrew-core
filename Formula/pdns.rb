class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.0.4.tar.bz2"
  sha256 "d974ab89de69477c7f581a3233bc731eacbb43d479291e472b2c531c83b6d763"

  bottle do
    rebuild 1
    sha256 "1ddd05ec549ad270acf46184f617a0ad919dbe0a64049f2fb886dd444c05d256" => :high_sierra
    sha256 "3f2d038fcdbdd1893218e65972ec7231484824169492af0be78a36de4ea349a7" => :sierra
    sha256 "887996ed6bdca5b0beb0e1e327c83f40d94696f29ed83e2bd68f67f0ca7cb9cd" => :el_capitan
  end

  head do
    url "https://github.com/powerdns/pdns.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  option "with-postgresql", "Enable the PostgreSQL backend"
  option "with-remote", "enable the Remote backend"

  deprecated_option "pgsql" => "with-postgresql"
  deprecated_option "with-pgsql" => "with-postgresql"

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl"
  depends_on "sqlite"
  depends_on :postgresql => :optional

  # Use upstream commit that fixes build with Xcode 9
  # https://github.com/PowerDNS/pdns/pull/4940
  patch do
    url "https://github.com/PowerDNS/pdns/commit/885bddbd.patch?full_index=1"
    sha256 "a6c08599f8b6e368eaec99614e09da49be213666850c44101673fe2b3b4c2558"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --with-lua
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --with-sqlite3
    ]

    # Include the PostgreSQL backend if requested
    if build.with? "postgresql"
      args << "--with-modules=gsqlite3 gpgsql"
    elsif build.with? "remote"
      args << "--with-modules=gsqlite3 remote"
    else
      # SQLite3 backend only is the default
      args << "--with-modules=gsqlite3"
    end

    system "./bootstrap" if build.head?
    system "./configure", *args

    system "make", "install"
  end

  plist_options :manual => "pdns_server start"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/pdns_server</string>
      </array>
      <key>EnvironmentVariables</key>
      <key>KeepAlive</key>
      <true/>
      <key>SHAuthorizationRight</key>
      <string>system.preferences</string>
    </dict>
    </plist>
    EOS
  end

  test do
    output = shell_output("#{sbin}/pdns_server --version 2>&1", 99)
    assert_match "PowerDNS Authoritative Server #{version}", output
  end
end
