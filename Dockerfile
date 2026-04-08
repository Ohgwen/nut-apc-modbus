FROM debian:bookworm-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    git build-essential autoconf automake libtool pkg-config \
    libusb-1.0-0-dev libssl-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# --- Build custom libmodbus with USB support ---
RUN git clone -b rtu_usb https://github.com/networkupstools/libmodbus.git
WORKDIR /build/libmodbus
RUN ./autogen.sh && \
    ./configure --with-libusb --enable-static --disable-shared --prefix=/usr/local && \
    make -j$(nproc) && make install

# --- Build NUT with apc_modbus ---
WORKDIR /build
RUN git clone https://github.com/networkupstools/nut.git
WORKDIR /build/nut
RUN ./autogen.sh && \
    ./configure \
      --with-drivers=apc_modbus \
      --with-usb \
      --with-modbus \
      --with-modbus-includes=-I/usr/local/include/modbus \
      --with-modbus-libs="-L/usr/local/lib -lmodbus" \
      --prefix=/usr \
    && make -j$(nproc) && make install

# Runtime setup
RUN useradd -r -s /bin/false nut

# Copy configs (you mount these later)
VOLUME ["/etc/nut"]

EXPOSE 3493

CMD ["upsd", "-F"]