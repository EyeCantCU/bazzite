ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-kinoite}"
ARG IMAGE_FLAVOR="${IMAGE_FLAVOR:-main}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-$BASE_IMAGE_NAME-$IMAGE_FLAVOR}"
ARG BASE_IMAGE="ghcr.io/ublue-os/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS bazzite

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"

COPY system_files/desktop/etc /etc
COPY system_files/desktop/usr /usr

# Add ublue packages
COPY --from=ghcr.io/ublue-os/ublue-update:latest /rpms/ublue-update.noarch.rpm /tmp/rpms/ublue-update.noarch.rpm
COPY --from=ghcr.io/ublue-os/bling:latest /rpms/ublue-os-wallpapers-*.noarch.rpm /tmp/rpms/ublue-os-wallpapers.rpm
RUN rpm-ostree override remove ublue-os-update-services && \
    rpm-ostree install \
    /tmp/rpms/ublue-update.noarch.rpm \
    /tmp/rpms/ublue-os-wallpapers.rpm

# Add Copr repos
RUN wget https://copr.fedorainfracloud.org/coprs/kylegospo/bazzite/repo/fedora-$(rpm -E %fedora)/kylegospo-bazzite-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_kylegospo-bazzite.repo && \
    wget https://copr.fedorainfracloud.org/coprs/kylegospo/system76-scheduler/repo/fedora-$(rpm -E %fedora)/kylegospo-system76-scheduler-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_kylegospo-system76-scheduler.repo && \
    wget https://copr.fedorainfracloud.org/coprs/kylegospo/hl2linux-selinux/repo/fedora-$(rpm -E %fedora)/kylegospo-hl2linux-selinux-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_kylegospo-hl2linux-selinux.repo && \
    wget https://copr.fedorainfracloud.org/coprs/kylegospo/obs-vkcapture/repo/fedora-$(rpm -E %fedora)/kylegospo-obs-vkcapture-fedora-$(rpm -E %fedora).repo?arch=x86_64 -O /etc/yum.repos.d/_copr_kylegospo-obs-vkcapture.repo && \
    wget https://copr.fedorainfracloud.org/coprs/kylegospo/wallpaper-engine-kde-plugin/repo/fedora-$(rpm -E %fedora)/kylegospo-wallpaper-engine-kde-plugin-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_kylegospo-wallpaper-engine-kde-plugin.repo

# Install new packages
RUN rpm-ostree install \
    python3-pip \
    libadwaita \
    distrobox \
    duperemove \
    input-remapper \
    system76-scheduler \
    hl2linux-selinux \
    libobs_glcapture \
    libobs_vkcapture \
    obs-vkcapture \
    btop \
    neofetch \
    fish

# Remove unneeded packages
RUN rpm-ostree override remove \
    firefox \
    firefox-langpacks \
    toolbox \ 
    htop

# KDE packages
RUN if grep "kde" <<< "${IMAGE_NAME}"; then \
    rpm-ostree install \
        steamdeck-kde-themes \
        sddm-sugar-steamOS \
        wallpaper-engine-kde-plugin \
        kdeconnectd && \
    rpm-ostree override remove \
        plasma-welcome \
        qt5-qdbusviewer \
; fi

# Install ROCM on non-Nvidia images
RUN if grep -v "nvidia" <<< "${IMAGE_NAME}"; then \
    rpm-ostree install \
        rocm-hip \
        rocm-opencl \
; fi

# Run firstboot script per-profile
RUN mkdir -p "/usr/etc/profile.d/"
RUN ln -s "/usr/share/ublue-os/firstboot/launcher/login-profile.sh" \
    "/usr/etc/profile.d/ublue-firstboot.sh"

# Cleanup & Finalize
RUN pip install --prefix=/usr yafti && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-bazzite.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-system76-scheduler.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-hl2linux-selinux.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-obs-vkcapture.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-wallpaper-engine-kde-plugin.repo && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf && \
    systemctl disable rpm-ostreed-automatic.timer && \
    systemctl --global enable ublue-update.timer && \
    systemctl enable input-remapper.service && \
    rm -rf \
        /tmp/* \
        /var/* && \
    mkdir -p /var/lib/duperemove && \
    ostree container commit && \
    mkdir -p /var/tmp && \
    chmod -R 1777 /var/tmp

FROM bazzite as bazzite-deck

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"

# Copy shared configuration
COPY system_files/deck/shared/etc /etc
COPY system_files/deck/shared/usr /usr
RUN ln -s /usr/bin/steamos-logger /usr/bin/steamos-info && \
    ln -s /usr/bin/steamos-logger /usr/bin/steamos-notice && \
    ln -s /usr/bin/steamos-logger /usr/bin/steamos-warning

# Copy Gnome configuration
RUN mkdir -p /tmp/gnome
COPY system_files/deck/gnome/usr /tmp/gnome/usr
RUN if grep "gnome" <<< "${IMAGE_NAME}"; then \
    cp -rf /tmp/gnome/usr/* /usr \
; fi

# Copy KDE configuration
RUN mkdir -p /tmp/kde
COPY system_files/deck/kde/usr /tmp/kde/usr
RUN if grep "kde" <<< "${IMAGE_NAME}"; then \
    cp -rf /tmp/kde/usr/* /usr \
; fi

# Add LatencyFleX and MangoApp Copr repos
RUN wget https://copr.fedorainfracloud.org/coprs/kylegospo/LatencyFleX/repo/fedora-$(rpm -E %fedora)/kylegospo-LatencyFleX-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_kylegospo-latencyflex.repo && \
    wget https://copr.fedorainfracloud.org/coprs/kylegospo/mangohud/repo/fedora-$(rpm -E %fedora)/kylegospo-mangohud-fedora-$(rpm -E %fedora).repo?arch=x86_64 -O /etc/yum.repos.d/_copr_kylegospo-mangohud.repo

# Re-enable Copr repos
RUN sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/_copr_kylegospo-bazzite.repo && \
    sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/_copr_kylegospo-hl2linux-selinux.repo && \
    sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/_copr_kylegospo-obs-vkcapture.repo && \
    sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/_copr_kylegospo-wallpaper-engine-kde-plugin.repo

# Remove system76-scheduler
RUN rpm-ostree override remove system76-scheduler
RUN rm -f /etc/systemd/user/com.system76.Scheduler.dbusproxy.service
RUN rm -f /usr/bin/system76-scheduler-dbus-proxy

# Use SDDM in Gnome images
RUN if grep "gnome" <<< "${IMAGE_NAME}"; then \
    rpm-ostree install \
        sddm \
        sddm-sugar-steamOS \
; fi

# Install Steam Deck KDE preferences
RUN if grep "kde" <<< "${IMAGE_NAME}"; then \
    rpm-ostree override remove \
        steamdeck-kde-themes && \
    rpm-ostree install \
        steamdeck-kde-presets \
; fi

# Remove ublue-os-wallpapers
RUN rpm-ostree override remove ublue-os-wallpapers

# Install patched udisks2 (Needed for SteamOS SD card mounting)
RUN rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:kylegospo:bazzite udisks2

# Install mesa-va-drivers shim (Needed due to dependency issues in Steam package)
RUN rpm-ostree install \
    mesa-va-drivers

# Install new packages
RUN rpm-ostree install \
    steam \
    lutris \
    gamescope \
    gamescope-session \
    jupiter-fan-control \
    jupiter-hw-support-btrfs \
    ryzenadj \
    gamemode \
    latencyflex-vulkan-layer \
    vkBasalt \
    mangohud \
    sdgyrodsu

# Remove unneeded packages
RUN if grep "kde" <<< "${IMAGE_NAME}"; then \
    rpm-ostree override remove \
        krfb \
        krfb-libs \
; fi

# Install dock updater, this is done manually due to proprietary parts preventing it from being on Copr.
RUN git clone https://gitlab.com/evlaV/jupiter-dock-updater-bin.git --single-branch /tmp/jupiter-dock-updater-bin && \
    mv -v /tmp/jupiter-dock-updater-bin/packaged/usr/lib/jupiter-dock-updater /usr/lib/jupiter-dock-updater

# Suspend using power button
RUN sed -i 's/#HandlePowerKey=poweroff/HandlePowerKey=suspend/g' /etc/systemd/logind.conf

# Cleanup & Finalize
RUN sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-bazzite.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-latencyflex.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-mangohud.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-hl2linux-selinux.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-obs-vkcapture.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-wallpaper-engine-kde-plugin.repo && \
    if grep "gnome" <<< "${IMAGE_NAME}"; then \
        systemctl disable gdm.service && \
        systemctl enable sddm.service \
    ; fi && \
    if grep "kde" <<< "${IMAGE_NAME}"; then \
        systemctl enable plasma-autologin.service \
    ; fi && \
    systemctl enable jupiter-fan-control.service && \
    systemctl enable set-cfs-tweaks.service && \
    systemctl disable input-remapper.service && \
    systemctl --global disable ublue-update.timer && \
    rm -rf \
        /tmp/* \
        /var/* && \
    mkdir -p /var/lib/duperemove && \
    ostree container commit
