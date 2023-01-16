FROM debian:buster-slim

RUN apt-get update && apt-get install -yq wget unzip socat dumb-init && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

RUN mkdir /opt/linbpq
WORKDIR /opt/linbpq

# Add the linbpq file
ADD http://www.cantab.net/users/john.wiseman/Downloads/pilinbpq /opt/linbpq/
RUN mv /opt/linbpq/pilinbpq /opt/linbpq/linbpq

# Add the HTML pages
RUN mkdir /opt/linbpq/HTML
RUN cd HTML; wget http://www.cantab.net/users/john.wiseman/Downloads/Beta/HTMLPages.zip; unzip HTMLPages.zip; rm HTMLPages.zip

# Add BPQAPR Pages
RUN mkdir /opt/linbpq/BPQAPRS
RUN cd BPQAPRS; wget http://www.cantab.net/users/john.wiseman/Documents/Samples/APRSHTML.zip; unzip APRSHTML.zip; rm APRSHTML.zip

# allrf parsing has a buffer size bug. We're overloading the one that comes from John
ADD overwrite/allrf.html /opt/linbpq/BPQAPRS/HTML/allrf.html

RUN chmod +x linbpq

ADD start.sh /opt/linbpq/
ADD socat.sh /opt/linbpq/

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/opt/linbpq/start.sh"]
