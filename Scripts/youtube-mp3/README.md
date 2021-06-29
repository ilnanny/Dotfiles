#================================================
#================================================
#   O.S.      : Gnu Linux                       =
#   Author    : Cristian Pozzessere   = ilnanny =
#   D.A.Page  : http://ilnanny.deviantart.com   =
#   Github    : https://github.com/ilnanny      =
#================================================
#================================================

Downloads videos from YouTube and convert them to mp3.

## Installation

Copy the `youtube-dl-mp3` script to somewhere in your `$PATH` (try /usr/local/bin).

## Requirements

  * [youtube-dl](https://github.com/rg3/youtube-dl)
  * wget
  * ffmpeg
  * lame
  * rtmpdump
  * atomicparsley
  * python-pycryptodome

## Usage

    youtube-dl --ignore-errors --format bestaudio --extract-audio --audio-format mp3 --audio-quality 160K --output "%(title)s.%(ext)s" '<YouTube playlist URL>'


## from a playlist at once:

    youtube-dl --ignore-errors --format bestaudio --extract-audio --audio-format mp3 --audio-quality 160K --output "%(title)s.%(ext)s" --yes-playlist '<YouTube playlist URL>'


    youtube-dl --ignore-errors --format bestaudio --extract-audio --audio-format mp3 --audio-quality 160K --output "%(title)s.%(ext)s" --yes-playlist 'https://www.youtube.com/watch?v=UbYQErtM9Zk&list=PLC17TRHjjf7n797cx1_5Ka5NvHcVEa3Pk'
