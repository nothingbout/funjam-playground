set -ex
./build.sh release
npx vite build Web --base=./
mkdir Web/dist/assets/wasm
cp Web/wasm/App.wasm Web/dist/assets/wasm/
