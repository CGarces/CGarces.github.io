
#!/bin/sh

set -e

title () {
  echo ""
  echo "-------------------------------"
  echo "$1"
  echo "-------------------------------"
  echo ""
}

title "checking site"
bundle exec rake test

title "execute html5validator"
html5validator --root _site/

title "Cleaning up..."
rm -Rf _site
