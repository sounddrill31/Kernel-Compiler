#Basic Script to build kernel

#!/bin/bash
#cd RyZeN
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_HOST="sounddrill"
export KBUILD_BUILD_USER="sounddrill31"
export DEFCONFIG_PATH="vendor/violet-perf_defconfig"
export DEVICENAME="violet"
MAKE="./makeparallel"

# Set Date
DATE=$(TZ=Asia/Jakarta date +"%Y%m%d")

# For end-time
BUILD_START=$(date +"%s")

blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

#TC_DIR="/home/karthik558/Workspace/"
MPATH="CLANG-13/bin/:$PATH"
rm -f out/arch/arm64/boot/Image.gz-dtb
make O=out $DEFCONFIG_PATH
PATH="$MPATH" make -j16 O=out \
    NM=llvm-nm \
    OBJCOPY=llvm-objcopy \
    LD=ld.lld \
        CROSS_COMPILE=aarch64-linux-gnu- \
        CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
        CC=clang \
        AR=llvm-ar \
        OBJDUMP=llvm-objdump \
        STRIP=llvm-strip \
        2>&1 | tee error.log

# Copying Image.gz-dtb to anykernel
cp out/arch/arm64/boot/Image.gz-dtb Anykernel/
cd Anykernel

# Ziping Kernel using Anykernel
if [ -f "Image.gz-dtb" ]; then
    zip -r9 sounddrill-$DEVICENAME-S-$DATE.zip * -x .git README.md *placeholder
cp Anykernel/sounddrill-$DEVICENAME-S-$DATE.zip .
rm Anykernel/sounddrill-$DEVICENAME-S-$DATE.zip
rm Anykernel/Image.gz-dtb

# Signzip using zipsigner
#cd /home/karthik558/Workspace/
# curl -sLo zipsigner-3.0.jar https://github.com/Magisk-Modules-Repo/zipsigner/raw/master/bin/zipsigner-3.0-dexed.jar
java -jar zipsigner-3.0.jar sounddrill-$DEVICENAME-S-$DATE.zip sounddrill-$DEVICENAME-S-$DATE-signed.zip

# Remove unsigned build
rm sounddrill-$DEVICENAME-S-$DATE.zip

# Build Completed
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"

    echo "Build success!"
else
    echo "Build failed!"
fi
