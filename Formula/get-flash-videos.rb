class GetFlashVideos < Formula
  desc "Download or play videos from various Flash-based websites"
  homepage "https://github.com/monsieurvideo/get-flash-videos"
  url "https://github.com/monsieurvideo/get-flash-videos/archive/1.25.94.tar.gz"
  sha256 "0a12fb9945d772e9c2c5347a712292be47c3f3551dc565b43eb74540370b1bdd"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef67bfb8dbf0a78c4e0df2976ceae3b85d4debafb191ffb4aa4677dee15db056" => :high_sierra
    sha256 "1bc1ddeba3234670bbbd03bdaae15e5014db0306edbf075914466db280c01904" => :sierra
    sha256 "311d82564584099f493d97597e1a2a7d7e611a939f47b9c7d40c78592be79d2c" => :el_capitan
    sha256 "f5493203c42ebcb77fed042135de07639c07b786bf344f336a24e428def4b4ad" => :yosemite
  end

  depends_on "rtmpdump"

  resource "Crypt::Blowfish_PP" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MATTBM/Crypt-Blowfish_PP-1.12.tar.gz"
    sha256 "714f1a3e94f658029d108ca15ed20f0842e73559ae5fc1faee86d4f2195fcf8c"
  end

  resource "LWP::Protocol" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.26.tar.gz"
    sha256 "d0c5435275f8638ff36fff8f655ad2ccad1156e66cc47bfacfb9e44fc585b24f"
  end

  resource "Tie::IxHash" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHORNY/Tie-IxHash-1.23.tar.gz"
    sha256 "fabb0b8c97e67c9b34b6cc18ed66f6c5e01c55b257dcf007555e0b027d4caf56"
  end

  resource "WWW::Mechanize" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/WWW-Mechanize-1.86.tar.gz"
    sha256 "0e5468b89afeff096fb6d9b91a9a58418746c89445fb01adb5caa25ecf32d469"
  end

  resource "Term::ProgressBar" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MANWAR/Term-ProgressBar-2.20.tar.gz"
    sha256 "f9017571fee9eb1ba782a3ec56cc7f085960da8c462701162c973817297b7dae"
  end

  resource "Class::MethodMaker" do
    url "https://cpan.metacpan.org/authors/id/S/SC/SCHWIGON/class-methodmaker/Class-MethodMaker-2.24.tar.gz"
    sha256 "5eef58ccb27ebd01bcde5b14bcc553b5347a0699e5c3e921c7780c3526890328"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    ENV.prepend_create_path "PERL5LIB", lib/"perl5"
    system "make"
    (lib/"perl5").install "blib/lib/FlashVideo"

    bin.install "bin/get_flash_videos"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
    chmod 0755, libexec/"bin/get_flash_videos"

    man1.install "blib/man1/get_flash_videos.1"
  end

  test do
    file = testpath/"BBC_-__Do_whatever_it_takes_to_get_him_to_talk.flv"
    system bin/"get_flash_videos", "http://news.bbc.co.uk/2/hi/programmes/hardtalk/9560793.stm"
    assert_predicate file, :exist?, "Failed to download #{file}!"
  end
end
