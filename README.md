# Halo Keyboard

Halo Keyboard provides the userspace input integration required by Lenovo Yoga
Book YB1-X9 devices. It converts the Goodix touch surface in the keyboard half
into a virtual keyboard and touchpad, drives the two haptic actuators, and
installs platform-specific input quirks.

The project and Debian package are both named `halo-keyboard`.

## Supported integration

- Lenovo Yoga Book YB1-X90F/L and YB1-X91F/L Halo keyboard surfaces;
- PC-104 and PC-105 keyboard layouts;
- virtual internal touchpad and keyboard devices;
- left and right DRV2604 haptic feedback;
- YB1-X91L Wacom `056A:0169` pen orientation calibration;
- automatic systemd activation through udev.

The Wacom calibration is deliberately restricted to the YB1-X91L and the
`Wacom HID 169 Pen` tablet interface. It does not alter the HiDeep display
touchscreen or the Goodix Halo surface.

## Build

Install the build dependencies on Debian or Ubuntu:

```bash
sudo apt install build-essential cmake debhelper devscripts pkgconf systemd-dev
```

Build and test the program:

```bash
make test
```

Build the Debian package:

```bash
make deb
```

Build the Debian source package from the committed tree:

```bash
make source
```

## Install

```bash
sudo apt install ../halo-keyboard_1.0.0-1_amd64.deb
sudo reboot
```

The reboot lets udev, libinput, and the desktop session reopen every input
device with the packaged hardware database. Test keyboard keys, touchpad,
haptics, pen directions, display touch, and pen/keyboard mode switching.

## Configuration

Configuration is stored in `/etc/halo-keyboard/`:

- `hardware.csv`: physical Goodix geometry and rotation;
- `touchpad.csv`: virtual touchpad rectangle;
- `layouts/`: supplied keyboard layouts;
- `layout.csv`: active layout, created by the package installer.

To select the PC-104 layout:

```bash
sudo ln -sfn layouts/YB1-X9x-pc104.csv /etc/halo-keyboard/layout.csv
sudo systemctl restart halo-keyboard.service
```

## Migration from `touch-keyboard`

The Debian package declares `Provides`, `Conflicts`, and `Replaces` for
`touch-keyboard`. Package installation removes the old binary package before
activating Halo Keyboard. If `/etc/touch_keyboard/layout.csv` still exists, the
maintainer script copies its resolved content into the new configuration.

The package never removes unrelated files from `/etc/touch_keyboard`. After
successful validation, obsolete configuration can be archived manually.

## Scope

Halo Keyboard owns keyboard-half input translation, haptics, and associated
udev/hwdb integration. Kernel drivers, audio/UCM, sensors, display policy, and
other Yoga Book platform services remain in their respective projects.

See [ATTRIBUTION.md](ATTRIBUTION.md) and [LICENSE](LICENSE) for provenance and
licensing.
