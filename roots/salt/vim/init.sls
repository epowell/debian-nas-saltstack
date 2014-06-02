vim:
  pkg:
    - installed
    - name: vim

{% for username, user in pillar['users'].iteritems() %}
{{ user['home'] }}/.vimrc:
  file:
    - managed
    - source: salt://vim/vimrc
    - user: {{ username }}
    - group: {{ username }}
    - mode: 644
    - template: jinja
    - makedirs: True
    - require:
      - pkg: vim

#Custom vimrc
{% if user.get('vimrc', '') %}
{{ username }}-custom-vimrc:
  file.blockreplace:
    - name: {{ user['home'] }}/.vimrc
    - marker_start: "\" START custom .vimrc for {{ username  }} -DO-NOT-EDIT-"
    - marker_end: "\" END custom .vimrc for {{ username }} --"
    - content: "{{ user['vimrc'] }}"
    - append_if_not_found: True
    - show_changes: False
    - backup: False
{% endif %}
{% endfor %}


