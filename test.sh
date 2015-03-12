#!/bin/bash

test() {
    local name="$1"
    local command="$2"
    local expect="$3"
    local result="$(eval $command 2>&1)"
    if [[ "$result" == "$expect" ]]; then
        echo "[+] $name: \$($command)"
    else
        echo "[!] $name: \$($command)"
        printf "      result = %q\n" "$result"
        printf "      expect = %q\n" "$expect"
    fi
}

test 'echo test' 'echo 1' '1'
test 'use just as cat' 'yes | head | ./dog -n' '     1	y
     2	y
     3	y
     4	y
     5	y
     6	y
     7	y
     8	y
     9	y
    10	y'

test 'convert as rot13' 'echo -n 1234TESTtest | ./dog -c rot13' '1234GRFGgrfg'
test 'convert as upper' 'echo -n 1234TESTtest | ./dog -c upper' '1234TESTTEST'
test 'convert as lower' 'echo -n 1234TESTtest | ./dog -c lower' '1234testtest'
test 'convert as crlf' 'echo -en "/\r\n/\r/\n/" | ./dog -c crlf' $'/\r\n/\r\n/\r\n/'
test 'convert as cr' 'echo -en "/\r\n/\r/\n/" | ./dog -c cr' $'/\r/\r/\r/'
test 'convert as lf' 'echo -en "/\r\n/\r/\n/" | ./dog -c lf' $'/\n/\n/\n/'

test 'encode as hex' 'echo -n 日本語 | ./dog -e hex | base64' 'XHhlNlx4OTdceGE1XHhlNlx4OWNceGFjXHhlOFx4YWFceDll'
test 'encode as unicode' 'echo -n 日本語 | ./dog -e unicode | base64' 'XHU2NWU1XHU2NzJjXHU4YTll'
test 'encode as url' 'echo -n 日本語 | ./dog -e url' '%E6%97%A5%E6%9C%AC%E8%AA%9E'
test 'encode as html' 'echo -n 日本語 | ./dog -e html | base64' 'JiN4NjVlNSYjeDY3MmMmI3g4YTll'
test 'encode as base64' 'echo -n 日本語 | ./dog -e base64' '5pel5pys6Kqe'
test 'encode as quopri' 'echo -n 日本語 | ./dog -e quopri' '=E6=97=A5=E6=9C=AC=E8=AA=9E'
test 'encode as punycode' 'echo -n 日本語 | ./dog -e punycode' 'xn--wgv71a119e'
test 'encode as uu' 'echo -n 日本語 | ./dog -e uu | base64' 'YmVnaW4gNjY2IDxkYXRhPgopWUk+RVlJUkxaKko+CiAKZW5kCg=='
test 'encode as deflate' 'echo -n 日本語 | ./dog -e deflate | base64' 'eJx7Nn3pszlrXqyaBwAhJAaB'
test 'encode as bz2' 'echo -n 日本語 | ./dog -e bz2 | base64' 'QlpoOTFBWSZTWV1AcnsAAAMAMQCFAhQBQCAAIZDCEMCIHtTl8XckU4UJBdQHJ7A='

test 'decode as hex' 'echo -n XHhlNlx4OTdceGE1XHhlNlx4OWNceGFjXHhlOFx4YWFceDll | base64 -d | ./dog -d hex' '日本語'
test 'decode as unicode' 'echo -n XHU2NWU1XHU2NzJjXHU4YTll | base64 -d | ./dog -d unicode' '日本語'
test 'decode as url' 'echo -n %E6%97%A5%E6%9C%AC%E8%AA%9E | ./dog -d url' '日本語'
test 'decode as html' 'echo -n JiN4NjVlNSYjeDY3MmMmI3g4YTll | base64 -d | ./dog -d html' '日本語'
test 'decode as base64' 'echo -n 5pel5pys6Kqe | ./dog -d base64' '日本語'
test 'decode as quopri' 'echo -n =E6=97=A5=E6=9C=AC=E8=AA=9E | ./dog -d quopri' '日本語'
test 'decode as punycode' 'echo -n xn--wgv71a119e | ./dog -d punycode' '日本語'
test 'decode as uu' 'echo -n YmVnaW4gNjY2IDxkYXRhPgopWUk+RVlJUkxaKko+CiAKZW5kCg== | base64 -d | ./dog -d uu' '日本語'
test 'decode as deflate' 'echo -n eJx7Nn3pszlrXqyaBwAhJAaB | base64 -d | ./dog -d deflate' '日本語'
test 'decode as bz2' 'echo -n QlpoOTFBWSZTWV1AcnsAAAMAMQCFAhQBQCAAIZDCEMCIHtTl8XckU4UJBdQHJ7A= | base64 -d | ./dog -d bz2' '日本語'

test 'calculate hash CRC-32' 'echo -n 1234TESTtest | ./dog -h crc32' '0dabf39c'
test 'calculate hash Adler-32' 'echo -n 1234TESTtest | ./dog -h adler32' '14c203cb'
test 'calculate hash MD5' 'echo -n 1234TESTtest | ./dog -h md5' '7dd0bab05b5cb88b2719cf0442e58de5'
test 'calculate hash SHA-1' 'echo -n 1234TESTtest | ./dog -h sha1' 'bfd0652177588965c996afc4fe42d7d01e583032'
test 'calculate hash SHA-224' 'echo -n 1234TESTtest | ./dog -h sha224' '31c65baa0d74c6cf66e41aac2e8e8486260d77c1924ebf69000f32a2'
test 'calculate hash SHA-256' 'echo -n 1234TESTtest | ./dog -h sha256' '40e3243c6d9dfdb8bb1cc139263f0238e4658be0ab15fc562797e5ce3a535756'
test 'calculate hash SHA-384' 'echo -n 1234TESTtest | ./dog -h sha384' '33609320885b35b8a288dea5176c6d2e47e7acfb8172c0b616dc92faa14718d42a102b0eb79da3f24fd6d7fbbcb20152'
test 'calculate hash SHA-512' 'echo -n 1234TESTtest | ./dog -h sha512' '5e1f95319c563cbd7a66fa1239d5ca18101b61016e49501443af21ab80a6417e85dd260ad4bcd285b2fbd24496a28465fdd1b7b2a8ccaf34b65ca3dcef6d455c'

test 'iconvert from UTF-8 to SJIS' 'echo -n 日本語 | ./dog -i utf8:sjis | base64' 'k/qWe4zq'
test 'iconvert from SJIS to UTF-8' 'echo -n k/qWe4zq | base64 -d | ./dog -i sjis:utf8' '日本語'
test 'iconvert from UTF-8 (auto) to SJIS' 'echo -n 日本語 | ./dog -i :sjis | base64' 'k/qWe4zq'
test 'iconvert from SJIS (auto) to UTF-8' 'echo -n k/qWe4zq | base64 -d | ./dog -i :utf8' '日本語'
test 'iconvert from SJIS (auto) to UTF-8 (auto)' 'echo -n k/qWe4zq | base64 -d | ./dog -i :' '日本語'
