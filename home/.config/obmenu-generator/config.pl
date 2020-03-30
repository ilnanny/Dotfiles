#!/usr/bin/perl

# obmenu-generator - configuration file

=for comment

=cut

our $CONFIG = {
  "editor"              => "geany",
  "force_icon_size"     => 0,
  "generic_fallback"    => 0,
  "gtk_rc_filename"     => "$ENV{HOME}/.gtkrc-2.0",
  "icon_size"           => 32,
  "Linux::DesktopFiles" => {
                             desktop_files_paths     => [
                                                          "/usr/share/applications",
                                                          "/usr/local/share/applications",
                                                          "/usr/share/applications/kde4",
                                                          "$ENV{HOME}/.local/share/applications",
                                                        ],
                             gtk_rc_filename         => "$ENV{HOME}/.gtkrc-2.0",
                             icon_dirs_first         => undef,
                             icon_dirs_last          => undef,
                             icon_dirs_second        => undef,
                             keep_unknown_categories => 1,
                             skip_entry              => [{ key => "Name", re => qr/^(Qt4?\b)/ }],
                             skip_filename_re        => qr/^(mugshot|menulibre|xfce-keyboard-settings|xfce-backdrop-settings|xfce4-accessibility-settings|xfce-settings-editor|xfce-wmtweaks-settings|xfce-wm-settings|xfce-workspaces-settings|xfce4-about|xfce4-session-logout|bssh|bvnc|avahi-discover|logdconf|ffadomixer|gconf|urxvt|xterm|uxterm|compton)/,
                             skip_svg_icons          => 0,
                             strict_icon_dirs        => undef,
                             substitutions           => undef,
                             terminalization_format  => "%s -e '%s'",
                             terminalize             => 1,
                             unknown_category_key    => "other",
                           },
  "locale_support"      => 1,
  "missing_icon"        => "gtk-missing-image",
  "terminal"            => "xterm",
  "use_gtk3"            => 0,
  "VERSION"             => 0.87,
}
