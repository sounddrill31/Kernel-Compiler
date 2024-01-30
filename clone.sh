# Kernel Clonning Script

#git clone https://github.com/karthik558/MsM-4.14-RyZeN- RyZeN 
#assuming . is the kernel source
git clone --depth=1 https://github.com/karthik558/AnyKernel3 Anykernel
git clone --depth=1 https://github.com/kdrag0n/proton-clang CLANG-13

# Start Build
wget https://github.com/sounddrill31/Kernel-Compiler/raw/master/run.sh
chmod +x run.sh
bash run.sh
