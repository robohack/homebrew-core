# Reference: https://github.com/macvim-dev/macvim/wiki/building
class Macvim < Formula
  desc "GUI for vim, made for macOS"
  homepage "https://github.com/macvim-dev/macvim"
  url "https://github.com/macvim-dev/macvim/archive/snapshot-140.tar.gz"
  version "8.0-140"
  sha256 "693a1f038907d4a79ebc08c3aee4158390b08177844e7c8c450510778153f46d"
  head "https://github.com/macvim-dev/macvim.git"

  bottle do
    sha256 "98e8f603b8f2e3476987ddd903c0fc2ffe14607fa388cd1418d665c27458ff42" => :high_sierra
    sha256 "5cc31ff65a520c5d10b1460696a25d25091b2a62814df4a2ea6b47b935c23048" => :sierra
    sha256 "fb4cb5281e494f708f7c5e18e9c69e822e784c053283af22ee519d604ded4f22" => :el_capitan
  end

  option "with-override-system-vim", "Override system vim"

  deprecated_option "override-system-vim" => "with-override-system-vim"

  depends_on :xcode => :build
  depends_on "cscope" => :recommended
  depends_on "lua" => :optional
  depends_on "luajit" => :optional

  if MacOS.version >= :mavericks
    option "with-custom-python", "Build with a custom Python 2 instead of the Homebrew version."
  end

  depends_on :python => :recommended
  depends_on :python3 => :optional

  def install
    # Avoid issues finding Ruby headers
    if MacOS.version == :sierra || MacOS.version == :yosemite
      ENV.delete("SDKROOT")
    end

    # MacVim doesn't have or require any Python package, so unset PYTHONPATH
    ENV.delete("PYTHONPATH")

    # If building for OS X 10.7 or up, make sure that CC is set to "clang"
    ENV.clang if MacOS.version >= :lion

    args = %W[
      --with-features=huge
      --enable-multibyte
      --with-macarchs=#{MacOS.preferred_arch}
      --enable-perlinterp
      --enable-rubyinterp
      --enable-tclinterp
      --enable-terminal
      --with-tlib=ncurses
      --with-compiledby=Homebrew
      --with-local-dir=#{HOMEBREW_PREFIX}
    ]

    args << "--enable-cscope" if build.with? "cscope"

    if build.with? "lua"
      args << "--enable-luainterp"
      args << "--with-lua-prefix=#{Formula["lua"].opt_prefix}"
    end

    if build.with? "luajit"
      args << "--enable-luainterp"
      args << "--with-lua-prefix=#{Formula["luajit"].opt_prefix}"
      args << "--with-luajit"
    end

    # Allow python or python3, but not both; if the optional
    # python3 is chosen, default to it; otherwise, use python2
    if build.with? "python3"
      args << "--enable-python3interp"
    elsif build.with? "python"
      ENV.prepend "LDFLAGS", `python-config --ldflags`.chomp

      # Needed for <= OS X 10.9.2 with Xcode 5.1
      ENV.prepend "CFLAGS", `python-config --cflags`.chomp.gsub(/-mno-fused-madd /, "")

      framework_script = <<~EOS
        import sysconfig
        print sysconfig.get_config_var("PYTHONFRAMEWORKPREFIX")
      EOS
      framework_prefix = `python -c '#{framework_script}'`.strip
      # Non-framework builds should have PYTHONFRAMEWORKPREFIX defined as ""
      if framework_prefix.include?("/") && framework_prefix != "/System/Library/Frameworks"
        ENV.prepend "LDFLAGS", "-F#{framework_prefix}"
        ENV.prepend "CFLAGS", "-F#{framework_prefix}"
      end
      args << "--enable-pythoninterp"
    end

    system "./configure", *args
    system "make"

    prefix.install "src/MacVim/build/Release/MacVim.app"
    bin.install_symlink prefix/"MacVim.app/Contents/bin/mvim"

    # Create MacVim vimdiff, view, ex equivalents
    executables = %w[mvimdiff mview mvimex gvim gvimdiff gview gvimex]
    executables += %w[vi vim vimdiff view vimex] if build.with? "override-system-vim"
    executables.each { |e| bin.install_symlink "mvim" => e }
  end

  def caveats
    if build.with?("python") && build.with?("python3")
      <<~EOS
        MacVim can no longer be brewed with dynamic support for both Python versions.
        Only Python 3 support has been provided.
      EOS
    end
  end

  test do
    ENV.prepend_path "PATH", Formula["python"].opt_libexec/"bin"
    # Simple test to check if MacVim was linked to Python version in $PATH
    if build.with? "python"
      system_framework_path = `python-config --exec-prefix`.chomp
      assert_match system_framework_path, `mvim --version`
    end
    assert_match "+ruby", shell_output("#{bin}/mvim --version")
  end
end
