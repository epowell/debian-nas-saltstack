general:
  pkg.installed:
    - pkgs:
      - tzdata
      - util-linux
      - git-core
      - mc
      - vim
      - zsh
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
      - nano
      - passwd
      - tar
      - wget
      - hdparm
      - smartmontools
      - dosfstools
      - ntfs-3g
      - parted
      - unzip

system:
    network.system:
      - enabled: True
      - hostname: vigilance

/etc/timezone:
  cmd.run:
   - name: echo "{{ pillar.get('general', {})['timezone'] }}" > /etc/timezone

/tmp:
  mount.mounted:
    - fstype: tmpfs
    - opts: defaults,noatime,mode=1777
    - mkmnt: True
/var/tmp:
  mount.mounted:
    - fstype: tmpfs
    - opts: defaults,noatime,mode=1777
    - mkmnt: True
/var/log:
  mount.mounted:
    - fstype: tmpfs
    - opts: defaults,noatime,mode=0755
    - mkmnt: True
/var/log/apt:
  mount.mounted:
    - fstype: tmpfs
    - opts: defaults,noatime
    - mkmnt: True
/var/cache:
  mount.mounted:
    - fstype: unionfs
    - opts: dirs=/tmp:/var/cache=ro
    - mkmnt: True

include:
  {% if grains['virtual'] == 'VirtualBox' %}
  - general.virtualbox-guest
  {% endif %}
