class Exim < Formula
  desc "Complete replacement for sendmail"
  homepage "https://exim.org"
  url "https://ftp.exim.org/pub/exim/exim4/exim-4.89.tar.bz2"
  sha256 "912f2ee03c8dba06a3a4c0ee40522d367e1b65dc59e38dfcc1f5d9eecff51ab0"
  revision 2

  bottle do
    sha256 "e034ee4ff0a3a7c4ba72be9c9dd971dc0e3d26c4559dc30e5c6a67608e54d216" => :high_sierra
    sha256 "cfacabfcec0746abc0b8c285216bec3604de3f5974cba9d70efed4564cfb9972" => :sierra
    sha256 "76f0bff4cbc20acbfc51728c5110ebfb2aa201a14f543fe05f70bd1a77c1e613" => :el_capitan
  end

  deprecated_option "support-maildir" => "with-maildir"
  option "with-maildir", "Support delivery in Maildir format"

  depends_on "pcre"
  depends_on "berkeley-db@4"
  depends_on "openssl"

  # Patch applied upstream but doesn't apply cleanly from git.
  # https://github.com/Exim/exim/commit/65e061b76867a9ea7aeeb535341b790b90ae6c21
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/e/exim4/exim4_4.89-7.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/e/exim4/exim4_4.89-7.debian.tar.xz"
    sha256 "e24464a5a803e4063b32e42543f9a9352ed2fa6bfde7b0f608e59582a23a853f"
    apply "patches/75_fixes_01-Start-exim-4_89-fixes-to-cherry-pick-some-commits-fr.patch"
    apply "patches/75_fixes_02-Cleanup-prevent-repeated-use-of-p-oMr-to-avoid-mem-l.patch"
    apply "patches/75_fixes_03-Fix-log-line-corruption-for-DKIM-status.patch"
    apply "patches/75_fixes_04-Openssl-disable-session-tickets-by-default-and-sessi.patch"
    apply "patches/75_fixes_05-Transport-fix-smtp-under-combo-of-mua_wrapper-and-li.patch"
    apply "patches/75_fixes_07-Openssl-disable-session-tickets-by-default-and-sessi.patch"
    apply "patches/75_fixes_08-Transport-fix-smtp-under-combo-of-mua_wrapper-and-li.patch"
    apply "patches/75_fixes_09-Use-the-BDB-environment-so-that-a-database-config-fi.patch"
    apply "patches/75_fixes_10-Fix-cache-cold-random-callout-verify.-Bug-2147.patch"
    apply "patches/75_fixes_11-On-callout-avoid-SIZE-every-time-but-noncacheable-rc.patch"
    apply "patches/75_fixes_12-Fix-build-for-earlier-version-Berkeley-DB.patch"
  end

  def install
    cp "src/EDITME", "Local/Makefile"
    inreplace "Local/Makefile" do |s|
      s.remove_make_var! "EXIM_MONITOR"
      s.change_make_var! "EXIM_USER", ENV["USER"]
      s.change_make_var! "SYSTEM_ALIASES_FILE", etc/"aliases"
      s.gsub! "/usr/exim/configure", etc/"exim.conf"
      s.gsub! "/usr/exim", prefix
      s.gsub! "/var/spool/exim", var/"spool/exim"
      # https://trac.macports.org/ticket/38654
      s.gsub! 'TMPDIR="/tmp"', "TMPDIR=/tmp"
      s << "SUPPORT_MAILDIR=yes\n" if build.with? "maildir"
      s << "AUTH_PLAINTEXT=yes\n"
      s << "SUPPORT_TLS=yes\n"
      s << "TLS_LIBS=-lssl -lcrypto\n"
      s << "TRANSPORT_LMTP=yes\n"

      # For non-/usr/local HOMEBREW_PREFIX
      s << "LOOKUP_INCLUDE=-I#{HOMEBREW_PREFIX}/include\n"
      s << "LOOKUP_LIBS=-L#{HOMEBREW_PREFIX}/lib\n"
    end

    bdb4 = Formula["berkeley-db@4"]

    inreplace "OS/Makefile-Darwin" do |s|
      s.remove_make_var! %w[CC CFLAGS]
      # Add include and lib paths for BDB 4
      s.gsub! "# Exim: OS-specific make file for Darwin (Mac OS X).", "INCLUDE=-I#{bdb4.include}"
      s.gsub! "DBMLIB =", "DBMLIB=#{bdb4.lib}/libdb-4.dylib"
    end

    # The compile script ignores CPPFLAGS
    ENV.append "CFLAGS", ENV.cppflags

    ENV.deparallelize # See: https://lists.exim.org/lurker/thread/20111109.083524.87c96d9b.en.html
    system "make"
    system "make", "INSTALL_ARG=-no_chown", "install"
    man8.install "doc/exim.8"
    (bin/"exim_ctl").write startup_script
  end

  # Inspired by MacPorts startup script. Fixes restart issue due to missing setuid.
  def startup_script; <<~EOS
    #!/bin/sh
    PID=#{var}/spool/exim/exim-daemon.pid
    case "$1" in
    start)
      echo "starting exim mail transfer agent"
      #{bin}/exim -bd -q30m
      ;;
    restart)
      echo "restarting exim mail transfer agent"
      /bin/kill -15 `/bin/cat $PID` && sleep 1 && #{bin}/exim -bd -q30m
      ;;
    stop)
      echo "stopping exim mail transfer agent"
      /bin/kill -15 `/bin/cat $PID`
      ;;
    *)
      echo "Usage: #{bin}/exim_ctl {start|stop|restart}"
      exit 1
      ;;
    esac
    EOS
  end

  def caveats; <<~EOS
    Start with:
      exim_ctl start
    Don't forget to run it as root to be able to bind port 25.
    EOS
  end

  test do
    assert_match "Mail Transfer Agent", shell_output("#{bin}/exim --help 2>&1", 1)
  end
end
