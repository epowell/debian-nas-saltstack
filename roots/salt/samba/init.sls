samba-common-bin:
  pkg.installed

smbd:
  pkg:
    - name: samba
    - installed
    - require:
      - pkg: samba-common-bin
  service:
    - running
    - watch:
      - file: /etc/samba/smb.conf
