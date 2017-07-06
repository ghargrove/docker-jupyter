FROM hardbyte/python3

WORKDIR /app
COPY requirements.txt ./

## Install deps
RUN pip3 install --upgrade -r requirements.txt

## Copy the jupyter config
COPY jupyter_notebook_config.py ./

# Add notebooks dir
RUN mkdir notebooks
VOLUME /app/notebooks
WORKDIR /app/notebooks

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents
# kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

EXPOSE 8888
CMD ["jupyter", "notebook", "--allow-root", "--config=/app/jupyter_notebook_config.py"]
