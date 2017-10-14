class Root < Formula
  desc "Object oriented framework for large scale data analysis"
  homepage "https://root.cern.ch"
  url "https://root.cern.ch/download/root_v6.10.06.source.tar.gz"
  version "6.10.06"
  sha256 "02ba62b2a732f4f8d7beecb29556545cc30d122bc87da904473de69a8972ed74"
  head "http://root.cern.ch/git/root.git"

  bottle do
    sha256 "d7b475b07c9b70ed7d2ed3d54a339dcdf977ccabe8ca02f19a10964cf114ba6a" => :high_sierra
    sha256 "e34e041f0204a3361e8c84519cbb18675f1efd89bbc806d0c4a062aedb317d99" => :sierra
    sha256 "27072e27a0af013c7daf578244ff029a6c51eedcdbabf58356e2a19c62873bc0" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "graphviz"
  depends_on "gsl"
  depends_on "openssl"
  depends_on "xrootd"
  depends_on :fortran
  depends_on :python => :recommended
  depends_on :python3 => :optional

  needs :cxx11

  skip_clean "bin"

  # 3 upstream commits that fix compilation with Xcode 9
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://github.com/root-project/root/commit/26350842.patch?full_index=1"
      sha256 "27d29c775d8c8100ebd7f206eeb8364a30015f39a1af1a00203ef80ff1a04cd9"
    end

    patch do
      url "https://github.com/root-project/root/commit/9339de9e.patch?full_index=1"
      sha256 "f7386c626fcc64791cfcbe35a0efc10c245c10e4f0547687334592da70c99ab5"
    end

    patch do
      url "https://github.com/root-project/root/commit/7d585604.patch?full_index=1"
      sha256 "3ff15aa6f15621d14d07de06ed4e31f901d07da54695fae1948dba5e2884fc8f"
    end
  end

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    ENV.delete("SDKROOT") if DevelopmentTools.clang_build_version >= 900

    args = std_cmake_args + %W[
      -Dgnuinstall=ON
      -DCMAKE_INSTALL_ELISPDIR=#{share}/emacs/site-lisp/#{name}
      -Dbuiltin_freetype=ON
      -Dfftw3=ON
      -Dfortran=ON
      -Dmathmore=ON
      -Dminuit2=ON
      -Droofit=ON
      -Dssl=ON
      -Dxrootd=ON
    ]

    if build.with?("python3") && build.with?("python")
      odie "Root: Does not support building both python 2 and 3 wrappers"
    elsif build.with?("python") || build.with?("python3")
      python_executable = `which python`.strip if build.with? "python"
      python_executable = `which python3`.strip if build.with? "python3"
      python_prefix = `#{python_executable} -c 'import sys;print(sys.prefix)'`.chomp
      python_include = `#{python_executable} -c 'from distutils import sysconfig;print(sysconfig.get_python_inc(True))'`.chomp
      python_version = "python" + `#{python_executable} -c 'import sys;print(sys.version[:3])'`.chomp

      # cmake picks up the system's python dylib, even if we have a brewed one
      if File.exist? "#{python_prefix}/Python"
        python_library = "#{python_prefix}/Python"
      elsif File.exist? "#{python_prefix}/lib/lib#{python_version}.a"
        python_library = "#{python_prefix}/lib/lib#{python_version}.a"
      elsif File.exist? "#{python_prefix}/lib/lib#{python_version}.dylib"
        python_library = "#{python_prefix}/lib/lib#{python_version}.dylib"
      else
        odie "No libpythonX.Y.{a,dylib} file found!"
      end
      args << "-DPYTHON_EXECUTABLE='#{python_executable}'"
      args << "-DPYTHON_INCLUDE_DIR='#{python_include}'"
      args << "-DPYTHON_LIBRARY='#{python_library}'"
    end
    if build.with?("python") || build.with?("python3")
      args << "-Dpython=ON"
    else
      args << "-Dpython=OFF"
    end

    mkdir "builddir" do
      system "cmake", "..", *args

      # Work around superenv stripping out isysroot leading to errors with
      # libsystem_symptoms.dylib (only available on >= 10.12) and
      # libsystem_darwin.dylib (only available on >= 10.13)
      if MacOS.version < :high_sierra
        system "xcrun", "make", "install"
      else
        system "make", "install"
      end

      chmod 0755, Dir[bin/"*.*sh"]
    end
  end

  def caveats; <<-EOS.undent
    Because ROOT depends on several installation-dependent
    environment variables to function properly, you should
    add the following commands to your shell initialization
    script (.bashrc/.profile/etc.), or call them directly
    before using ROOT.

    For bash users:
      . #{HOMEBREW_PREFIX}/bin/thisroot.sh
    For zsh users:
      pushd #{HOMEBREW_PREFIX} >/dev/null; . bin/thisroot.sh; popd >/dev/null
    For csh/tcsh users:
      source #{HOMEBREW_PREFIX}/bin/thisroot.csh
    EOS
  end

  test do
    (testpath/"test.C").write <<-EOS.undent
      #include <iostream>
      void test() {
        std::cout << "Hello, world!" << std::endl;
      }
    EOS
    (testpath/"test.bash").write <<-EOS.undent
      . #{bin}/thisroot.sh
      root -l -b -n -q test.C
    EOS
    assert_equal "\nProcessing test.C...\nHello, world!\n",
                 shell_output("/bin/bash test.bash")
  end
end
