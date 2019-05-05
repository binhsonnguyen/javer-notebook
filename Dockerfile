FROM jupyter/minimal-notebook

USER root
ENV DEBIAN_FRONTEND=noninteractive

# Install JDK 11, thanks https://github.com/datawire/docker-debian-openjdk-11
WORKDIR /opt
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
    && curl \
        -L \
        -o openjdk.tar.gz \
        https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_linux-x64_bin.tar.gz \
    && mkdir jdk \
    && tar zxf openjdk.tar.gz -C jdk --strip-components=1 \
    && rm -rf openjdk.tar.gz \
    && apt-get -y --purge autoremove curl \
    && ln -sf /opt/jdk/bin/* /usr/local/bin/ \
    && rm -rf /var/lib/apt/lists/* \
    && java  --version \
    && javac --version \
    && jlink --version \
    && fix-permissions $CONDA_DIR \
    && fix-permissions /home/$NB_USER

# Install Java kernel, https://github.com/SpencerPark/IJava.git
WORKDIR /tmp
RUN git clone https://github.com/SpencerPark/IJava.git \
		&& cd IJava/ \
		&& chmod u+x gradlew \
		&& ./gradlew installKernel \
			--param timeout:30 \
		&& rm -rf IJava \
    && fix-permissions $CONDA_DIR \
    && fix-permissions /home/$NB_USER

# Configure container startup
EXPOSE 8888
WORKDIR $HOME
ENTRYPOINT ["tini", "-g", "--"]
CMD ["start-notebook.sh"]

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
