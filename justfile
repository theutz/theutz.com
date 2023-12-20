[private]
default:
  just --list

watch: open
  hugo serve

open:
  open http://localhost:1313

tf-import resource name:
  doppler run -c prd --name-transformer tf-var -- terraform import {{resource}} {{name}}
