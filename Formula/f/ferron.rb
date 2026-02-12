class Ferron < Formula
  desc "Fast, memory-safe web server written in Rust"
  homepage "https://www.ferronweb.org/"
  url "https://mirror.ghproxy.com/https://github.com/ferronweb/ferron/archive/refs/tags/2.5.4.tar.gz"
  sha256 "eb40766242fb66656c81793bbae69fe39ae6c1adf321e4cc58ae1b499ea0e315"
  license "MIT"
  head "https://github.com/ferronweb/ferron.git", branch: "develop-2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a5c97535aac1429c22ec1c3dbbd18109741068ba9b0b35c0017f759875dc706"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "485693977387636cc0e1ae984793719d720a9e98844646bb985c312cef90e2a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9ce29859cc08770edba88f79e1482caa29dca4593cf9cbf0e50b51c80f326cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c728c445cb4ba20ff73f9580fb30189d1e7a0554ee8d46f33f113022d4a1cda2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf0dcdd0c034ef3f88cdfe08efe12fd249e8ee067d94db8e9767ad7d5422e937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c260f55f5550d5321dfab441f473d26aa461746819e893223a02dcaf49ee725f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "ferron")
  end

  test do
    port = free_port

    (testpath/"ferron.yaml").write "global: {\"port\":#{port}}"
    expected_output = <<~HTML.chomp
      <!doctype html>
             <html lang="en">
                 <head>
                     <meta charset="UTF-8" />
                     <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                     <title>404 Not Found</title>
                     <style>html,
      body {
          margin: 0;
          padding: 0;
          font-family:
              system-ui,
              -apple-system,
              BlinkMacSystemFont,
              "Segoe UI",
              Roboto,
              Oxygen,
              Ubuntu,
              Cantarell,
              "Open Sans",
              "Helvetica Neue",
              sans-serif;
          background-color: #ffffff;
          color: #0f172a;
      }

      body {
          padding: 1em;
          -webkit-box-sizing: border-box;
          -moz-box-sizing: border-box;
          box-sizing: border-box;
          width: 100%;
          max-width: 1280px;
          margin: 0 auto;
      }

      header {
          text-align: center;
      }

      h1 {
          font-size: 2.5em;
      }

      a {
          color: #f47825;
      }

      @media screen and (max-width: 512px) {
          h1 {
              font-size: 2em;
          }
      }

      @media screen and (prefers-color-scheme: dark) {
          html,
          body {
              background-color: #14181f;
              color: #f2f2f2;
          }
      }
      </style>
      <style>html {
          height: 100%;
      }

      body {
          display: table;
          -webkit-box-sizing: border-box;
          -moz-box-sizing: border-box;
          box-sizing: border-box;
          width: 100%;
          height: 100%;
      }

      .error-container {
          display: table-cell;
          vertical-align: middle;
          text-align: center;
      }

      .error-code {
          display: block;
          font-size: 4em;
      }

      .error-message {
          display: block;
      }
      </style>
                 </head>
                 <body>
                     <main class="error-container">
            <h1>
                <span class="error-code">404</span>
                <span class="error-message">Not Found</span>
            </h1>
            <p class="error-description">The requested resource wasn't found. Double-check the URL if entered manually.</p>
        </main>
                 </body>
             </html>
    HTML

    begin
      pid = spawn bin/"ferron", "-c", testpath/"ferron.yaml"
      sleep 3
      assert_match expected_output, shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
