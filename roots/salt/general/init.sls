general:
  pkg.installed:
    - pkgs:
      - tzdata
      - util-linux
      - git-core
      - openssh-server
      - openssh-client
      - adduser
      - apt
      - bash
      - binutils
      - build-essential
      - locales
      - localepurge
      - make
      - login
      - mount
      - passwd
      - tar
      - wget
      - hdparm
      - smartmontools
      - dosfstools
      - ntfs-3g
      - parted
      - unzip
      - btrfs-tools
      - iftop

system:
    network.system:
      - enabled: True
      - hostname: {{ pillar.get('general', {})['hostname'] }}

/etc/timezone:
  cmd.run:
   - name: echo "{{ pillar.get('general', {})['timezone'] }}" > /etc/timezone

{% if pillar.get('general', {})['ssd'] %}
/tmp:
  mount.mounted:
    - fstype: tmpfs
    - opts: defaults,noatime,mode=1777
    - mkmnt: True
    - device: tmpfs
/var/tmp:
  mount.mounted:
    - fstype: tmpfs
    - opts: defaults,noatime,mode=1777
    - mkmnt: True
    - device: tmpfs
/var/log:
  mount.mounted:
    - fstype: tmpfs
    - opts: defaults,noatime,mode=0755
    - mkmnt: True
    - device: tmpfs
/var/log/apt:
  mount.mounted:
    - fstype: tmpfs
    - opts: defaults,noatime
    - mkmnt: True
    - device: tmpfs
#/var/cache:
#  mount.mounted:
#    - fstype: unionfs
#    - opts: dirs=/tmp:/var/cache=ro
#    - mkmnt: True
#    - device: unionfs
{% endif %}

{% if grains['virtual'] == 'VirtualBox' %}
include:
  - general.virtualbox-guest
{% endif %}
