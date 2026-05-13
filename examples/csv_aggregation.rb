require 'fluxycore'

FluxyCore.pipeline do
  source :file, path: 'data/ventes.csv', format: :csv
  transform :aggregate, group_by: 'produit', sum: 'montant', count: true
  sink :stdout
end