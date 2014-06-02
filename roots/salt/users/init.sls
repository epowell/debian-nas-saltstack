{# Adds new users. #}
{% for user, parameters in pillar.get('users', {}).items() -%}
{{user}}:
  user:
    - present
    - gid_from_name: True
    - home: {{parameters['home']}}
    - shell: {{parameters['shell']}}
    - require:
      - group: {{user}}
      - pkg: general
    - groups:
      - {{user}}
    - removegroups: False
  group:
    - present
    - require:
      - pkg: general
  {% if parameters.get("publickey", False) %}
  ssh_auth:
    - present
    - user: {{user}}
    - source: {{parameters["publickey"]}}
    - require:
      - user: {{user}}
  {% endif %}

{% if parameters.get('password', False) -%}
set_{{user}}_passwd:
  cmd.run:
   - name: echo -e "{{parameters["password"]}}\n{{parameters["password"]}}\n" | passwd {{user}}
   - require:
     - user: {{user}}
     - pkg: general
{%- endif %}

{{ parameters['home'] }}:
  file.directory:
    - user: {{user}}
    - group: {{user}}
    {% if parameters.get("password", False) or parameters.get("publickey", False) %}
    - mode: 750
    {% else %}
    - mode: 770
    {% endif %}
    - makedirs: True
    - require:
      - user: {{user}}

{% if parameters.get('sudo', False) and parameters.get('shell', False) %}
include:
  - sudo

extend:
  sudo:
    file:
     - managed
     - name: /etc/sudoers.d/{{user}}
     - source: salt://users/sudoer
     - template: jinja
     - user: root
     - group: root
     - mode: 440
     - require:
       - pkg: sudo
       - user: {{user}}
     - context:
       username: {{user}}
       parameters: {{parameters['sudo']}}
{% else %}
/etc/sudoers.d/{{user}}:
  file:
    - absent
    - require:
      - user: {{user}}
{% endif %}
{%- endfor %}
