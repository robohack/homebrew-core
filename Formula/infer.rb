class Infer < Formula
  desc "Static analyzer for Java, C and Objective-C"
  homepage "http://fbinfer.com/"
  url "https://github.com/facebook/infer/releases/download/v0.12.1/infer-osx-v0.12.1.tar.xz"
  sha256 "ce76b87bf4f70be594aaddc7402609af6338623fbb448dacca610e10bcb7c60a"

  bottle do
    cellar :any
    sha256 "57643d1549a778596cce9a4926298dd4adafea4c12995a14564a8fd4dc07a563" => :sierra_or_later
    sha256 "667715c360743f6f3d865043da3ce423baf123f3a5e6e775ac16fb9d5e839333" => :el_capitan
    sha256 "607cc291dbc3aa11836b975d2bcc47b7f700c9fbcf4ae83910312baed9ef0843" => :yosemite
  end

  option "without-clang", "Build without C/Objective-C analyzer"
  option "without-java", "Build without Java analyzer"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build

  def install
    if build.without?("clang") && build.without?("java")
      odie "infer: --without-clang and --without-java are mutually exclusive"
    end

    opamroot = buildpath/"opamroot"
    opamroot.mkpath
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"

    # Some of the libraries installed by ./build-infer.sh do not
    # support parallel builds, eg OCaml itself. ./build-infer.sh
    # builds in its own parallelization logic to mitigate that.
    ENV.deparallelize

    ENV["INFER_CONFIGURE_OPTS"] = "--prefix=#{prefix} --disable-ocaml-binannot"

    target_platform = if build.without?("clang")
      "java"
    elsif build.without?("java")
      "clang"
    else
      "all"
    end

    system "opam", "init", "--no-setup"
    ocaml_version = File.read("build-infer.sh").match(/OCAML_VERSION=\"([0-9\.]+)\"/)[1]
    inreplace "#{opamroot}/compilers/#{ocaml_version}/#{ocaml_version}/#{ocaml_version}.comp",
      '["./configure"', '["./configure" "-no-graph"'
    system "./build-infer.sh", target_platform, "--yes"
    system "opam", "config", "exec", "--switch=infer-#{ocaml_version}", "--", "make", "install"
  end

  test do
    (testpath/"FailingTest.c").write <<~EOS
      #include <stdio.h>

      int main() {
        int *s = NULL;
        *s = 42;

        return 0;
      }
    EOS

    (testpath/"PassingTest.c").write <<~EOS
      #include <stdio.h>

      int main() {
        int *s = NULL;
        if (s != NULL) {
          *s = 42;
        }

        return 0;
      }
    EOS

    shell_output("#{bin}/infer --fail-on-issue -- clang -c FailingTest.c", 2)
    shell_output("#{bin}/infer --fail-on-issue -- clang -c PassingTest.c", 0)

    (testpath/"FailingTest.java").write <<~EOS
      class FailingTest {

        String mayReturnNull(int i) {
          if (i > 0) {
            return "Hello, Infer!";
          }
          return null;
        }

        int mayCauseNPE() {
          String s = mayReturnNull(0);
          return s.length();
        }
      }
    EOS

    (testpath/"PassingTest.java").write <<~EOS
      class PassingTest {

        String mayReturnNull(int i) {
          if (i > 0) {
            return "Hello, Infer!";
          }
          return null;
        }

        int mayCauseNPE() {
          String s = mayReturnNull(0);
          return s == null ? 0 : s.length();
        }
      }
    EOS

    shell_output("#{bin}/infer --fail-on-issue -- javac FailingTest.java", 2)
    shell_output("#{bin}/infer --fail-on-issue -- javac PassingTest.java", 0)
  end
end
