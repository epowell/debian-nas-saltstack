avahi-daemon:
  pkg.installed

avahi-utils:
  pkg.installed

https://github.com/mrworf/plexupdate.git:
  git.latest:
    - rev: master
    - target: /opt/plexupdate

plexmediaserver:
  cmd.run:
    - name: /opt/plexupdate/plexupdate.sh -a -p
    - require:
      - pkg: avahi-daemon
      - pkg: avahi-utils
      - git: https://github.com/mrworf/plexupdate.git
