FROM alpine AS dependencies
RUN apk add --no-cache curl libarchive-tools
RUN mkdir binutils \
    && curl -L https://github.com/encounter/gc-wii-binutils/releases/latest/download/linux-x86_64.zip \
       | bsdtar -xvf- -C binutils
RUN mkdir compilers \
    && curl -L https://files.decomp.dev/compilers_latest.zip \
       | bsdtar -xvf- -C compilers

FROM ghcr.io/decompals/wibo:latest
COPY orig /orig
COPY --from=dependencies /binutils /binutils
COPY --from=dependencies /compilers /compilers
RUN apk add --no-cache ninja python3 py3-requests git
CMD [ "sh" ]
