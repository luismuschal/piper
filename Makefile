.PHONY: clean docker

all:
	cd pp && make
	cmake -B build -DCMAKE_INSTALL_PREFIX=install -DCMAKE_BUILD_TYPE=Release
	cmake --build build --target install
	cd build && ctest
	cmake --install build
	install_name_tool -add_rpath "$(abspath build/pi/lib)" install/piper
	cd models &&  chmod +x ./setup.sh && ./setup.sh
	echo "Die Installation war erfolgreich!" | install/piper --model models/thorsten_low/thorsten_low.onnx --output-file out.wav

docker:
	docker buildx build . --platform linux/amd64,linux/arm64,linux/arm/v7 --output 'type=local,dest=dist'

clean:
	rm -rf build install dist
