
## Prerequisites

Install the Swift toolchain and the WebAssembly SDK as per https://www.swift.org/documentation/articles/wasm-getting-started.html

## Build and run for development

```sh
./build.sh [debug|release]
npx serve Web
```

## Deploying

https://swiftpackageindex.com/swiftwasm/javascriptkit/0.37.0/documentation/javascriptkit/deploying-pages

```
npx vite build Web
mkdir Web/dist/assets/wasm
cp Web/wasm/App.wasm Web/dist/assets/wasm/
```
