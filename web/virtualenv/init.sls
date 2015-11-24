include:
  - web.python

/home/vagrant/testenv:
  virtualenv.managed:
      - system_site_packages: False
      - requirements: salt://web/virtualenv/requirements.txt
      - user: vagrant
      - require:
        - pkg: setup-python
