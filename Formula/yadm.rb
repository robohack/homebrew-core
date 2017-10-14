class Yadm < Formula
  desc "Yet Another Dotfiles Manager"
  homepage "https://thelocehiliosan.github.io/yadm/"
  url "https://github.com/TheLocehiliosan/yadm/archive/1.11.1.tar.gz"
  sha256 "7074c08a317c627106cef3663f2ab05b6397fdf3e2f9186730368b44a26d8fe4"

  bottle :unneeded

  def install
    bin.install "yadm"
    man1.install "yadm.1"
    bash_completion.install "completion/yadm.bash_completion"
  end

  test do
    system bin/"yadm", "init"
    assert_predicate testpath/".yadm/repo.git/config", :exist?, "Failed to init repository."
    assert_match testpath.to_s, shell_output("#{bin}/yadm gitconfig core.worktree")

    # disable auto-alt
    system bin/"yadm", "config", "yadm.auto-alt", "false"
    assert_match "false", shell_output("#{bin}/yadm config yadm.auto-alt")

    (testpath/"testfile").write "test"
    system bin/"yadm", "add", "#{testpath}/testfile"

    system bin/"yadm", "gitconfig", "user.email", "test@test.org"
    system bin/"yadm", "gitconfig", "user.name", "Test User"

    system bin/"yadm", "commit", "-m", "test commit"
    assert_match "test commit", shell_output("#{bin}/yadm log --pretty=oneline 2>&1")
  end
end
