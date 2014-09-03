/var/lib/plexmediaserver:
  mount.mounted:
    - mkmnt: True
    - device: /dev/sda
    - fstype: btrfs
    - opts: defaults,subvol=plexmediaserver,noatime
    - persist: True
    - require_in:
      - cmd: plexmediaserver

/storage/transmission:
  mount.mounted:
    - mkmnt: True
    - device: /dev/sda
    - fstype: btrfs
    - opts: defaults,subvol=transmission,noatime
    - persist: True
    - require_in:
      - file: {{pillar.get('transmission', {})['download_dir']}}
      - file: {{pillar.get('transmission', {})['incomplete_dir']}}

/storage/media:
  mount.mounted:
    - mkmnt: True
    - device: /dev/sda
    - fstype: btrfs
    - persist: True
    - opts: defaults,subvol=media/media,noatime

{% for username, user in pillar['users'].iteritems() %}
{% if user.get('backups', '') %}
/storage/{{username}}:
  mount.mounted:
    - mkmnt: True
    - device: /dev/sda
    - fstype: btrfs
    - persist: True
    - opts: defaults,subvol=users/{{username}}/{{username}},noatime
{% endif %}
{% endfor %}
