#!/bin/bash

set -e

build_combined() {
    local scheme="$1"
    local module_name="$2"
    local scope_suffix="$3"
    local config="$CONFIGURATION"

    # Derive build paths
    local build_products_path="build/DerivedData/Build/Products"
    local product_name="$module_name.framework"
    local binary_path="$module_name"
    local iphoneos_path="$build_products_path/$config-iphoneos$scope_suffix/$product_name"
    local iphonesimulator_path="$build_products_path/$config-iphonesimulator$scope_suffix/$product_name"
    local out_path="../$module_name"

    # Build for each platform
    mkdir -p build/DerivedData
    cmd="xcodebuild -derivedDataPath $PWD/build/DerivedData -workspace $module_name.xcworkspace -scheme $scheme -configuration $config"
    $cmd -sdk iphoneos clean
    $cmd -sdk iphonesimulator clean

    $cmd -sdk iphoneos build
    $cmd -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO build

    # Retrieve build products
    clean_retrieve $iphoneos_path $out_path $product_name

    # Combine ar archives
    xcrun lipo -create "$iphonesimulator_path/$binary_path" "$iphoneos_path/$binary_path" -output "$out_path/$product_name/$module_name"
}

clean_retrieve() {
    mkdir -p "$2"
    rm -rf "$2/$3"
    cp -R "$1" "$2"
}

CONFIGURATION="Release"

build_combined "MercadoPagoSDK" "MercadoPagoSDK" ""
