# sync rom
repo init --depth=1 --no-repo-verify -u git://github.com/ProjectKasumi/android.git -b kasumi-v1 -g default,-mips,-darwin,-notdefault
git clone https://github.com/RasyidAlKautsar/local_manifest.git --depth 1 -b Kasumi .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
. build/envsetup.sh
lunch kasumi_mido-userdebug
export SKIP_ABI_CHECKS=true
export RELAX_USES_LIBRARY_CHECK=true
export ALLOW_MISSING_DEPENDENCIES=true
export LINEAGE_BUILDTYPE=OFFICIAL
export TZ=Asia/Jakarta #put before last build command
mka bandori

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
