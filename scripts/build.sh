cd ..

rm -rf fluidsynth/build/
mkdir fluidsynth/build
cd fluidsynth/build
cmake ..
make clean
make