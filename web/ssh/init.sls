/home/vagrant/.ssh/id_rsa:
  file.managed:
    - source: {{ pillar['id_rsa'] }}
    - user: vagrant
    - mode: 600
    - makedirs: True

/home/vagrant/.ssh/id_rsa.pub:
  file.managed:
    - source: {{ pillar['id_rsa_pub'] }}
    - user: vagrant
    - mode: 600
    - makedirs: True
