[private]
default:
  just --list

watch: open
  hugo serve

open:
  open http://localhost:1313
