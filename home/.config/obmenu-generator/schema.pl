#!/usr/bin/perl

# obmenu-generator - schema file

require "$ENV{HOME}/.config/obmenu-generator/config.pl";

## Text editor
my $editor = $CONFIG->{editor};

our $SCHEMA = [
# Formato:        NoME,               LABEL,                      ICONa
{sep => "Menu     Openbox"},
   {item => ['exo-open --launch TerminalEmulator', '   Terminale',    'terminal-emulator']},
   {item => ['exo-open --launch WebBrowser ',      '   Web Browser',  'web-browser']},
   {item => ['exo-open --launch FileManager',      '   File Manager', 'file-manager']},
   {item => ['geany',                              '   Geany Ide,        'geany']},
   {item => ['menu  -r',                           '   Esegui',       'rofi']},
{sep => 'Categorie'},
   {cat => ['utility',      '    Accessori  ',     'applications-utilities']},
   {cat => ['development',  '    Sviluppo  ',      'applications-development']},
   {cat => ['game',         '    Giochi  ',        'applications-games']},
   {cat => ['graphics',     '    Grafica  ',       'applications-graphics']},
   {cat => ['audiovideo',   '    Multimedia  ',    'applications-multimedia']},
   {cat => ['network',      '    Network  ',       'applications-internet']},
   {cat => ['office',       '    Ufficio  ',       'applications-office']},
   {cat => ['other',        '    Altro  ',         'applications-other']},
   {cat => ['settings',     '    Impostazioni  ',  'applications-accessories']},
   {cat => ['system',       '    Sistema  ',       'applications-system']},
  {pipe => ['places-pipemenu --recent ~/',   '    File  Recenti ',  'folder']},
{sep => 'Avanzate'},
{begin_cat => ['   Configurazioni', 'theme']},
{begin_cat => [' Openbox', 'openbox']},
   {item => ['obconf', ' Openbox Conf', 'theme']},
   {item => ["$editor ~/.config/obmenu-generator/schema.pl", ' Edita Schema.pl', 'text-x-source']},
   {item => ["exo-open ~/.config/openbox/menu.xml", ' Edita menu.xml', 'text-xml']},
   {item => ["exo-open ~/.config/openbox/rc.xml", ' Edita rc.xml', 'text-xml']},
   {item => ["exo-open ~/.config/openbox/autostart", ' Edita autostart', 'text-xml']},
   {item => ['obmenu-generator -s -c', ' Rigenera Menu ', 'menu-editor']},
{end_cat => undef},
   {item => ["$editor ~/.conkyrc", ' Edita Conky', 'text-x-source']},
   {item => ["exo-open ~/.config/compton.conf", ' Compositore', 'compton']},
   {pipe => ['tint2-pipemenu', ' Tint2', 'tint2']},
   {pipe => ['polybar-pipemenu', ' Polybar', 'polybar']},
{begin_cat => [' Sistema', 'system-settings']},
   {item => ['volumeicon', ' Imposta Audio', 'multimedia-volume-control']},
   {item => ['portgui', ' Software Manager', 'gnome-software']},
   {item => ['xfce4-settings-manager', ' Gestore Impostazioni', 'xfce4-settings-manager']},
{end_cat => undef},
{sep => ' '},
   {item => ['nitrogen', ' Cambia Sfondo', 'nitrogen']},
   {item => ['rofi-theme-selector', ' Temi Rofi ', 'theme']},
#      {item => ['panel-chooser', ' Scegli il Panello', 'panel']},
{end_cat => undef},
   {pipe => ['kb-pipemenu',   '   KeyBInds  ', 'cs-keyboard']},
   {pipe => ['info-pipemenu', '   Info    Online ', 'info']},
   {item => ['obmenu-generator -s -c', '   Rigenera  Menu ', 'menu-editor']},
       # {item => ['openbox --exit', '   Esci da Openbox', 'exit']},
{sep => 'E  s  c  i '},
{begin_cat => ['       ▶     ▶     ▶  ', 'exit']},
   {item => ['openbox --exit',         ' Esci da Openbox',    'system-suspend']},
   {item => ['', '        ▫      ▫      ▫ ', '']},
   {item => ['xterm -e sudo reboot',   ' Riavvia il Sistema', 'system-reboot']},
   {item => ['', '        ▫      ▫      ▫ ', '']},
   {item => ['xterm -e sudo poweroff', ' Spegni il Computer', 'system-poweroff']},
{end_cat => undef},
#   {item => ['', '        ▫      ▫      ▫ ', '']},




]
