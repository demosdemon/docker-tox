FROM demosdemon/tox-base

LABEL author="Matthew Tardiff <mattrix@gmail.com>"
LABEL maintainer="Brandon LeBlanc <brandon@leblanc.codes>"

WORKDIR /app
VOLUME /src

RUN set -eux; \
    groupadd -r tox --gid=999; \
    useradd -m -r -g tox --uid=999 tox;

COPY docker-entrypoint.sh /

ONBUILD COPY install-prereqs*.sh requirements*.txt tox.ini /app/
ONBUILD ARG SKIP_TOX=false
ONBUILD RUN bash -c " \
    if [ -f '/app/install-prereqs.sh' ]; then \
        bash /app/install-prereqs.sh; \
    fi && \
    if [ $SKIP_TOX == false ]; then \
        TOXBUILD=true tox; \
    fi"

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["tox"]
