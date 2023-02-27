FROM amutake/satysfi:0.0.8-opam-slim

#COPY shinchoku-tairiku.satyh shinchoku-tairiku.satyh
RUN git clone --depth 1 https://github.com/shinchoku-tairiku/shinchoku-tairiku.satyh
RUN cd shinchoku-tairiku.satyh && \
    opam pin add satysfi-class-shinchoku-tairiku . && \
    satyrographos install

WORKDIR /workspace
