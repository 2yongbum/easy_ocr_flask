FROM docker.io/pytorch/pytorch

# if you forked EasyOCR, you can pass in your own GitHub username to use your fork
# i.e. gh_username=myname
ARG gh_username=JaidedAI
ARG service_home="/home/EasyOCR"

RUN ln -snf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# Configure apt and install packages
RUN apt-get update -y && \
    apt-get install -y \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgl1-mesa-dev \
    git \
    # cleanup
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists

# Clone EasyOCR repo
RUN mkdir "$service_home" \
    && git clone "https://github.com/$gh_username/EasyOCR.git" "$service_home" \
    && cd "$service_home" \
    && git remote add upstream "https://github.com/JaidedAI/EasyOCR.git" \
    && git pull upstream master

# Build
RUN cd "$service_home" \
    && python setup.py build_ext --inplace -j 4 \
    && python -m pip install -e .

# Download trained model
RUN python -c "import easyocr; easyocr.Reader(['en'])"
RUN pip install flask gunicorn

ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . ./

CMD exec gunicorn --bind :8080 --workers 1 --threads 8 --timeout 0 main:app
