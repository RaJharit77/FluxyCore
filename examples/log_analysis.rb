require 'fluxycore'

FluxyCore.pipeline do
  source :file, path: 'data/access.log', format: :lines
  transform :parse_logs, format: :combined
  transform :aggregate, group_by: 'ip', count: true
  sink :csv, path: 'output/top_ips.csv'
end