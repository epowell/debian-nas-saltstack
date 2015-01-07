btsync-repo:
  pkgrepo.managed:
    - humanname: Bittorrent Sync
    - ppa: tuxpoldo/btsync
    - require_in:
      - pkg: btsync

btsync:
  pkg.latest

{% for username, user in pillar['users'].iteritems() %}
{% if user.get('btsync', '') %}
/etc/btsync/{{username}}.btsync.conf:
  file.managed:
    - user: {{username}}
    - group: btsync
    - mode: 540
    - contents: |
        {{ user['btsync.conf'] | indent(8) }}
    - require_in:
      - service: btsync
{% endif %}
{% endfor %}

