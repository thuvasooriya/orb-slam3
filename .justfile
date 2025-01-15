[private]
default:
    @just --list --unsorted --list-heading $'orb-slam3 devenv commands\n'

# automatically build dependencies and build orb-slam3
build: b_deps setup_vocab b_ob3

# build all dependencies
b_deps: b_dbow2 b_g2o b_sophus

# uncompress vocabulary for usage in examples
setup_vocab:
    @echo ""
    @echo "===================================================="
    @echo "{{ BOLD }}{{ BLUE }}uncompress vocabulary{{ NORMAL }}"
    @echo "===================================================="
    cd Vocabulary && tar -xf ORBvoc.txt.tar.gz

# build the orb-slam3 main lib
b_ob3:
    @echo ""
    @echo "===================================================="
    @echo "{{ BOLD }}{{ BLUE }}configuring and building orb-slam3{{ NORMAL }}"
    @echo "===================================================="
    mkdir -p build && cd build && cmake .. -DCMAKE_BUILD_TYPE=Release && make -j`nproc`

# build dependency DBoW2
b_dbow2:
    @echo ""
    @echo "===================================================="
    @echo "{{ BOLD }}{{ BLUE }}configuring and building deps/dbow2{{ NORMAL }}"
    @echo "===================================================="
    cd deps/DBoW2 && mkdir -p build
    cd deps/DBoW2/build && cmake .. -DCMAKE_BUILD_TYPE=Release && make -j`nproc`

# build dependency g2o
b_g2o:
    @echo ""
    @echo "===================================================="
    @echo "{{ BOLD }}{{ BLUE }}configuring and building deps/g2o{{ NORMAL }}"
    @echo "===================================================="
    cd deps/g2o && mkdir -p build
    cd deps/g2o/build && cmake .. -DCMAKE_BUILD_TYPE=Release && make -j`nproc`

# build dependency Sophus
b_sophus:
    @echo ""
    @echo "===================================================="
    @echo "{{ BOLD }}{{ BLUE }}configuring and building deps/sophus{{ NORMAL }}"
    @echo "===================================================="
    cd deps/Sophus && mkdir -p build
    cd deps/Sophus/build && cmake .. -DCMAKE_BUILD_TYPE=Release && make -j`nproc`

# clean build directories
clean:
    @echo ""
    @echo "===================================================="
    @echo "{{ BOLD }}{{ BLUE }}cleaning build directories{{ NORMAL }}"
    @echo "===================================================="
    rm -rf build
    cd deps/Sophus && rm -rf build
    cd deps/g2o && rm -rf build
    cd deps/DBoW2 && rm -rf build

# download dataset EuRoC/MH01
download_dataset_m1:
    mkdir -p datasets/EuRoC
    wget http://robotics.ethz.ch/~asl-datasets/ijrr_euroc_mav_dataset/machine_hall/MH_01_easy/MH_01_easy.zip -O datasets/EuRoC/MH01.zip
    unzip datasets/EuRoC/MH01.zip -d datasets/EuRoC/MH01 && rm datasets/EuRoC/MH01.zip

# download dataset EuRoC/MH02_easy
download_dataset_m2:
    mkdir -p datasets/EuRoC
    wget -O datasets/EuRoC/MH_02_easy.zip http://robotics.ethz.ch/~asl-datasets/ijrr_euroc_mav_dataset/machine_hall/MH_02_easy/MH_02_easy.zip
    unzip datasets/EuRoC/MH_02_easy.zip -d datasets/EuRoC/MH02 && rm datasets/EuRoC/MH_02_easy.zip

# run MH01 Monocular example
ex1:
    @echo "{{ BOLD }}{{ BLUE }}launching mh01 with monocular sensor{{ NORMAL }}"
    Examples/Monocular/mono_euroc Vocabulary/ORBvoc.txt Examples/Monocular/EuRoC.yaml datasets/EuRoC/MH01 Examples/Monocular/EuRoC_TimeStamps/MH01.txt dataset-MH01_mono
