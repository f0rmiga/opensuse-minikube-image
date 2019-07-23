FROM opensuse/leap:15.0

RUN set -o errexit -o nounset -o xtrace \
  ; zypper --non-interactive refresh \
  ; zypper --non-interactive dup \
  ; zypper --non-interactive install \
    checkmedia \
    gfxboot \
    git-core \
    patch \
    python3-kiwi \
    syslinux \
    xorriso \
  ;

COPY patches/kiwi-isolinux-template.diff /patches/
RUN patch -p0 -i /patches/kiwi-isolinux-template.diff

ARG DESCRIPTION
ENV DESCRIPTION $DESCRIPTION
ARG OUTPUT
ENV OUTPUT $OUTPUT
ENV INTERNAL_OUTPUT /output

CMD set -x \
  ; mkdir -p "${INTERNAL_OUTPUT}" \
  ; kiwi-ng ${DEBUG:+--debug --color-output} --type iso system build --description "${DESCRIPTION}" --target-dir "${INTERNAL_OUTPUT}" \
    && cp "${INTERNAL_OUTPUT}"/*.iso "${OUTPUT}"
