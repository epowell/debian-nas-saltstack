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

/sbin/btrfs scrub start /media/btrfs:
  cron.present:
    - identifier: BTRFSSCRUB
    - user: root
    - minute: 0
    - hour: 3
    - daymonth: 1

/usr/bin/btrfsemail.sh:
  file.managed:
    - source: salt://storage/btrfsemail.sh
    - template: jinja
    - context: {{ pillar['users']['epowell']['mailgun'] }}
    - mode: 744
  cron.present:
    - identifier: BTRFSEMAIL
    - user: root
    - minute: 0
    - hour: 5
    - daymonth: 1

