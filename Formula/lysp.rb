class Lysp < Formula
  desc "Small Lisp interpreter"
  homepage "http://www.piumarta.com/software/lysp/"
  url "http://www.piumarta.com/software/lysp/lysp-1.1.tar.gz"
  sha256 "436a8401f8a5cc4f32108838ac89c0d132ec727239d6023b9b67468485509641"
  revision 2

  bottle do
    cellar :any
    sha256 "a77bc33a80d02bd6c65e79e309c30e919f38ab4325f12a24c8ef6ac9e84f527e" => :high_sierra
    sha256 "2df5511a5b16985ed83a970676d5b036b3d0da71ea10111efa062ee25fe645c3" => :sierra
    sha256 "b2f49069f38198ed4310157fcc1b29c04d3a84e6580ac3d27592aea2f8414f70" => :el_capitan
    sha256 "7115864fbe2c8578657afc60736ee1c0de91712524c874bccece4f18eae1c06a" => :yosemite
  end

  depends_on "bdw-gc"
  depends_on "gcc"

  fails_with :clang do
    cause "use of unknown builtin '__builtin_return'"
  end

  # Use our CFLAGS
  patch :DATA

  def install
    # this option is supported only for ELF object files
    inreplace "Makefile", "-rdynamic", ""

    system "make", "CC=#{ENV.cc}"
    bin.install "lysp", "gclysp"
  end

  test do
    (testpath/"test.l").write <<~EOS
      (define println (subr (dlsym "printlnSubr")))
      (define + (subr (dlsym "addSubr")))
      (println (+ 40 2))
    EOS

    assert_equal "42", shell_output("#{bin}/lysp test.l").chomp
  end
end

__END__
diff --git a/Makefile b/Makefile
index fc3f5d9..0b0e20d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,3 @@
-CFLAGS  = -O  -g -Wall
-CFLAGSO = -O3 -g -Wall -DNDEBUG
-CFLAGSs = -Os -g -Wall -DNDEBUG
 LDLIBS  = -rdynamic
 
 all : lysp gclysp
@@ -10,15 +7,15 @@ lysp : lysp.c gc.c
 	size $@
 
 olysp: lysp.c gc.c
-	$(CC) $(CFLAGSO) -DBDWGC=0 -o $@ lysp.c gc.c $(LDLIBS) -ldl
+	$(CC) $(CFLAGS) -DBDWGC=0 -o $@ lysp.c gc.c $(LDLIBS) -ldl
 	size $@
 
 ulysp: lysp.c gc.c
-	$(CC) $(CFLAGSs) -DBDWGC=0 -o $@ lysp.c gc.c $(LDLIBS) -ldl
+	$(CC) $(CFLAGS) -DBDWGC=0 -o $@ lysp.c gc.c $(LDLIBS) -ldl
 	size $@
 
 gclysp: lysp.c
-	$(CC) $(CFLAGSO) -DBDWGC=1  -o $@ lysp.c $(LDLIBS) -lgc
+	$(CC) $(CFLAGS) -DBDWGC=1  -o $@ lysp.c $(LDLIBS) -lgc
 	size $@
 
 run : all
