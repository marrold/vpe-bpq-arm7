FROM debian:buster-slim

RUN apt-get update && apt-get install -yq wget unzip socat dumb-init libasound2-dev libconfig9 libpcap-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

RUN mkdir /opt/linbpq-base
WORKDIR /opt/linbpq-base

# Add the linbpq file
ADD http://www.cantab.net/users/john.wiseman/Downloads/Beta/pilinbpq /opt/linbpq-base
RUN mv /opt/linbpq-base/pilinbpq /opt/linbpq-base/linbpq
RUN chmod +x /opt/linbpq-base/linbpq

# Add the HTML pages
RUN mkdir /opt/linbpq-base/HTML
RUN cd HTML; wget http://www.cantab.net/users/john.wiseman/Downloads/Beta/HTMLPages.zip; unzip HTMLPages.zip; rm HTMLPages.zip

# Add BPQAPR Pages
RUN mkdir /opt/linbpq-base/BPQAPRS
RUN cd BPQAPRS; wget http://www.cantab.net/users/john.wiseman/Documents/Samples/APRSHTML.zip; unzip APRSHTML.zip; rm APRSHTML.zip

# allrf parsing has a buffer size bug. We're overloading the one that comes from John
ADD overwrite/allrf.html /opt/linbpq-base/BPQAPRS/HTML/allrf.html

ADD start.sh /opt/linbpq-base/
ADD socat.sh /opt/linbpq-base/
ADD bootstrap.sh /opt/linbpq-base/

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/opt/linbpq-base/start.sh"]
