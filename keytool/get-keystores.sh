#!/bin/sh

private_alias="privateKey"
public_alias="publicCert"
store_pass="qT5oC3yS2r"
key_pass="eQ3gS5vL1c"
dname="CN=Cellx, OU=Cellx, O=Cellx, L=SZ, S=SZ, C=CN"

## mkdir
rm -rf ./keystores
mkdir -p ./keystores
cd ./keystores || exit

## privateKeys.keystore
keytool -genkeypair -alias $private_alias -keyalg DSA -keysize 1024 -keystore privateKeys.keystore -storepass $store_pass -keypass $key_pass -sigalg SHA1withDSA -dname "$dname"

## licenseCert.cer
keytool -export -alias $private_alias -file licenseCert.cer -keystore privateKeys.keystore -storepass $store_pass

## publicCerts.keystore
keytool -import -alias $public_alias -file licenseCert.cer -keystore publicCerts.keystore -storepass $store_pass -noprompt

## test keystores
keytool -list -keystore privateKeys.keystore -storepass $store_pass
keytool -list -keystore publicCerts.keystore -storepass $store_pass
