install-make-pkg:
  pkg.installed:
    - name: make

install-redis-from-source:
  cmd.run:
    - name: |
        cd /tmp
        wget http://download.redis.io/redis-stable.tar.gz
        tar xvzf redis-stable.tar.gz
        cd redis-stable
        make
        make install
    - cwd: /tmp
    - require:
      - pkg: install-make-pkg

/etc/init.d/redis_6379:
  file.managed:
    - source: salt://redis/redis_6379
    - mode: 755
    - require:
      - cmd: install-redis-from-source

/etc/redis/6379.conf:
  file.managed:
    - source: salt://redis/6379.conf
    - makedirs: True
    - require:
      - cmd: install-redis-from-source

/var/redis/6379:
  file.directory:
    - makedirs: True
    - require:
      - cmd: install-redis-from-source

add-redis-default-runlevels:
  cmd.run:
    - name: update-rc.d redis_6379 defaults
    - require:
      - file: /etc/init.d/redis_6379

start-redis:
  cmd.run:
    - user: root
    - name: sudo /etc/init.d/redis_6379 start
    - require:
      - cmd: add-redis-default-runlevels

