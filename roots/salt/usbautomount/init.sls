ntfs-3g:
  pkg.installed

udev:
  pkg:
    - installed
  service:
    - running
    - watch:
      - file: /etc/udev/rules.d/10-my-media-automount.rules

/etc/udev/rules.d/10-my-media-automount.rules:
  file.managed:
    - source: salt://usbautomount/10-my-media-automount.rules
    - template: jinja
    - require:
      - pkg: udev
      - pkg: ntfs-3g

{% for user, parameters in pillar.get('users', {}).items() -%}
{% if parameters['home'] %}
{{parameters['home']}}/share/devices:
  file.symlink:
    - target: /media
    - user: root
    - group: {{ user }}
    - mode: 750
    - require:
      - user: {{user}}
      - pkg: udev
      - file: {{parameters['home']}}/share
{% endif %}
{%- endfor %}
