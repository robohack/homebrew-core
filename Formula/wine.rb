# NOTE: When updating Wine, please check Wine-Gecko and Wine-Mono for updates
# too:
#  - https://wiki.winehq.org/Gecko
#  - https://wiki.winehq.org/Mono
class Wine < Formula
  desc "Run Windows applications without a copy of Microsoft Windows"
  homepage "https://www.winehq.org/"
  revision 3
  head "https://source.winehq.org/git/wine.git"

  stable do
    url "https://dl.winehq.org/wine/source/2.0/wine-2.0.2.tar.xz"
    mirror "https://downloads.sourceforge.net/project/wine/Source/wine-2.0.2.tar.xz"
    sha256 "f71884f539928877f4b415309f582825d3d3c9976104e43d566944c710713c9a"

    # Patch to fix texture compression issues. Still relevant on 2.0.
    # https://bugs.winehq.org/show_bug.cgi?id=14939
    patch do
      url "https://bugs.winehq.org/attachment.cgi?id=52384"
      sha256 "30766403f5064a115f61de8cacba1defddffe2dd898b59557956400470adc699"
    end

    # Patch to fix screen-flickering issues. Still relevant on 2.0.
    # https://bugs.winehq.org/show_bug.cgi?id=34166
    patch do
      url "https://bugs.winehq.org/attachment.cgi?id=55968"
      sha256 "1b5086798ce6dc959b3cbb8f343ee236ae06c7910e4bbae7d9fde3f162f03a79"
    end
  end

  bottle do
    sha256 "b3ea4bf10ef9e1ecd2d41719b71aff20992c893c2f258b54ee70df5729313fef" => :high_sierra
    sha256 "63366bc4edfc655d5684b90b7de3eea48942ba19f96dd38b953a72685d1cb2ef" => :sierra
    sha256 "938763b483907313d93b37f7dda6d8eb332c0d27ce94c14d62f9af3084a04ce6" => :el_capitan
    sha256 "20ebde20c833412af76f424496f1a2eb0a29227069a3a240450f2caa7fe47c21" => :yosemite
  end

  devel do
    url "https://dl.winehq.org/wine/source/2.x/wine-2.18.tar.xz"
    mirror "https://downloads.sourceforge.net/project/wine/Source/wine-2.18.tar.xz"
    sha256 "9f0931129878157d717cb39f16cd33bf49f40aac77331c93d0ad30f2ccac4f50"

    # Patch to fix screen-flickering issues. Still relevant on 2.14.
    # https://bugs.winehq.org/show_bug.cgi?id=34166
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/74c2566/wine/2.14.patch"
      sha256 "6907471d18996ada60cc0cbc8462a1698e90720c0882846dfbfb163e5d3899b8"
    end
  end

  if MacOS.version >= :el_capitan
    option "without-win64", "Build without 64-bit support"
    depends_on :xcode => ["8.0", :build] if build.with? "win64"
  end

  # Wine will build both the Mac and the X11 driver by default, and you can switch
  # between them. But if you really want to build without X11, you can.
  depends_on :x11 => :recommended
  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "makedepend" => :build

  resource "gecko-x86" do
    url "https://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86.msi", :using => :nounzip
    sha256 "3b8a361f5d63952d21caafd74e849a774994822fb96c5922b01d554f1677643a"
  end

  resource "gecko-x86_64" do
    url "https://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86_64.msi", :using => :nounzip
    sha256 "c565ea25e50ea953937d4ab01299e4306da4a556946327d253ea9b28357e4a7d"
  end

  resource "mono" do
    url "https://dl.winehq.org/wine/wine-mono/4.7.0/wine-mono-4.7.0.msi", :using => :nounzip
    sha256 "7698474dd9cb9eb80796b5812dff37386ba97b78b21ca23b20079ca5ad6ca5a1"
  end

  resource "openssl" do
    url "https://www.openssl.org/source/openssl-1.0.2l.tar.gz"
    mirror "https://dl.bintray.com/homebrew/mirror/openssl-1.0.2l.tar.gz"
    sha256 "ce07195b659e75f4e1db43552860070061f156a98bb37b672b101ba6e3ddf30c"
  end

  resource "libtool" do
    url "https://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz"
    mirror "https://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.xz"
    sha256 "7c87a8c2c8c0fc9cd5019e402bed4292462d00a718a7cd5f11218153bf28b26f"
  end

  resource "jpeg" do
    url "http://www.ijg.org/files/jpegsrc.v9b.tar.gz"
    mirror "https://mirrors.kernel.org/debian/pool/main/libj/libjpeg9/libjpeg9_9b.orig.tar.gz"
    sha256 "240fd398da741669bf3c90366f58452ea59041cacc741a489b99f2f6a0bad052"
  end

  resource "libtiff" do
    url "http://download.osgeo.org/libtiff/tiff-4.0.8.tar.gz"
    mirror "https://fossies.org/linux/misc/tiff-4.0.8.tar.gz"
    sha256 "59d7a5a8ccd92059913f246877db95a2918e6c04fb9d43fd74e5c3390dac2910"
  end

  resource "little-cms2" do
    url "https://downloads.sourceforge.net/project/lcms/lcms/2.8/lcms2-2.8.tar.gz"
    mirror "https://mirrors.kernel.org/debian/pool/main/l/lcms2/lcms2_2.8.orig.tar.gz"
    sha256 "66d02b229d2ea9474e62c2b6cd6720fde946155cd1d0d2bffdab829790a0fb22"
  end

  resource "libpng" do
    url "https://download.sourceforge.net/libpng/libpng-1.6.31.tar.xz"
    mirror "ftp://ftp-osl.osuosl.org/pub/libpng/src/libpng16/libpng-1.6.31.tar.xz"
    sha256 "232a602de04916b2b5ce6f901829caf419519e6a16cc9cd7c1c91187d3ee8b41"
  end

  resource "freetype" do
    url "https://downloads.sourceforge.net/project/freetype/freetype2/2.8/freetype-2.8.tar.bz2"
    mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.8.tar.bz2"
    sha256 "a3c603ed84c3c2495f9c9331fe6bba3bb0ee65e06ec331e0a0fb52158291b40b"
  end

  resource "libusb" do
    url "https://github.com/libusb/libusb/releases/download/v1.0.21/libusb-1.0.21.tar.bz2"
    mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/libu/libusb-1.0/libusb-1.0_1.0.21.orig.tar.bz2"
    sha256 "7dce9cce9a81194b7065ee912bcd55eeffebab694ea403ffb91b67db66b1824b"
  end

  resource "webp" do
    url "http://downloads.webmproject.org/releases/webp/libwebp-0.6.0.tar.gz"
    sha256 "c928119229d4f8f35e20113ffb61f281eda267634a8dc2285af4b0ee27cf2b40"
  end

  resource "fontconfig" do
    url "https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.4.tar.bz2"
    mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/fontconfig/fontconfig-2.12.4.tar.bz2"
    sha256 "668293fcc4b3c59765cdee5cee05941091c0879edcc24dfec5455ef83912e45c"
  end

  resource "gd" do
    url "https://github.com/libgd/libgd/releases/download/gd-2.2.4/libgd-2.2.4.tar.xz"
    mirror "https://fossies.org/linux/www/libgd-2.2.4.tar.xz"
    sha256 "137f13a7eb93ce72e32ccd7cebdab6874f8cf7ddf31d3a455a68e016ecd9e4e6"
  end

  resource "libgphoto2" do
    url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.14/libgphoto2-2.5.14.tar.bz2"
    mirror "https://fossies.org/linux/privat/libgphoto2-2.5.14.tar.bz2"
    sha256 "d3ce70686fb87d6791b9adcbb6e5693bfbe1cfef9661c23c75eb8a699ec4e274"
  end

  resource "net-snmp" do
    url "https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.7.3/net-snmp-5.7.3.tar.gz"
    sha256 "12ef89613c7707dc96d13335f153c1921efc9d61d3708ef09f3fc4a7014fb4f0"
  end

  resource "sane-backends" do
    url "https://alioth.debian.org/frs/download.php/file/4224/sane-backends-1.0.27.tar.gz"
    mirror "https://mirrors.kernel.org/debian/pool/main/s/sane-backends/sane-backends_1.0.27.orig.tar.gz"
    mirror "https://fossies.org/linux/misc/sane-backends-1.0.27.tar.gz"
    sha256 "293747bf37275c424ebb2c833f8588601a60b2f9653945d5a3194875355e36c9"
  end

  resource "mpg123" do
    url "https://downloads.sourceforge.net/project/mpg123/mpg123/1.25.5/mpg123-1.25.5.tar.bz2"
    mirror "https://mpg123.orgis.org/download/mpg123-1.25.5.tar.bz2"
    sha256 "358da8602c001e6b25dddd496f50540a419e9922f0efe513e890f266135926b1"
  end

  fails_with :clang do
    build 425
    cause "Clang prior to Xcode 5 miscompiles some parts of wine"
  end

  def openssl_arch_args
    {
      :x86_64 => %w[darwin64-x86_64-cc enable-ec_nistp_64_gcc_128],
      :i386 => %w[darwin-i386-cc],
    }
  end

  # Store and restore some of our environment
  def save_env
    saved_cflags = ENV["CFLAGS"]
    saved_ldflags = ENV["LDFLAGS"]
    saved_homebrew_archflags = ENV["HOMEBREW_ARCHFLAGS"]
    saved_homebrew_cccfg = ENV["HOMEBREW_CCCFG"]
    saved_makeflags = ENV["MAKEFLAGS"]
    saved_homebrew_optflags = ENV["HOMEBREW_OPTFLAGS"]
    begin
      yield
    ensure
      ENV["CFLAGS"] = saved_cflags
      ENV["LDFLAGS"] = saved_ldflags
      ENV["HOMEBREW_ARCHFLAGS"] = saved_homebrew_archflags
      ENV["HOMEBREW_CCCFG"] = saved_homebrew_cccfg
      ENV["MAKEFLAGS"] = saved_makeflags
      ENV["HOMEBREW_OPTFLAGS"] = saved_homebrew_optflags
    end
  end

  def install
    ENV.prepend_create_path "PATH", "#{libexec}/bin"
    ENV.prepend_create_path "PKG_CONFIG_PATH", "#{libexec}/lib/pkgconfig"

    resource("openssl").stage do
      save_env do
        ENV.deparallelize
        ENV.permit_arch_flags

        # OpenSSL will prefer the PERL environment variable if set over $PATH
        # which can cause some odd edge cases & isn't intended. Unset for safety,
        # along with perl modules in PERL5LIB.
        ENV.delete("PERL")
        ENV.delete("PERL5LIB")

        archs = Hardware::CPU.universal_archs

        dirs = []
        archs.each do |arch|
          dir = "build-#{arch}"
          dirs << dir
          mkdir_p "#{dir}/engines"
          system "make", "clean"
          system "perl", "./Configure", "--prefix=#{libexec}",
                                        "no-ssl2",
                                        "no-zlib",
                                        "shared",
                                        "enable-cms",
                                        *openssl_arch_args[arch]
          system "make", "depend"
          system "make"
          cp "include/openssl/opensslconf.h", dir
          cp Dir["*.?.?.?.dylib", "*.a", "apps/openssl"], dir
          cp Dir["engines/**/*.dylib"], "#{dir}/engines"
        end

        system "make", "install"

        %w[libcrypto libssl].each do |libname|
          rm_f libexec/"lib/#{libname}.1.0.0.dylib"
          MachO::Tools.merge_machos("#{libexec}/lib/#{libname}.1.0.0.dylib",
                                    "#{dirs.first}/#{libname}.1.0.0.dylib",
                                    "#{dirs.last}/#{libname}.1.0.0.dylib")
          rm_f libexec/"lib/#{libname}.a"
        end

        Dir.glob("#{dirs.first}/engines/*.dylib") do |engine|
          libname = File.basename(engine)
          rm_f libexec/"lib/engines/#{libname}"
          MachO::Tools.merge_machos("#{libexec}/lib/engines/#{libname}",
                                    "#{dirs.first}/engines/#{libname}",
                                    "#{dirs.last}/engines/#{libname}")
        end

        MachO::Tools.merge_machos("#{libexec}/bin/openssl",
                                  "#{dirs.first}/openssl",
                                  "#{dirs.last}/openssl")

        confs = archs.map do |arch|
          <<-EOS.undent
            #ifdef __#{arch}__
            #{(Pathname.pwd/"build-#{arch}/opensslconf.h").read}
            #endif
            EOS
        end
        (libexec/"include/openssl/opensslconf.h").atomic_write confs.join("\n")
      end
    end

    depflags = ["CPPFLAGS=-I#{libexec}/include", "LDFLAGS=-L#{libexec}/lib"]

    # All other resources use ENV.universal_binary
    save_env do
      ENV.universal_binary

      resource("libtool").stage do
        ENV["SED"] = "sed" # prevent libtool from hardcoding sed path from superenv
        system "./configure", "--disable-dependency-tracking",
                              "--prefix=#{libexec}",
                              "--disable-static",
                              "--program-prefix=g",
                              "--enable-ltdl-install"
        system "make", "install"
      end

      resource("jpeg").stage do
        system "./configure", "--disable-dependency-tracking",
                              "--prefix=#{libexec}",
                              "--disable-static"
        system "make", "install"
      end

      resource("libtiff").stage do
        system "./configure", "--disable-dependency-tracking",
                              "--prefix=#{libexec}",
                              "--disable-static",
                              "--disable-lzma",
                              "--without-x",
                              "--with-jpeg-lib-dir=#{libexec}/lib",
                              "--with-jpeg-include-dir=#{libexec}/include"
        system "make", "install"
      end

      resource("little-cms2").stage do
        system "./configure", "--disable-dependency-tracking",
                              "--prefix=#{libexec}",
                              "--disable-static",
                              "--with-jpeg=#{libexec}",
                              "--with-tiff=#{libexec}"
        system "make", "install"
      end

      resource("libpng").stage do
        system "./configure", "--disable-dependency-tracking",
                              "--prefix=#{libexec}",
                              "--disable-static"
        system "make", "install"
      end

      resource("freetype").stage do
        # Enable sub-pixel rendering
        inreplace "include/freetype/config/ftoption.h",
                  "/* #define FT_CONFIG_OPTION_SUBPIXEL_RENDERING */",
                  "#define FT_CONFIG_OPTION_SUBPIXEL_RENDERING"

        system "./configure", "--prefix=#{libexec}",
                              "--disable-static",
                              "--without-harfbuzz",
                              *depflags
        system "make", "install"
      end

      resource("libusb").stage do
        system "./configure", "--disable-dependency-tracking",
                              "--prefix=#{libexec}",
                              "--disable-static"
        system "make", "install"
      end

      resource("webp").stage do
        system "./configure", "--disable-dependency-tracking",
                              "--prefix=#{libexec}",
                              "--disable-static",
                              "--disable-gl",
                              "--enable-libwebpmux",
                              "--enable-libwebpdemux",
                              "--enable-libwebpdecoder",
                              *depflags
        system "make", "install"
      end

      resource("fontconfig").stage do
        system "./configure", "--disable-dependency-tracking",
                              "--prefix=#{libexec}",
                              "--disable-static",
                              "--with-add-fonts=/System/Library/Fonts,/Library/Fonts,~/Library/Fonts",
                              "--localstatedir=#{var}/vendored_wine_fontconfig",
                              "--sysconfdir=#{prefix}",
                              *depflags
        system "make", "install", "RUN_FC_CACHE_TEST=false"
      end

      resource("gd").stage do
        # Poor man's patch as this is a resource
        inreplace "src/gd_gd2.c",
                  "#include <math.h>",
                  "#include <math.h>\n#include <limits.h>"
        system "./configure", "--disable-dependency-tracking",
                              "--prefix=#{libexec}",
                              "--disable-static",
                              "--without-x",
                              "--without-xpm",
                              "--with-png=#{libexec}",
                              "--with-fontconfig=#{libexec}",
                              "--with-freetype=#{libexec}",
                              "--with-jpeg=#{libexec}",
                              "--with-tiff=#{libexec}",
                              "--with-webp=#{libexec}"
        system "make", "install"
      end

      resource("libgphoto2").stage do
        system "./configure", "--disable-dependency-tracking",
                              "--prefix=#{libexec}",
                              *depflags
        system "make", "install"
      end

      resource("net-snmp").stage do
        # https://sourceforge.net/p/net-snmp/bugs/2504/
        ln_s "darwin13.h", "include/net-snmp/system/darwin14.h"
        ln_s "darwin13.h", "include/net-snmp/system/darwin15.h"
        ln_s "darwin13.h", "include/net-snmp/system/darwin16.h"
        ln_s "darwin13.h", "include/net-snmp/system/darwin17.h"

        system "./configure", "--disable-debugging",
                              "--prefix=#{libexec}",
                              "--disable-static",
                              "--enable-ipv6",
                              "--with-defaults",
                              "--with-persistent-directory=#{var}/db/net-snmp_vendored_wine",
                              "--with-logfile=#{var}/log/snmpd_vendored_wine.log",
                              "--with-mib-modules=host\ ucd-snmp/diskio",
                              "--without-rpm",
                              "--without-kmem-usage",
                              "--disable-embedded-perl",
                              "--without-perl-modules",
                              "--with-openssl=#{libexec}",
                              *depflags
        system "make"
        system "make", "install"
      end

      resource("sane-backends").stage do
        save_env do
          system "./configure", "--disable-dependency-tracking",
                                "--prefix=#{libexec}",
                                "--localstatedir=#{var}",
                                "--without-gphoto2",
                                "--enable-local-backends",
                                "--with-usb=yes",
                                *depflags
          # Remove for > 1.0.27
          # Workaround for bug in Makefile.am described here:
          # https://lists.alioth.debian.org/pipermail/sane-devel/2017-August/035576.html.
          # Fixed in https://anonscm.debian.org/cgit/sane/sane-backends.git/commit/?id=519ff57
          system "make"
          system "make", "install"
        end
      end

      resource("mpg123").stage do
        system "./configure", "--disable-debug",
                              "--disable-dependency-tracking",
                              "--prefix=#{libexec}",
                              "--with-default-audio=coreaudio",
                              "--with-module-suffix=.so",
                              "--with-cpu=generic"
        system "make", "install"
      end
    end

    # Help wine find our libraries at runtime
    %w[freetype jpeg png sane tiff].each do |dep|
      ENV["ac_cv_lib_soname_#{dep}"] = (libexec/"lib/lib#{dep}.dylib").realpath
    end

    if build.with? "win64"
      args64 = ["--prefix=#{prefix}"] + depflags
      args64 << "--enable-win64"
      args64 << "--without-x" if build.without? "x11"

      mkdir "wine-64-build" do
        system "../configure", *args64
        system "make", "install"
      end
    end

    args = ["--prefix=#{prefix}"] + depflags
    args << "--with-wine64=../wine-64-build" if build.with? "win64"
    args << "--without-x" if build.without? "x11"

    mkdir "wine-32-build" do
      ENV.m32
      system "../configure", *args
      system "make", "install"
    end
    (pkgshare/"gecko").install resource("gecko-x86")
    (pkgshare/"gecko").install resource("gecko-x86_64")
    (pkgshare/"mono").install resource("mono")
  end

  def caveats
    s = <<-EOS.undent
      You may want to get winetricks:
        brew install winetricks
    EOS

    if build.with? "x11"
      s += <<-EOS.undent

        By default Wine uses a native Mac driver. To switch to the X11 driver, use
        regedit to set the "graphics" key under "HKCU\/Software\/Wine\/Drivers" to
        "x11" (or use winetricks).

        For best results with X11, install the latest version of XQuartz:
          https://www.xquartz.org/
      EOS
    end
    s
  end

  def post_install
    # For fontconfig
    ohai "Regenerating font cache, this may take a while"
    system "#{libexec}/bin/fc-cache", "-frv"

    # For net-snmp
    (var/"db/net-snmp_vendored_wine").mkpath
    (var/"log").mkpath
  end

  test do
    assert_equal shell_output("hostname").chomp, shell_output("#{bin}/wine hostname.exe 2>/dev/null").chomp
    if build.with? "win64"
      assert_equal shell_output("hostname").chomp, shell_output("#{bin}/wine64 hostname.exe 2>/dev/null").chomp
    end
  end
end
