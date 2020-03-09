#!/usr/bin/perl

# obmenu-generator - schema file

=for comment

    item:      add an item inside the menu          {item => ["command", "label", "icon"]},
    cat:       add a category inside the menu       {cat => ["name", "label", "icon"]},
    sep:       horizontal line separator            {sep => undef}, {sep => "label"},
    pipe:      a pipe menu entry                    {pipe => ["command", "label", "icon"]},
    file:      include the content of an XML file   {file => "/path/to/file.xml"},
    raw:       any XML data supported by Openbox    {raw => q(xml data)},
    begin_cat: beginning of a category              {begin_cat => ["name", "icon"]},
    end_cat:   end of a category                    {end_cat => undef},
    obgenmenu: generic menu settings                {obgenmenu => ["label", "icon"]},
    exit:      default "Exit" action                {exit => ["label", "icon"]},

=cut

require "$ENV{HOME}/.config/obmenu-generator/config.pl";

## Text editor
my $editor = $CONFIG->{editor};

our $SCHEMA = [
    # Format:  NAME, LABEL, ICON
{sep => 'Categorie'},
      {cat => ['utility',     ' Accessori',      'applications-utilities']},
      {cat => ['development', ' Sviluppo',       'applications-development']},
      {cat => ['game',        ' Giochi',         'applications-games']},
      {cat => ['graphics',    ' Grafica',        'applications-graphics']},
      {cat => ['audiovideo',  ' Multimedia',     'applications-multimedia']},
      {cat => ['network',     ' Network',        'applications-internet']},
      {cat => ['office',      ' Ufficio',        'applications-office']},
      {cat => ['other',       ' Altro',          'applications-other']},
      {cat => ['settings',    ' Impostazioni',   'applications-accessories']},
      {cat => ['system',      ' Sistema',        'applications-system']},
    ]
