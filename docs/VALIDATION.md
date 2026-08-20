# Validation

## Development host

Run:

```bash
make test
dpkg-buildpackage --build=binary --no-sign
make source
lintian --profile debian ../halo-keyboard_1.0.0-1_*.changes
```

Inspect the package:

```bash
dpkg-deb --info ../halo-keyboard_1.0.0-1_*.deb
dpkg-deb --contents ../halo-keyboard_1.0.0-1_*.deb
```

The package must contain the handler, service, configuration, udev rule, hwdb
file, manual page, attribution, and license. It must provide/conflict/replace
`touch-keyboard` and must not ship the temporary local pen-rotation rule used
during diagnosis.

## Yoga Book YB1-X91L

After installation and reboot, validate:

1. `halo-keyboard.service` is active in keyboard mode.
2. Keyboard keys and the virtual touchpad work.
3. Both haptic actuators respond.
4. Pen motion in Xournal++ maps up/down/left/right correctly.
5. The display touchscreen and accessibility keyboard still accept touch.
6. Switching between keyboard and pen mode does not rotate the display.
7. A suspend/resume and cold boot introduce no new input or udev errors.

The Wacom orientation result was physically established on a Lenovo YB1-X91L
before being incorporated into the packaged hwdb.
