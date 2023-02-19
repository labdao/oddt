FROM continuumio/miniconda3:22.11.1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    g++ \
    python3-dev \
    libeigen3-dev \
    wget \
    cmake \
    less

# Installing OpenBabel
RUN wget https://github.com/openbabel/openbabel/releases/download/openbabel-3-1-1/openbabel-3.1.1-source.tar.bz2
RUN tar -xjf openbabel-3.1.1-source.tar.bz2
RUN cd openbabel-3.1.1
RUN cmake ../openbabel-3.1.1 \
    -DPYTHON_BINDINGS=ON \
    -DRUN_SWIG=ON \
    -DCMAKE_INSTALL_PREFIX=/opt/conda \
    -DPYTHON_INCLUDE_DIR=/opt/conda/include/python3.10 \
    -DCMAKE_LIBRARY_PATH=/opt/conda/lib \
    -DSWIG_DIR=/opt/conda/share/swig/4.0.2 \
    -DSWIG_EXECUTABLE=/opt/conda/bin/swig \
    -DPYTHON_LIBRARY=/opt/conda/lib/libpython3.10.so \
    -DCMAKE_BUILD_TYPE=DEBUG
RUN make -j4
RUN make install
# Set the working directory
WORKDIR /app

# Copy the requirements file and install the dependencies
#COPY requirements.txt .
#RUN pip3 install -r requirements.txt

# Install the application
RUN pip3 install oddt

# Copy additional files
COPY . .
RUN oddt_cli testdata/6d08_ligand.sdf \
    --receptor testdata/6d08_protein_processed.pdb \
    #--score autodock_vina \
    --score rfscore \
    --score rfscore_v1 \
    --score rfscore_v2 \
    --score rfscore_v3 \
    --score nnscore \
    #--score pleclinear \
    #--score plecnn \
    #--score plecrf \
    -O testdata/6d08_ligand_scored.sdf
