class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  stable do
    url "https://github.com/apollographql/rover/archive/refs/tags/v0.10.0.tar.gz"
    sha256 "5132d1e1f4f5eb3c6e8b2254e7c75c638d35023992869185704e3ead2c99e2ff"

    # Fix build for Rust 1.66.0
    # Upstream commit ref, https://github.com/apollographql/rover/commit/f41e0894824663f62caf8fab6d10a6904449ec39
    # remove in next release
    patch :DATA
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4870951580fd04489eb919d2dd32449b0125966ae08b3b57f763d1e55779bb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7edd5e0cbdb2157440042abb506c6874076c69dc76055dd6ef364f55d4713306"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30fbb6ca81d7bdab3a19527779418d51d1761c13b4b8015c42130240285dc0d1"
    sha256 cellar: :any_skip_relocation, ventura:        "730545ededa10e202f9874927adfc0c896bae32c7cb5399be732470ed5b01d11"
    sha256 cellar: :any_skip_relocation, monterey:       "7818bb257d22e0fdaad8f211d3b5171012687296d4bf418786dfcb3c9c8baef7"
    sha256 cellar: :any_skip_relocation, big_sur:        "79466bed67bcf94fc1e1e6249f1e2e9f7753916cd77b07cd2f43dd686e51dd06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f82800525cdb5b3fd57c07ecbe7813d9f278285e48310b4b7abd13b7de3003b"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @cacheControl", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end

__END__
diff --git a/crates/rover-client/src/operations/graph/check/types.rs b/crates/rover-client/src/operations/graph/check/types.rs
index 842db8e..9074c32 100644
--- a/crates/rover-client/src/operations/graph/check/types.rs
+++ b/crates/rover-client/src/operations/graph/check/types.rs
@@ -22,7 +22,7 @@ impl From<CheckSchemaAsyncInput> for MutationVariables {
             graph_id: input.graph_ref.name,
             name: input.graph_ref.variant,
             input: MutationInput {
-                graph_ref: graph_ref.to_string(),
+                graph_ref: Some(graph_ref.to_string()),
                 proposed_schema_document: Some(input.proposed_schema),
                 git_context: input.git_context.into(),
                 config: input.config.into(),
diff --git a/crates/rover-client/src/operations/subgraph/check/types.rs b/crates/rover-client/src/operations/subgraph/check/types.rs
index 6a76692..cb06d72 100644
--- a/crates/rover-client/src/operations/subgraph/check/types.rs
+++ b/crates/rover-client/src/operations/subgraph/check/types.rs
@@ -23,7 +23,7 @@ impl From<SubgraphCheckAsyncInput> for MutationVariables {
             graph_id: input.graph_ref.name,
             name: input.graph_ref.variant,
             input: MutationInput {
-                graph_ref: graph_ref.to_string(),
+                graph_ref: Some(graph_ref.to_string()),
                 proposed_schema: input.proposed_schema,
                 git_context: input.git_context.into(),
                 config: input.config.into(),
