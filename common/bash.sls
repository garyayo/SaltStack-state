.bashrc:
  file.managed:
    - name: /home/vagrant/.bashrc
    - source: salt://common/.bashrc
