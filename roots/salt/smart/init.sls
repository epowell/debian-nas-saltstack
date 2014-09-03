/etc/default/smartmontools:
  file.managed:
    - source: salt://smart/smartmontools
    - require:
      - pkg: smartmontools

/etc/smartd.conf:
  file.managed:
    - source: salt://smart/smartd.conf
    - template: jinja
    - require:
      - pkg: smartmontools

smartmontools:
  pkg.installed:
    - name: smartmontools
  service:
    - running
    - watch:
      - file: /etc/smartd.conf
