class RubyAT23 < Formula
  desc "Powerful, clean, object-oriented scripting language"
  homepage "https://www.ruby-lang.org/"
  url "https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.5.tar.xz"
  sha256 "7d3a7dabb190c2da06c963063342ca9a214bcd26f2158e904f0ec059b065ffda"
  revision 1

  bottle do
    sha256 "605435f3ae30cb2b172f35602cbfb3aee7db9e5f3cee30b424845d692eab8e82" => :high_sierra
    sha256 "8aabf6bc30feda15303987ad5956d366a3addc9a2484ae07522d408c01c93810" => :sierra
    sha256 "424e78d39c9bcd09500a3b63e48312c67b4ff4b7699a735e8bd853b5644f6fd6" => :el_capitan
  end

  keg_only :versioned_formula

  option "with-suffix", "Suffix commands with '23'"
  option "with-doc", "Install documentation"
  option "with-tcltk", "Install with Tcl/Tk support"

  depends_on "pkg-config" => :build
  depends_on "readline" => :recommended
  depends_on "gdbm" => :optional
  depends_on "gmp" => :optional
  depends_on "libffi" => :optional
  depends_on "libyaml"
  depends_on "openssl"
  depends_on :x11 if build.with? "tcltk"

  # This should be kept in sync with the main Ruby formula
  # but a revision bump should not be forced every update
  # unless there are security fixes in that Rubygems release.
  resource "rubygems" do
    url "https://rubygems.org/rubygems/rubygems-2.6.14.tgz"
    sha256 "406a45d258707f52241843e9c7902bbdcf00e7edc3e88cdb79c46659b47851ec"
  end

  def program_suffix
    build.with?("suffix") ? "23" : ""
  end

  def ruby
    "#{bin}/ruby#{program_suffix}"
  end

  def api_version
    "2.3.0"
  end

  def install
    # otherwise `gem` command breaks
    ENV.delete("SDKROOT")

    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --disable-silent-rules
      --with-sitedir=#{HOMEBREW_PREFIX}/lib/ruby/site_ruby
      --with-vendordir=#{HOMEBREW_PREFIX}/lib/ruby/vendor_ruby
    ]

    args << "--program-suffix=#{program_suffix}" if build.with? "suffix"
    args << "--with-out-ext=tk" if build.without? "tcltk"
    args << "--disable-install-doc" if build.without? "doc"
    args << "--disable-dtrace" unless MacOS::CLT.installed?
    args << "--without-gmp" if build.without? "gmp"

    paths = [
      Formula["libyaml"].opt_prefix,
      Formula["openssl"].opt_prefix,
    ]

    %w[readline gdbm gmp libffi].each do |dep|
      paths << Formula[dep].opt_prefix if build.with? dep
    end

    args << "--with-opt-dir=#{paths.join(":")}"

    system "./configure", *args

    # Ruby has been configured to look in the HOMEBREW_PREFIX for the
    # sitedir and vendordir directories; however we don't actually want to create
    # them during the install.
    #
    # These directories are empty on install; sitedir is used for non-rubygems
    # third party libraries, and vendordir is used for packager-provided libraries.
    inreplace "tool/rbinstall.rb" do |s|
      s.gsub! 'prepare "extension scripts", sitelibdir', ""
      s.gsub! 'prepare "extension scripts", vendorlibdir', ""
      s.gsub! 'prepare "extension objects", sitearchlibdir', ""
      s.gsub! 'prepare "extension objects", vendorarchlibdir', ""
    end

    system "make"
    system "make", "install"

    # A newer version of ruby-mode.el is shipped with Emacs
    elisp.install Dir["misc/*.el"].reject { |f| f == "misc/ruby-mode.el" }

    # This is easier than trying to keep both current & versioned Ruby
    # formulae repeatedly updated with Rubygem patches.
    resource("rubygems").stage do
      ENV.prepend_path "PATH", bin

      system ruby, "setup.rb", "--prefix=#{buildpath}/vendor_gem"
      rg_in = lib/"ruby/#{api_version}"

      # Remove bundled Rubygem version.
      rm_rf rg_in/"rubygems"
      rm_f rg_in/"rubygems.rb"
      rm_f rg_in/"ubygems.rb"
      rm_f bin/"gem#{program_suffix}"

      # Drop in the new version.
      (rg_in/"rubygems").install Dir[buildpath/"vendor_gem/lib/rubygems/*"]
      rg_in.install buildpath/"vendor_gem/lib/rubygems.rb"
      rg_in.install buildpath/"vendor_gem/lib/ubygems.rb"
      bin.install buildpath/"vendor_gem/bin/gem" => "gem#{program_suffix}"
    end
  end

  def post_install
    # Customize rubygems to look/install in the global gem directory
    # instead of in the Cellar, making gems last across reinstalls
    config_file = lib/"ruby/#{api_version}/rubygems/defaults/operating_system.rb"
    config_file.unlink if config_file.exist?
    config_file.write rubygems_config

    # Create the sitedir and vendordir that were skipped during install
    %w[sitearchdir vendorarchdir].each do |dir|
      mkdir_p `#{ruby} -rrbconfig -e 'print RbConfig::CONFIG["#{dir}"]'`
    end
  end

  def rubygems_bindir
    "#{HOMEBREW_PREFIX}/lib/ruby/gems/#{api_version}/bin"
  end

  def rubygems_config; <<~EOS
    module Gem
      class << self
        alias :old_default_dir :default_dir
        alias :old_default_path :default_path
        alias :old_default_bindir :default_bindir
        alias :old_ruby :ruby
      end

      def self.default_dir
        path = [
          "#{HOMEBREW_PREFIX}",
          "lib",
          "ruby",
          "gems",
          "#{api_version}"
        ]

        @default_dir ||= File.join(*path)
      end

      def self.private_dir
        path = if defined? RUBY_FRAMEWORK_VERSION then
                 [
                   File.dirname(RbConfig::CONFIG['sitedir']),
                   'Gems',
                   RbConfig::CONFIG['ruby_version']
                 ]
               elsif RbConfig::CONFIG['rubylibprefix'] then
                 [
                  RbConfig::CONFIG['rubylibprefix'],
                  'gems',
                  RbConfig::CONFIG['ruby_version']
                 ]
               else
                 [
                   RbConfig::CONFIG['libdir'],
                   ruby_engine,
                   'gems',
                   RbConfig::CONFIG['ruby_version']
                 ]
               end

        @private_dir ||= File.join(*path)
      end

      def self.default_path
        if Gem.user_home && File.exist?(Gem.user_home)
          [user_dir, default_dir, private_dir]
        else
          [default_dir, private_dir]
        end
      end

      def self.default_bindir
        "#{rubygems_bindir}"
      end

      def self.ruby
        "#{opt_bin}/ruby#{program_suffix}"
      end
    end
    EOS
  end

  def caveats; <<~EOS
    By default, binaries installed by gem will be placed into:
      #{rubygems_bindir}

    You may want to add this to your PATH.
  EOS
  end

  test do
    hello_text = shell_output("#{bin}/ruby#{program_suffix} -e 'puts :hello'")
    assert_equal "hello\n", hello_text
    ENV["GEM_HOME"] = testpath
    system "#{bin}/gem#{program_suffix}", "install", "json"
  end
end
