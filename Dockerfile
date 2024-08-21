FROM alpine AS dependencies
RUN apk add --no-cache curl libarchive-tools
RUN mkdir binutils \
    && curl -L https://github.com/encounter/gc-wii-binutils/releases/2.42-1/download/linux-x86_64.zip \
       | bsdtar -xvf- -C binutils \
    && chmod +x binutils/*
RUN mkdir compilers \
    && curl -L https://files.decomp.dev/compilers_20240706.zip \
       | bsdtar -xvf- -C compilers

FROM ghcr.io/decompals/wibo:0.6.11
COPY orig /orig
COPY --from=dependencies /binutils /binutils
COPY --from=dependencies /compilers /compilers
RUN apk add --no-cache ninja python3 py3-requests git gcompat
CMD [ "sh" ]
