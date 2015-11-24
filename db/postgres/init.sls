update-apt:
  cmd.run:
    - cwd: /
    - user: root
    - name: apt-get update

postgres:
  pkg.installed:
    - name: postgresql-9.1
    - user: vagrant
    - require:
      - cmd: update-apt

/etc/postgresql/9.1/main/pg_hba.conf:
  file.managed:
    - source: salt://db/postgres/pg_hba.conf
    - user: vagrant
    - require:
      - pkg: postgres

/etc/postgresql/9.1/main/postgresql.conf:
  file.managed:
    - source: salt://db/postgres/postgresql.conf
    - user: vagrant
    - require:
      - pkg: postgres

start-postgresql:
  service.running:
      - enable: true
      - name: postgresql
      - require:
        - pkg: postgres

setup-db:
  postgres_database.present:
    - name: mydb
    - require:
      - service: start-postgresql



