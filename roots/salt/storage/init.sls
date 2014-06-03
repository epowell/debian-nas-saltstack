/storage/transmission:
  mount.mounted:
    - mkmnt: True
    - device: /dev/sda
    - fstype: btrfs
    - opts: defaults,subvol=transmission
    - require_in:
      - file: {{pillar.get('transmission', {})['download_dir']}}
      - file: {{pillar.get('transmission', {})['incomplete_dir']}}

/storage/media:
  mount.mounted:
    - mkmnt: True
    - device: /dev/sda
    - fstype: btrfs
    - opts: defaults,subvol=media/media
    - require_in:
      - file: {{pillar.get('transmission', {})['download_dir']}}
      - file: {{pillar.get('transmission', {})['incomplete_dir']}}

