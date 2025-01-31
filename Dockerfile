# Dockerfile
FROM alpine:3 AS builder

# Install Packages
RUN apk add --no-cache go lzip build-base gcc gmp-dev db-dev ncurses-dev

# Download and compile GnuCOBOL
WORKDIR /tmp
RUN wget "https://kumisystems.dl.sourceforge.net/project/gnucobol/gnucobol/3.2/gnucobol-3.2.tar.lz?viasf=1" -O gnucobol-3.2.tar.lz && \
    lzip -d gnucobol-3.2.tar.lz && \
    tar -xf gnucobol-3.2.tar && \
    cd gnucobol-3.2 && \
    ./configure && \
    make && \
    make install
RUN ldconfig /usr/local/lib


# Copy COBOL and Go source
WORKDIR /build
COPY cobol-age.cob .
COPY server.go .

# Compile COBOL program
RUN cobc -x -free cobol-age.cob -o cobol-age

# Initialize Go module
RUN go mod init cobol-server
RUN go build -o server

# Runtime stage
FROM alpine:3

# Install runtime dependencies
RUN apk add --no-cache gmp db ncurses-libs

# Copy GnuCOBOL runtime files
COPY --from=builder /usr/local/lib/libcob.so.4 /usr/local/lib/
COPY --from=builder /usr/local/lib/libcob.so.4.2.0 /usr/local/lib/
COPY --from=builder /usr/local/share/gnucobol /usr/local/share/gnucobol/

# Create required symlinks
RUN ln -s /usr/local/lib/libcob.so.4.2.0 /usr/local/lib/libcob.so && \
    ldconfig /usr/local/lib

# Copy compiled binaries
WORKDIR /app
COPY --from=builder /build/cobol-age .
COPY --from=builder /build/server .

# Ensure executables are executable
RUN chmod +x /app/cobol-age /app/server

# Run the Go server
CMD ["./server"]