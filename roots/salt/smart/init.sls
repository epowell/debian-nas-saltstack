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

/etc/smartmontools/run.d/10smartmail.sh:
  file.managed:
    - source: salt://smart/smartmail.sh
    - template: jinja
    - context: {{ pillar['users']['epowell']['mailgun'] }}
    - mode: 744
    - require:
      - pkg: smartmontools

smartmontools:
  pkg.installed:
    - name: smartmontools
  service:
    - running
    - watch:
      - file: /etc/smartd.conf

