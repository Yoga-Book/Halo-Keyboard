# Contributing

Keep changes within the keyboard-half input boundary. Kernel, audio, sensor,
and general desktop-policy changes belong in their owning projects.

Before submitting a change:

```bash
make test
dpkg-buildpackage --build=binary --no-sign
```

Hardware quirks must match the narrowest proven device and DMI identity.
Always test display touch and the accessibility keyboard when changing a pen or
touch matrix. Do not broaden the YB1-X91L Wacom match without physical evidence
from the additional model.

Retain copyright and license notices in code derived from the reference
projects. New contributions are accepted under BSD-3-Clause.
