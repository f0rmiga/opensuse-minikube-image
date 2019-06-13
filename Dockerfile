FROM opensuse/leap:15.0

RUN zypper refresh
RUN zypper --non-interactive dup
RUN zypper --non-interactive install git
RUN zypper --non-interactive install syslinux
RUN zypper --non-interactive install xorriso
RUN zypper --non-interactive install gfxboot
RUN zypper --non-interactive install python3-kiwi
RUN zypper --non-interactive install checkmedia

ARG DESCRIPTION
ENV DESCRIPTION $DESCRIPTION
ARG OUTPUT
ENV OUTPUT $OUTPUT
ENV INTERNAL_OUTPUT /output

CMD \
  set -x; \
  mkdir -p "${INTERNAL_OUTPUT}"; \
  kiwi-ng --type iso system build --description "${DESCRIPTION}" --target-dir "${INTERNAL_OUTPUT}" \
  && cp "${INTERNAL_OUTPUT}"/*.iso "${OUTPUT}"
