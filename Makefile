############################################################
# Makefile for generating Go files from Proto
############################################################
# generate BUILD.bazel file for project. bazel >= 8.2
gazelle:
	bazel run //:gazelle && \
	bazel clean

# generate go files with bazel, and copy *.pb.go files. bazel >= 8.2
bazel:
	bazel build //... && \
	/bin/bash ./makecopy.sh && \
	bazel clean

docker:
	docker run --rm -v $(PWD):/root/go bazel-golang bazel build //...
