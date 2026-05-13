require 'minitest/autorun'
require 'fluxycore'
require 'tmpdir'
require 'csv'

class TestFluxyCore < Minitest::Test
  def setup
    @tmpdir = Dir.mktmpdir
    # Assure que le binaire Crystal est compilé (lancé via Rake)
    # On peut le compiler si besoin
  end

  def test_inline_pipeline
    output_path = File.join(@tmpdir, 'out.csv')
    data = [
      { "produit" => "A", "montant" => 10 },
      { "produit" => "A", "montant" => 20 },
      { "produit" => "B", "montant" => 5 }
    ]

    pipeline = FluxyCore::Pipeline.new do
      source :inline, data: data
      transform :aggregate, group_by: 'produit', sum: 'montant', count: true
      sink :csv, path: output_path
    end
    pipeline.run

    rows = CSV.read(output_path, headers: true)
    assert_equal 2, rows.size
    row_a = rows.find { |r| r['produit'] == 'A' }
    assert_equal '30.0', row_a['sum_montant']
    assert_equal '2', row_a['count']
  end
end