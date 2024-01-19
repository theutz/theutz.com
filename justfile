default:
  @just dev

# build the website
build:
  hugo

# run all dev server tasks
dev:
  -! overmind status &>/dev/null && [[ -S .overmind.sock ]] && rm -f .overmind.sock
  overmind start

# open the site in a web browser
open:
  open http://localhost:1313

# run hugo dev server
hugo-watch:
  hugo server
