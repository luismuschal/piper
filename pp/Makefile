.PHONY: clean

all:
	cmake -Bbuild -DCMAKE_INSTALL_PREFIX=install -DCMAKE_BUILD_TYPE=Release
	cmake --build build
	cd build && ctest
	cmake --install build

clean:
	rm -rf build install
