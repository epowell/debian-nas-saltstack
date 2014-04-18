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

include:
  {% if grains['virtual'] == 'VirtualBox' %}
  - general.virtualbox-guest
  {% endif %}
