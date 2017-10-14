class Cockroach < Formula
  desc "Distributed SQL database"
  homepage "https://www.cockroachlabs.com"
  url "https://binaries.cockroachdb.com/cockroach-v1.0.6.src.tgz"
  version "1.0.6"
  sha256 "1f9b867385f6d99e8ff0f15b66e6bf7205b14617030db7482641627472eae0c8"
  head "https://github.com/cockroachdb/cockroach.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc7b77d7f33a5e545fac6d5bf725b135466f5d482c8d0c4c19e484b470710b69" => :high_sierra
    sha256 "9d6e1e5e3e6596019aec5e9658a15aea60f53894e9344f3f2f13d63aacd4cda3" => :sierra
    sha256 "104c97aace081d38ec050fe2de8b23bdc99986aafb123943d29ea8d1e3794de5" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "xz" => :build

  def install
    # unpin the Go version
    go_version = Formula["go"].installed_version.to_s.split(".")[0, 2].join(".")
    inreplace "src/github.com/cockroachdb/cockroach/.go-version",
              /^GOVERS = go.*/, "GOVERS = go#{go_version.gsub(".", "\\.")}.*"

    system "make", "install", "prefix=#{prefix}"
  end

  def caveats; <<-EOS.undent
    For local development only, this formula ships a launchd configuration to
    start a single-node cluster that stores its data under:
      #{var}/cockroach/
    Instead of the default port of 8080, the node serves its admin UI at:
      #{Formatter.url("http://localhost:26256")}

    Do NOT use this cluster to store data you care about; it runs in insecure
    mode and may expose data publicly in e.g. a DNS rebinding attack. To run
    CockroachDB securely, please see:
      #{Formatter.url("https://www.cockroachlabs.com/docs/secure-a-cluster.html")}
    EOS
  end

  plist_options :manual => "cockroach start --insecure"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/cockroach</string>
        <string>start</string>
        <string>--store=#{var}/cockroach/</string>
        <string>--http-port=26256</string>
        <string>--insecure</string>
        <string>--host=localhost</string>
      </array>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    begin
      # Redirect stdout and stderr to a file, or else  `brew test --verbose`
      # will hang forever as it waits for stdout and stderr to close.
      system "#{bin}/cockroach start --insecure --background &> start.out"
      pipe_output("#{bin}/cockroach sql --insecure", <<-EOS.undent)
        CREATE DATABASE bank;
        CREATE TABLE bank.accounts (id INT PRIMARY KEY, balance DECIMAL);
        INSERT INTO bank.accounts VALUES (1, 1000.50);
      EOS
      output = pipe_output("#{bin}/cockroach sql --insecure --format=csv",
        "SELECT * FROM bank.accounts;")
      assert_equal <<-EOS.undent, output
        1 row
        id,balance
        1,1000.50
      EOS
    ensure
      system "#{bin}/cockroach", "quit", "--insecure"
    end
  end
end
