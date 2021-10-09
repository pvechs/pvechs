#!/usr/bin/env bash

## 用来自动将src下的翻译转换为release下的js文件

names=(pbs pmg pve)

for name in ${names[@]}; do
    file_src=src/$name.txt
    file_release=release/${name}-lang-zh_CN.js
    echo "// dev-build $(date +'%Y-%m-%d %H:%M:%S')" > $file_release
    cat $file_src \
        | perl -pe "{s|^(\d+):(.*)$|\"\1\":\[\"\2\"\],|g; s|\n||g;}" \
        | perl -pe "s|^(.*),$|__proxmox_i18n_msgcat__ = \{\1\};\n\n|" \
        >> $file_release

    cat >> $file_release << EOF
function fnv31a(text) {
    var len = text.length;
    var hval = 0x811c9dc5;
    for (var i = 0; i < len; i++) {
	var c = text.charCodeAt(i);
	hval ^= c;
	hval += (hval << 1) + (hval << 4) + (hval << 7) + (hval << 8) + (hval << 24);
    }
    hval &= 0x7fffffff;
    return hval;
}

function gettext(buf) {
    var digest = fnv31a(buf);
    var data = __proxmox_i18n_msgcat__[digest];
    if (!data) {
	return buf;
    }
    return data[0] || buf;
}
EOF
done
