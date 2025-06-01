FROM --platform=linux/amd64 ubuntu:latest

ARG GO_VERSION=1.24.3
ARG LLVM_VERSION=20
ARG BAZEL_VERSION=8.2.0

RUN apt update && \
    upgrade -y && \
    apt install -y curl wget g++ unzip zip gnupg lsb-release

# Install Go
RUN wget -c https://dl.google.com/go/go1.24.3.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && rm go${GO_VERSION}.linux-amd64.tar.gz 
ENV PATH="/usr/local/go/bin:${PATH}"
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Install Bazel
RUN curl -L -o bazel-installer.sh https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh
RUN chmod +x bazel-installer.sh && \
    ./bazel-installer.sh --user && \
    rm bazel-installer.sh

# Install LLVM
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | gpg --dearmor > /usr/share/keyrings/llvm-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/llvm-archive-keyring.gpg] https://apt.llvm.org/focal/ llvm-toolchain-focal-${LLVM_VERSION} main" > /etc/apt/sources.list.d/llvm.list && \
    apt update && \
    apt install -y clang-${LLVM_VERSION} lld-${LLVM_VERSION} libc++-${LLVM_VERSION}-dev libc++abi-${LLVM_VERSION}-dev libclang-${LLVM_VERSION}-dev
RUN wget -c https://apt.llvm.org/llvm.sh && \
    chmod +x llvm.sh && \
    ./llvm.sh ${LLVM_VERSION} all && \
    rm llvm.sh
ENV PATH="/root/bin:${PATH}"

RUN apt-get clean && rm -rf /var/cache/apt/* /var/lib/apt/lists/*

CMD ["/bin/bash"]



