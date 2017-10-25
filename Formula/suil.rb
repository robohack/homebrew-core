class Suil < Formula
  desc "Lightweight C library for loading and wrapping LV2 plugin UIs"
  homepage "https://drobilla.net/software/suil/"
  url "https://download.drobilla.net/suil-0.8.2.tar.bz2"
  sha256 "787608c1e5b1f5051137dbf77c671266088583515af152b77b45e9c3a36f6ae8"

  bottle do
    rebuild 1
    sha256 "1fdfdf3ad22d6898fbc25ac62aed61fdadff229dfa8ae80ecb351b756cd85e4c" => :high_sierra
    sha256 "3b7b1944db83edb792e26ebbd610cb5310357e2f24983ab7dd8be0c0c7dd4aeb" => :sierra
    sha256 "30069bffb5c8f3903f4888135c3d1939f1329a19fda93b3bc8bf244827413995" => :el_capitan
    sha256 "30c20891f724dfe103704e1b3c4e17b068a152fb3098560462a156fba29474c7" => :yosemite
    sha256 "0f82a7cf59da98e7dfbdf437ee22c412eb5e52a821acba2f92b65de4ea7a5fe6" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "gtk+" => :recommended
  depends_on :x11 => :optional

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <suil/suil.h>

      int main()
      {
        return suil_ui_supported("my-host", "my-ui");
      }
    EOS
    lv2 = Formula["lv2"].opt_include
    system ENV.cc, "-I#{lv2}", "-I#{include}/suil-0", "-L#{lib}", "-lsuil-0", "test.c", "-o", "test"
    system "./test"
  end
end
