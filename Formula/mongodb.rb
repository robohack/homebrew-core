require "language/go"

class Mongodb < Formula
  desc "High-performance, schema-free, document-oriented database"
  homepage "https://www.mongodb.org/"

  stable do
    url "https://fastdl.mongodb.org/src/mongodb-src-r3.4.10.tar.gz"
    sha256 "443800ca4f52fa613b29052f5f76abc0ccc477451b55f3665b61819f28ace2f3"

    go_resource "github.com/mongodb/mongo-tools" do
      url "https://github.com/mongodb/mongo-tools.git",
          :tag => "r3.4.10",
          :revision => "4f093ae71cdb4c6a6e9de7cd1dc67ea4405f0013",
          :shallow => false
    end
  end

  bottle do
    sha256 "9d9929d9502d958840929355daf8a3c71ce6779d63b0a3ab4123562e1c840b2c" => :high_sierra
    sha256 "715942c2e23e39ac1ad365860cb084d53bb2b35aef1fae2df4e38a18434438ef" => :sierra
    sha256 "5bdb6c3a4fea9d74afd54497f3b508c2f85034ff9de6a92b15783dadb06e575a" => :el_capitan
  end

  devel do
    url "https://fastdl.mongodb.org/src/mongodb-src-r3.5.13.tar.gz"
    sha256 "6c305cca87fb31f9d93990ee31f878dbb9b280ca8fce77d1ac1cb331bc29fec7"

    depends_on :xcode => ["8.3.2", :build]

    resource "PyYAML" do
      url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
      sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
    end

    resource "typing" do
      url "https://files.pythonhosted.org/packages/ca/38/16ba8d542e609997fdcd0214628421c971f8c395084085354b11ff4ac9c3/typing-3.6.2.tar.gz"
      sha256 "d514bd84b284dd3e844f0305ac07511f097e325171f6cc4a20878d11ad771849"
    end

    go_resource "github.com/mongodb/mongo-tools" do
      url "https://github.com/mongodb/mongo-tools.git",
          :tag => "r3.5.13",
          :revision => "8bda55730d30c414a71dfbe6f45f5c54ef97811d"
    end
  end

  option "with-boost", "Compile using installed boost, not the version shipped with mongodb"
  option "with-sasl", "Compile with SASL support"

  depends_on "boost" => :optional
  depends_on "go" => :build
  depends_on :macos => :mountain_lion
  depends_on "scons" => :build
  depends_on "openssl" => :recommended

  needs :cxx11

  def install
    ENV.cxx11 if MacOS.version < :mavericks

    if build.devel?
      ENV.libcxx

      ["PyYAML", "typing"].each do |r|
        resource(r).stage do
          system "python", *Language::Python.setup_install_args(buildpath/"vendor")
        end
      end
    end
    (buildpath/".brew_home/Library/Python/2.7/lib/python/site-packages/vendor.pth").write <<~EOS
      import site; site.addsitedir("#{buildpath}/vendor/lib/python2.7/site-packages")
    EOS

    # New Go tools have their own build script but the server scons "install" target is still
    # responsible for installing them.
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/mongodb/mongo-tools" do
      args = %w[]

      if build.with? "openssl"
        args << "ssl"
        ENV["LIBRARY_PATH"] = Formula["openssl"].opt_lib
        ENV["CPATH"] = Formula["openssl"].opt_include
      end

      args << "sasl" if build.with? "sasl"

      system "./build.sh", *args
    end

    mkdir "src/mongo-tools"
    cp Dir["src/github.com/mongodb/mongo-tools/bin/*"], "src/mongo-tools/"

    args = %W[
      --prefix=#{prefix}
      -j#{ENV.make_jobs}
    ]

    args << "--osx-version-min=#{MacOS.version}" if build.stable?
    args << "CC=#{ENV.cc}"
    args << "CXX=#{ENV.cxx}"

    if build.devel?
      args << "CCFLAGS=-mmacosx-version-min=#{MacOS.version}"
      args << "LINKFLAGS=-mmacosx-version-min=#{MacOS.version}"
    end

    args << "--use-sasl-client" if build.with? "sasl"
    args << "--use-system-boost" if build.with? "boost"
    args << "--use-new-tools"
    args << "--build-mongoreplay=true"
    args << "--disable-warnings-as-errors" if MacOS.version >= :yosemite

    if build.with? "openssl"
      args << "--ssl"

      args << "CCFLAGS=-I#{Formula["openssl"].opt_include}"
      args << "LINKFLAGS=-L#{Formula["openssl"].opt_lib}"
    end

    scons "install", *args

    (buildpath/"mongod.conf").write mongodb_conf
    etc.install "mongod.conf"
  end

  def post_install
    (var/"mongodb").mkpath
    (var/"log/mongodb").mkpath
  end

  def mongodb_conf; <<~EOS
    systemLog:
      destination: file
      path: #{var}/log/mongodb/mongo.log
      logAppend: true
    storage:
      dbPath: #{var}/mongodb
    net:
      bindIp: 127.0.0.1
    EOS
  end

  plist_options :manual => "mongod --config #{HOMEBREW_PREFIX}/etc/mongod.conf"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/mongod</string>
        <string>--config</string>
        <string>#{etc}/mongod.conf</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/mongodb/output.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/mongodb/output.log</string>
      <key>HardResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>4096</integer>
      </dict>
      <key>SoftResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>4096</integer>
      </dict>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/mongod", "--sysinfo"
  end
end
