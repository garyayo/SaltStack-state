#setup-python:
#  pkg.installed:
#    - pkgs:
#      - python
#      - python-dev
#      - python-setuptools
#      - python-pip
#      - python-virtualenv
#      - libffi-dev
#      - libssl-dev
#      - libpq-dev

setup-python:
  pkg.installed:
    - pkgs: {{ pillar['python'] }}

update-pip:
  cmd.run:
    - name: pip install -U pip 
    - require:
      - pkg: setup-python
