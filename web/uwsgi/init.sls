# This state should installed uwsgi globally
include:
  - web.python

uwsgi-setup:
  pip.installed:
    - name: uwsgi
    - require:
      - pkg: setup-python

/etc/uwsgi/vassals/mysite_uwsgi.ini:
  file.managed:
      - source: salt://web/uwsgi/mysite_uwsgi.ini
      - user: vagrant
      - makedirs: True
      - require:
        - pip: uwsgi-setup

/etc/rc.local:
  file.managed:
      - source: salt://web/uwsgi/rc.local
      - user: vagrant
      - require:
        - pip: uwsgi-setup

