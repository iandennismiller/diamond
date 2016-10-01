#!/bin/bash
# based on https://github.com/Homebrew/brew/blob/master/docs/Python-for-Formula-Authors.md#installing
# rebuild with 'make homebrew'

PKG=diamond-patterns

source $(brew --prefix)/bin/virtualenvwrapper.sh

# create virtualenv and install
mktmpenv
cd ~/Work/${PKG}
make install

# use poet to build pip package manifest
pip install homebrew-pypi-poet
poet ${PKG} > /tmp/poet.rb

# extract python package URL
URL=$(perl -n000e 'print $1 while /^..resource\s\"diamond_patterns\"\sdo\n\s+url\s\"(.*?)\"\n.*?\n..end\n\n/mg' /tmp/poet.rb)

# remove package resource from poet manifest
perl -0777 -i.original -pe 's/..resource\s\"diamond_patterns\"\sdo\n.*?\n.*?\n..end\n\n//igs' /tmp/poet.rb

# determine sha256 checksum for python package
curl -q -o /tmp/pkg.tgz ${URL}
SHA=$(shasum -a 256 /tmp/pkg.tgz | cut -d ' ' -f 1 -)
rm /tmp/pkg.tgz

# write header
cat > /tmp/pkg.rb <<-EOF
# Homebrew Formula
# diamond-patterns (c) Ian Dennis Miller
# rebuild with 'make homebrew'

class DiamondPatterns < Formula
  desc "diamond-patterns are systems for doing things"
  homepage "https://github.com/iandennismiller/diamond-patterns"
  url "${URL}"
  sha256 "${SHA}"
  depends_on "imagemagick"

EOF

# write poet manifest
cat /tmp/poet.rb >> /tmp/pkg.rb

# write footer
cat >> /tmp/pkg.rb <<-EOF

  include Language::Python::Virtualenv

  def install
    virtualenv_install_with_resources
  end
end
EOF

# exit virtualenv
deactivate

# finalize
mv /tmp/pkg.rb /tmp/${PKG}.rb
echo "created /tmp/${PKG}.rb"
