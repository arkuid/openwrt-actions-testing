#!/bin/bash

commits=(
    "41bbbf8f3b11b23b4e16450d1f3de66308c3effa"
    "0d94be1fe628c6bd3bdc9d8a363b21c733b8d88e"
    "931c018182062de0d86a3c0655697382abe11101"
    "7dbac98d83e030c4b678eb3948ef197f4437e113"
    "bdfd68fbf046fc8dc3365520bad138dd619997e6"
    "3c8d07594759db6d6c5b52d68c028ba88a8b4c0c"
    "a9d1fd09810c55cf32774fb9a806aa59b478b371"
    "a5ba23a65dc249a19872b1011473e2fa46ca4904"
    "2ae27dba1fd3ad5a36959f51fc7ec92e4ebf6c18"
    "66c0b8fb945785b33f0ff7b8fd560f3478d8dc10"
    "7891a2db01dfe001d416316b0b224ddd0844b34b"
    "134d7a3524d115232d243ef48f5f61fb1ce268a9"
    "063ee3445bc0f7159a7dae68e8ccb0fa19488140"
    "3d605bf44969563c2d8f9d0b4ee6e8070cd337a5"
    "0e139698a1571bda50698f1b7ffbba31032599b4"
    "d047ae44bd6839d3e2aa6bf317663a5fb0db62ca"
    "a8de00705300707a032db56c69ab25983bc21e2c"
    "696372ce3e24c8460909eb0d8b2688befd9c9527"
    "b8c2530144fec35c345245f09b93f94cf69706ce"
    "e77398ca9a6b8c72de26e9e5865c40edcc5e068d"
)

for commit in "${commits[@]}"; do
    patch_url="https://github.com/namiltd/openwrt/commit/${commit}.patch"
    curl -sL "$patch_url" -o "${commit}.patch"
    
    echo "Применяю патч: ${commit}"
    patch -p1 < "${commit}.patch" 2>/dev/null
done
rm -f *.patch
