class Gitpush < Formula
  desc "AI-powered Git workflow automation with smart commits and team collaboration"
  homepage "https://gitpush.dev"
  url "https://github.com/karlblock/gitpush/archive/v1.0.0.tar.gz"
  sha256 "0fec210d90ff69554e91ce45a573866a83b42bd8b252e6576ec5db8b05ea2824"
  license "MIT"
  version "1.0.0"

  depends_on "git"
  depends_on "gh" => :optional

  def install
    # Install main script
    bin.install "gitpush.sh" => "gitpush"
    
    # Install library modules
    lib_dir = libexec/"lib"
    lib_dir.mkpath
    cp_r "lib/", lib_dir
    
    # Install plugins
    plugins_dir = libexec/"plugins"
    plugins_dir.mkpath
    cp_r "plugins/", plugins_dir
    
    # Install documentation
    doc.install Dir["*.md"]
    doc.install Dir["docs/*"]
    
    # Install examples
    (share/"gitpush").install ".env.example"
    (share/"gitpush").install ".gitpush.config.example"
    
    # Make executable
    chmod 0755, bin/"gitpush"
  end

  def caveats
    <<~EOS
      Gitpush has been installed! 🚀

      Quick start:
        gitpush --configure    # Set up AI providers
        gitpush               # Interactive mode
        gitpush --help        # See all options

      Configuration files:
        ~/.gitpush/config     # Main configuration
        ~/.gitpush/.env       # API keys (secure)

      VS Code extension:
        Install "Gitpush" from the marketplace for editor integration

      Documentation:
        https://gitpush.dev/docs
    EOS
  end

  test do
    # Test that the binary is installed and executable
    assert_match "gitpush v#{version}", shell_output("#{bin}/gitpush --version")
    
    # Test basic functionality
    system "#{bin}/gitpush", "--help"
  end
end