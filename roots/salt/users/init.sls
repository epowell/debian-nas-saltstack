{% for username, user in pillar['users'].iteritems() %}
{{ username }}:
  user.present:
    - fullname: {{ user['fullname'] }}
    {% if user.get('shell', '') %}
    - shell: {{ user['shell'] }}
    {% endif %}
    - home: {{ user['home'] }}
    {% if user.get('password', '') %}
    - password: {{ user['password'] }}
    - enforce_password: False
    {% endif %}
    {% if user.get('groups', []) %}
    - groups:
      {% for grp in user['groups'] %}
      - {{ grp }}
      {% endfor %}
    {% endif %}
    - remove_groups: False
  {% if user.get('ssh_key', []) %}
  ssh_auth.present:
    - user: {{ username }}
    - comment: {{ user['email'] }}
    - enc: {{ user['ssh_key_type'] }}
    - names:
      - {{ user['ssh_key'] }}
    - require:
      - user: {{ username }}
  {% endif %}
{{ username }}-editor:
  file.append:
    - name: {{ user['home'] }}/.bashrc
    - text: export EDITOR={{ user['editor'] }}
    - require:
      - user: {{ username }}

{% if user.get('srcdir', '') %}
{{ user['home'] }}/{{ user['srcdir'] }}:
  file.directory:
    - user: {{ username }}
    - group: {{ username }}
    - makedirs: True
    - require:
      - user: {{ username }}
{% endif %}

{% if user.get('bindir', '') %}
{{ user['home'] }}/{{ user['bindir'] }}:
  file.directory:
    - user: {{ username }}
    - group: {{ username }}
    - makedirs: True
    - require:
      - user: {{ username }}

{{ username }}-binpath:
  file.append:
    - name: {{ user['home'] }}/.bashrc
    - text: export PATH=$PATH:{{ user['home'] }}/{{ user['bindir'] }}
    - require:
      - file: {{ user['home'] }}/{{ user['bindir'] }}
      - user: {{ username }}
{% endif %}
{% if user.get('bashrc', '') %}
{{ username }}-custom-bashrc:
  file.blockreplace:
    - name: {{ user['home'] }}/.bashrc
    - marker_start: "# START custom .bashrc for {{ username  }} -DO-NOT-EDIT-"
    - marker_end: "# END custom .bashrc for {{ username }} --"
    - content: "{{ user['bashrc'] }}"
    - append_if_not_found: True
    - show_changes: False
    - backup: False
{% endif %}

{% if user.get('aliases', '') %}
{{ user['home'] }}/.bash_aliases:
  file.managed:
    - contents: |
    {% for cmd, content in user['aliases'].iteritems() %}
                  alias {{ cmd }}="{{ content }}"
    {% endfor %}
    - user: {{ username }}
    - group: {{ username }}
    - mode: 600
    - create: True
{% endif %}

{% if user.get('packages', []) %}
{% for packname in user['packages'] %}
{{ username }}-{{ packname }}:
  pkg.installed:
    - name: {{ packname }}
{% endfor %}
{% endif %}

{% if user.get('samba', '') %}
{{ user['home'] }}/share:
  file.directory:
    - user: root
    - group: {{ username }}
    - mode: 750
    - require:
      - user: {{ username }}
{% endif %}

{% if user.get('mediashare', '') %}
{{ user['home'] }}/share/media:
  file.symlink:
    - target: /storage/media
    - makedirs: True
    - require:
      - user: {{ username }}
      - mount: /storage/media
{% endif %}

{% if user.get('backups', '') %}
{{ user['home'] }}/share/backup:
  file.symlink:
    - target: /storage/{{ username }}
    - makedirs: True
    - require:
      - user: {{ username }}
      - mount: /storage/{{ username }}
{% endif %}

{% endfor %}
