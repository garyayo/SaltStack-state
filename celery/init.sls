# Install git
# install virtualenv
# install python-dev
# install python-pip
# install libpq-dev
# include project path into PYTHONPATH
# copy github project
# setup virtualenv
# copy in /etc/default/celeryd
# copy in /etc/init.d/celeryd
# make chmod +x init.d/celeryd 
# create group celery -- addgroup celery
# create user celery and add to group-- adduser celery celery
# add user celery to group celery
# chown celery:celery /var/log/celery
# chown celery:celery /var/run/celery
# start celery -- sudo /etc/init.d/celeryd start
# add above command to rc.local

#setup-python:
#  pkg.installed:
#    - name: python-pip

include:
  - web

#git-pkg:
#  pkg.installed:
#    - name: git

rabbitmq-server:
  pkg.installed:
    - name: rabbitmq-server
    - require:
      - pkg: setup-python

/etc/rabbitmq/rabbitmq.config:
  file.managed:
    - source: salt://celery/rabbitmq.config
    - require:
      - pkg: rabbitmq-server

setting-up-rabbitmq:
  cmd.run:
    - name: |
        rabbitmqctl add_user myuser mypassword
        rabbitmqctl add_vhost myvhost
        rabbitmqctl set_user_tags myuser mytag
        rabbitmqctl set_permissions -p myvhost myuser ".*" ".*" ".*"
    - require:
      - pkg: rabbitmq-server

pip-install-celery:
  pip.installed:
    - name: celery
    - require:
      - pkg: rabbitmq-server

/etc/default/celeryd:
  file.managed:
    - source: salt://celery/default_celeryd
    - require:
      - pip: pip-install-celery

/etc/init.d/celeryd:
  file.managed:
    - source: salt://celery/init.d_celeryd
    - mode: 755
    - require:
      - pip: pip-install-celery

celery-group:
  group.present:
    - name: celery

celery-user:
  user.present:
    - name: celery
    - groups:
      - celery
    - require:
      - group: celery-group

restart-rabbit:
  cmd.run:
    - user: root
    - name: sudo service rabbitmq-server restart
    - require:
      - pkg: rabbitmq-server

start-celery:
  cmd.run:
    - user: root
    - name: sudo /etc/init.d/celeryd start
    - require:
      - pip: pip-install-celery
