[private]
default:
  just --list

#
# build
#

# build the website
build: tailwind-build
  hugo

#
# overmind
#

export OVERMIND_CAN_DIE := "tw-build"
export OVERMIND_AUTO_RESTART := "hugo,tailwind"

# run all dev server tasks
dev:
  -! overmind status && [[ -S .overmind.sock ]] && rm -f .overmind.sock
  overmind start

#
# hugo
#

# open the site in a web browser
open:
  open http://localhost:1313

# run hugo dev server
hugo-watch:
  hugo server --disableFastRender

#
# tailwind
#

tw_in := "assets/css/main.css"
tw_out := "assets/css/style.css"

# run tailwind watcher
tailwind-watch:
  pnpm exec tailwindcss \
    --input {{tw_in}} \
    --output {{tw_out}} \
    --watch=always \
    --minify

# build all tailwind assets
tailwind-build:
  pnpm exec tailwindcss \
    --input {{tw_in}} \
    --output {{tw_out}} \
    --minify
