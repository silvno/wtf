class WtfAi < Formula
  desc "AI-powered command-line correction tool"
  homepage "https://github.com/silvno/wtf"
  url "https://github.com/silvno/wtf/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c57e29c65bc3f42645c3f2c3cec3c90c5772f0e9fc8ba2e76f14789073515e42"
  license "MIT"

  # Ensures the user has uv installed so your Python script works
  depends_on "uv"

  def install
    # 1. Install the 'ai' script into Homebrew's bin directory
    bin.install "ai"
    
    # 2. Install the 'wtf.sh' wrapper into Homebrew's shared directory
    pkgshare.install "wtf.sh"
  end

  # This is the message Homebrew prints to the user after installation
  def caveats
    <<~EOS
      
      run the following command to make sure you have the default model installed

        ollama pull gemma4:latest

      To enable the 'wtf' typo-correction tool, add the following line 
      to your ~/.zshrc or ~/.bashrc:

        source #{opt_pkgshare}/wtf.sh
        
      Note: The 'ai' command is instantly available without shell configuration.
    EOS
  end
end
