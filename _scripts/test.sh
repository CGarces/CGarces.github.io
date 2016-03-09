echo execute html5validator
html5validator --root _site/
echo execute htmlproof
htmlproofer ./_site --check-html --check-favicon --only-4xx
