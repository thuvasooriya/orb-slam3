default:

build: b_deps setup_vocab b_ob3

b_deps: b_dbow2 b_g2o b_sophus

setup_vocab:
    @echo ""
    @echo "===================================================="
    @echo "uncompress vocabulary ..."
    @echo "===================================================="
    cd Vocabulary && tar -xf ORBvoc.txt.tar.gz

b_ob3:
    @echo ""
    @echo "===================================================="
    @echo "configuring and building orb-slam3 ..."
    @echo "===================================================="
    mkdir -p build && cd build && cmake .. -DCMAKE_BUILD_TYPE=Release && make -j`nproc`

b_dbow2:
    @echo ""
    @echo "===================================================="
    @echo "configuring and building thirdparty/dbow2 ..."
    @echo "===================================================="
    cd deps/DBoW2 && mkdir -p build
    cd deps/DBoW2/build && cmake .. -DCMAKE_BUILD_TYPE=Release && make -j`nproc`

b_g2o:
    @echo ""
    @echo "===================================================="
    @echo "configuring and building thirdparty/g2o ..."
    @echo "===================================================="
    cd deps/g2o && mkdir -p build
    cd deps/g2o/build && cmake .. -DCMAKE_BUILD_TYPE=Release && make -j`nproc`

b_sophus:
    @echo ""
    @echo "===================================================="
    @echo "configuring and building thirdparty/sophus ..."
    @echo "===================================================="
    cd deps/Sophus && mkdir -p build
    cd deps/Sophus/build && cmake .. -DCMAKE_BUILD_TYPE=Release && make -j`nproc`

clean:
    @echo ""
    @echo "===================================================="
    @echo "cleaning build directories"
    @echo "===================================================="
    rm -rf build
    cd deps/Sophus && rm -rf build
    cd deps/g2o && rm -rf build
    cd deps/DBoW2 && rm -rf build

download_dataset_m1:
    mkdir -p datasets/EuRoC
    wget http://robotics.ethz.ch/~asl-datasets/ijrr_euroc_mav_dataset/machine_hall/MH_01_easy/MH_01_easy.zip -O datasets/EuRoC/MH01.zip
    unzip datasets/EuRoC/MH01.zip -d datasets/EuRoC/MH01 && rm datasets/EuRoC/MH01.zip

download_dataset_m2:
    mkdir -p datasets/EuRoC
    wget -O datasets/EuRoC/MH_02_easy.zip http://robotics.ethz.ch/~asl-datasets/ijrr_euroc_mav_dataset/machine_hall/MH_02_easy/MH_02_easy.zip
    unzip datasets/EuRoC/MH_02_easy.zip -d datasets/EuRoC/MH02 && rm datasets/EuRoC/MH_02_easy.zip

ex1:
    echo "launching mh01 with monocular sensor"
    Examples/Monocular/mono_euroc Vocabulary/ORBvoc.txt Examples/Monocular/EuRoC.yaml datasets/EuRoC/MH01 Examples/Monocular/EuRoC_TimeStamps/MH01.txt dataset-MH01_mono
