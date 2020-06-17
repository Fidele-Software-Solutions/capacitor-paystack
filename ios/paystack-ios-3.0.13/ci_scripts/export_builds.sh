PROJECTDIR="$(cd $(dirname $0)/..; pwd)"
BUILDDIR="${PROJECTDIR}/build"
rm -rf $BUILDDIR
mkdir $BUILDDIR
cd $PROJECTDIR

xcodebuild build -workspace Paystack.xcworkspace -scheme PaystackOSX -configuration Release OBJROOT=$BUILDDIR SYMROOT=$BUILDDIR | xcpretty -c
cd $BUILDDIR/Release
mkdir PaystackOSX
mv PaystackOSX.framework PaystackOSX
ditto -ck --rsrc --sequesterRsrc --keepParent PaystackOSX PaystackOSX.zip
cp PaystackOSX.zip $BUILDDIR
cd -

xcodebuild build -workspace Paystack.xcworkspace -scheme PaystackiOSStaticFramework -configuration Release OBJROOT=$BUILDDIR SYMROOT=$BUILDDIR | xcpretty -c
cd $BUILDDIR/Release-iphonesimulator
mkdir PaystackiOS
mv Paystack.framework PaystackiOS
ditto -ck --rsrc --sequesterRsrc --keepParent PaystackiOS PaystackiOS.zip
cp PaystackiOS.zip $BUILDDIR
cd -
