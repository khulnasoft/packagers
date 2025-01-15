# This file is sourced by ./bin/configure-local

record_change() {
  echo "Change recorded: $1, File: $2"
}

gbp_conf=debian/gbp.conf

# Add a debian/gbp.conf file
if [ ! -e "${gbp_conf}" ] || ! grep -qE 'khulnasoft|debian-tag' "${gbp_conf}"; then
  cat <<END > "${gbp_conf}"
[DEFAULT]
debian-branch = khulnasoft/master
debian-tag = khulnasoft/%(version)s
pristine-tar = True

[pq]
patch-numbers = False

[dch]
multimaint-merge = True
END

  if grep -q "XSBC-Original-Maintainer:" debian/control \
  && ! grep -q "\[import-dsc\]" "${gbp_conf}"; then
    cat <<END >> "${gbp_conf}"

[import-dsc]
debian-branch = debian
debian-tag = debian/%(version)s
END
  fi

  record_change "Configure git-buildpackage for Kali" "${gbp_conf}"
fi
