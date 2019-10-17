# migraphx-cadene

First, build the dockerfile with:

    docker build -t migraphx-cadene  .

Then run the built container:

    docker run -it --device=/dev/kfd --device=/dev/dri --group-add video migraphx-cadene

From there you can run the driver:

    ./driver perf /onnx/resnet50i64.onnx

