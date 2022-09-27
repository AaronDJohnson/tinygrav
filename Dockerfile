# The build-stage image:
FROM continuumio/miniconda3 AS build

# Install the package as normal:
RUN conda install -c conda-forge conda-lock
COPY conda-linux-64.lock .
RUN conda-lock install -n enterprise conda-linux-64.lock

# Install conda-pack:
RUN conda install -c conda-forge conda-pack

# Use conda-pack to create a standalone enviornment
# in /venv:
RUN conda-pack -n enterprise -o /tmp/env.tar && \
  mkdir /venv && cd /venv && tar xf /tmp/env.tar && \
  rm /tmp/env.tar

# We've put venv in same path it'll be in final image,
# so now fix up paths:
RUN /venv/bin/conda-unpack


# The runtime-stage image; we can use Ubuntu as the
# base image since the Conda env also includes Python
# for us.
FROM ubuntu:latest AS runtime

# Copy /venv from the previous stage:
COPY --from=build /venv /venv

# Add data and scripts
COPY /data /data
COPY /scripts /scripts

# When image is run, run the code with the environment
# activated:
SHELL ["/bin/bash", "-c"]
ENTRYPOINT source /venv/bin/activate && \
           python /scripts/run.py
