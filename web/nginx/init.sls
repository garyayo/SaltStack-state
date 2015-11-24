nginx:
  pkg.installed:
    - name: nginx
  service.running:
    - enable: True
    - reload: True
    - watch:
      - pkg: nginx
      - file: /etc/nginx/sites-enabled/mysite_nginx.conf

/etc/nginx/sites-enabled/mysite_nginx.conf:
  file.managed:
    - source: salt://web/nginx/mysite_nginx.conf
    - user: vagrant
    - require:
      - pkg: nginx

