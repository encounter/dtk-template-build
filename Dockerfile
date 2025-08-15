FROM alpine AS dependencies
RUN apk add --no-cache curl libarchive-tools
RUN mkdir binutils \
    && curl -L https://github.com/encounter/gc-wii-binutils/releases/download/2.42-1/linux-x86_64.zip \
       | bsdtar -xvf- -C binutils \
    && chmod +x binutils/*
RUN mkdir compilers \
    && curl -L https://files.decomp.dev/compilers_20250812.zip \
       | bsdtar -xvf- -C compilers

FROM alpine
COPY orig /orig
COPY --from=dependencies /binutils /binutils
COPY --from=dependencies /compilers /compilers
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/sbin/
RUN apk add --no-cache gcompat git ninja python3 tar
CMD [ "sh" ]
