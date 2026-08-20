#!/usr/bin/env bash
# SPDX-License-Identifier: BSD-3-Clause

set -Eeuo pipefail

root=${1:?project root is required}

required_files=(
	60-halo-keyboard.rules
	61-halo-keyboard.hwdb
	ATTRIBUTION.md
	LICENSE
	README.md
	halo-keyboard.service
	hardware.csv
	touchpad.csv
	debian/control
	debian/copyright
	debian/halo-keyboard.postinst
	debian/source/options
)

for file in "${required_files[@]}"; do
	[[ -s $root/$file ]] || {
		echo "missing required project file: $file" >&2
		exit 1
	}
done

grep -Fq 'ExecStart=/usr/sbin/halo-keyboard-handler' "$root/halo-keyboard.service"
grep -Fq 'WorkingDirectory=/etc/halo-keyboard' "$root/halo-keyboard.service"
grep -Fq 'SYMLINK+="halo_keyboard"' "$root/60-halo-keyboard.rules"
grep -Fq 'ENV{SYSTEMD_WANTS}+="halo-keyboard.service"' "$root/60-halo-keyboard.rules"
grep -Fq 'Package: halo-keyboard' "$root/debian/control"
grep -Eq '^ udev,$' "$root/debian/control"
grep -Fq 'Provides: touch-keyboard' "$root/debian/control"
grep -Fq 'Conflicts: touch-keyboard' "$root/debian/control"
grep -Fq 'Replaces: touch-keyboard' "$root/debian/control"
grep -Fq 'deccecb08889aa031664f5e22ec5c4c33fb6c41c' "$root/ATTRIBUTION.md"
grep -Fxq '3.0 (quilt)' "$root/debian/source/format"
grep -Fq 'extend-diff-ignore' "$root/debian/source/options"

if grep -R -n -E '/etc/touch_keyboard|touch-keyboard-handler\.service|/dev/touch_keyboard' \
		"$root" \
		--exclude-dir=.git \
		--exclude-dir=.debhelper \
		--exclude-dir=build \
		--exclude-dir='obj-*' \
		--exclude-dir=halo-keyboard \
		--exclude=README.md \
		--exclude='*.postinst' \
		--exclude=check-maintainer-scripts.sh \
		--exclude=check-project.sh; then
	echo 'legacy runtime name found outside documented migration code' >&2
	exit 1
fi

echo 'project metadata: PASS'
