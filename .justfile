default:

build: b_dep setup_vocab b_ob3

b_dep: b_dbow2 b_g2o b_sophus

setup_vocab:
    echo "uncompress vocabulary ..."
    cd Vocabulary && tar -xf ORBvoc.txt.tar.gz

b_ob3:
    echo "configuring and building orb-slam3 ..."
    mkdir -p build && cd build && cmake .. -DCMAKE_BUILD_TYPE=Release && make -j`nproc`

b_dbow2:
    echo "configuring and building thirdparty/dbow2 ..."
    cd Thirdparty/DBoW2 && mkdir -p build
    cd Thirdparty/DBoW2/build && cmake .. -DCMAKE_BUILD_TYPE=Release && make -j`nproc`

b_g2o:
    echo "configuring and building thirdparty/g2o ..."
    cd Thirdparty/g2o && mkdir -p build
    cd Thirdparty/g2o/build && cmake .. -DCMAKE_BUILD_TYPE=Release && make -j`nproc`

b_sophus:
    echo "configuring and building thirdparty/sophus ..."
    cd Thirdparty/Sophus && mkdir -p build
    cd Thirdparty/Sophus/build && cmake .. -DCMAKE_BUILD_TYPE=Release && make -j`nproc`

clean:
    rm -rf build
    cd Thirdparty/Sophus && rm -rf build
    cd Thirdparty/g2o && rm -rf build
    cd Thirdparty/DBoW2 && rm -rf build
