include:
  - samba

/etc/samba/smb.conf:
  file.managed:
    - source: salt://samba/smb.conf
    - template: jinja
    - require:
      - pkg: samba

/usr/local/samba/private/smbpasswd:
  cmd.run:
    - require:
      - pkg: samba
    - names:
      - smbpasswd -Lan {{ pillar.get('samba', {})['guest_username'] }}
{% for user, parameters in pillar.get('users', {}).items() %}
{% if parameters['samba'] %}
      - usermod -a -G sambashare {{user}}
   {% if parameters.get('password', False) %}
      - echo -e "{{parameters['password']}}\n{{parameters['password']}}\n" | smbpasswd -La -s {{user}}
   {% if parameters.get('samba_guest_readonly', True) %}
      - usermod -a -G {{user}} {{ pillar.get('samba', {})['guest_username'] }}
   {% else %}
      - gpasswd -d {{ pillar.get('samba', {})['guest_username'] }} {{user}} || true
   {% endif %}
   {% else %}
      - smbpasswd -Lan {{user}}
      - usermod -a -G {{user}} {{ pillar.get('samba', {})['guest_username'] }}
   {% endif %}
{% endif %}
{% endfor %}

{% for user, parameters in pillar.get('users', {}).items() %}
{{parameters['home']}}/.recycle:
  file.absent
{% endfor %}
