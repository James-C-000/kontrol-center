# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.12.0] - 2026-10-29
Forked from [EliverLara/kde-control-station](https://github.com/EliverLara/kde-control-station) (`plasma6`, store version 2.11.0).

### Added
- Notification center: the widget hosts Plasma's notification server and lists notifications on a new
  page instead of showing popups, with action buttons, dismiss, Clear All, Do Not Disturb and a shortcut
  to notification settings. Apps hidden from popups in System Settings are hidden from the list.
- Unread notification badges on the Notifications tile and the panel icon.
- VPN tile (WireGuard included): the icon toggles the most recently used VPN, the tile opens the network list.
  Also available in the Custom layout.

### Changed
- Cards are flat surfaces tinted from the color scheme, with Breeze corner radii and an accent outline on hover,
  replacing the drop shadows and fixed outlines.
- Fonts and spacing follow the system theme (still multiplied by the Scale setting).
- Plasma's native sliders are used by default; the custom sliders use theme colors.
- All toggle tiles share the same rounded icon well, and use icons from the icon theme.
- The Do Not Disturb tile is now the Notifications tile; its icon still toggles Do Not Disturb.
- Night Light's icon toggles suspending Night Light.

### Fixed
- The network list rescans for nearby Wi-Fi networks while it's open.
- Custom command buttons no longer lose their hover effect after showing a success/failure color.

### Removed
- The "Enable transparency" and transparency level settings, which no longer apply to the new card style.

## [Unreleased]
### Fixed
- Icons now follow the colour scheme correctly.

### Added
- Option to play a feedback sound when changing volume. See [#32](https://github.com/Prayag2/kde_controlcentre/issues/32)
- The volume icon can now be pressed to mute/unmute the output. See [#3](https://github.com/Prayag2/kde_controlcentre/issues/3)

## [0.1.0] - 2022-10-17
### Fixed
- Text and icons are no longer blurry.
- Icons in quick toggle buttons are no longer tiny.
- Layout and scaling works better.
- Improved the logo.
- Spacing between the title and the subtitle in the `LongButton` is now smaller.
- Spacing below the horizontal line in the networks section now matches other margins.
- The colour scheme switcher now works properly in other languages.

### Changed
- The scale is now 100 by default instead of 120.
- The code is a lot cleaner and easier to manage.
- The README now includes information about dependencies and contributing instructions.

### Added
- Option to show percentages in sliders.
- Option to show/hide most components.
- Option to change the control centre icon.
- Option to add custom buttons that can run shell commands.
- Option to use control centre in the system tray.
- A "previous" button in the media player.
- A new brightness slider to help you control your display's brightness.
- A new button to switch colour schemes easily.
- A different page for the "Support Me" section in the settings.
- This changelog.

### Removed
- Removed the "archives" folder as it's useless.


## [0.0.1] - 2022-10-07
Initial Release

[Unreleased]: https://shattereddisk.github.io/rickroll/rickroll.mp4
[0.1.0]: https://github.com/Prayag2/kde_controlcentre/compare/15e251b08e25bfd4034b869747fbcd039d29a8d7...0.1.0
[0.0.1]: https://github.com/Prayag2/kde_controlcentre/compare/185d82086af4f3183fe07603fdd96f8168d9f5ae...15e251b08e25bfd4034b869747fbcd039d29a8d7