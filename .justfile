default:

build: b_dep setup_vocab b_ob3

b_dep: b_dbow2 b_g2o b_sophus

setup_vocab:
    echo "Uncompress vocabulary ..."
    cd Vocabulary
    tar -xf ORBvoc.txt.tar.gz

b_ob3:
    echo "Configuring and building ORB_SLAM3 ..."
    rm -rf build && mkdir build && cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release
    make -j`nproc`

b_dbow2:
    echo "Configuring and building Thirdparty/DBoW2 ..."
    cd Thirdparty/DBoW2
    rm -rf build && mkdir build
    cmake -DCMAKE_BUILD_TYPE=Release
    cd Thirdparty/DBoW2/build
    make -j`nproc`

b_g2o:
    echo "Configuring and building Thirdparty/g2o ..."
    cd Thirdparty/g2o
    rm -rf build && mkdir build
    cmake -DCMAKE_BUILD_TYPE=Release
    cd Thirdparty/g2o/build
    make -j`nproc`

b_sophus:
    echo "Configuring and building Thirdparty/Sophus ..."
    cd Thirdparty/Sophus
    rm -rf build && mkdir build
    cmake -DCMAKE_BUILD_TYPE=Release
    cd Thirdparty/Sophus/build
    make -j`nproc`
