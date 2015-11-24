# https://docs.saltstack.com/en/develop/ref/states/all/salt.states.postgres_database.html
include:
  {{ pillar['to_include'] }} 

git-pkg:
  pkg.installed:
    - name: git

my-app:
  git.latest:
    - name: git@github.com:garyayo/mysite.git
    - rev: dev
    - branch: dev
    - target: /home/vagrant/mysite
    - identity: /home/vagrant/.ssh/id_rsa
    - force_reset: True
    - user: vagrant
    - require:
      - pkg: git-pkg

{% if grains['id'] == 'web' %}
start-uwsgi:
  cmd.run:
    - name: uwsgi --emperor /etc/uwsgi/vassals --daemonize /var/log/uwsgi-emperor.log
    - require:
      - git: my-app

restart-nginx:
  cmd.run:
    - name: service nginx restart
    - require:
      - cmd: start-uwsgi
{% endif %}
