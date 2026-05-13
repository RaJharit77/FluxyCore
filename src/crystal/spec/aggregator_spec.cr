require "./spec_helper"

describe Transformers::Aggregator do
  it "groups and sums correctly" do
    input = [
      {"produit" => "A", "montant" => 10},
      {"produit" => "A", "montant" => 20},
      {"produit" => "B", "montant" => 5}
    ].map(&.to_json).join("\n")

    # Simule stdin et capture stdout
    io_in = IO::Memory.new(input)
    io_out = IO::Memory.new

    # Redirige STDIN/STDOUT temporairement
    original_in = STDIN
    original_out = STDOUT
    STDIN = io_in
    STDOUT = io_out

    begin
      Transformers::Aggregator.run(["--group-by", "produit", "--sum", "montant", "--count"])
    ensure
      STDIN = original_in
      STDOUT = original_out
    end

    results = io_out.to_s.strip.lines.map { |l| JSON.parse(l) }
    results.size.should eq(2)

    a = results.find { |r| r["produit"] == "A" }.not_nil!
    a["sum_montant"].as_f.should eq(30.0)
    a["count"].as_i.should eq(2)

    b = results.find { |r| r["produit"] == "B" }.not_nil!
    b["sum_montant"].as_f.should eq(5.0)
    b["count"].as_i.should eq(1)
  end
end