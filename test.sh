#!/bin/bash

test() {
    local name="$1"
    local command="$2"
    local expect="$3"
    local result="$(eval $command 2>&1)"
    if [[ "$result" == "$expect" ]]; then
        echo -en '\x1b[32m'
        echo "[+] $name: \$($command)"
        echo -en '\x1b[0m'
    else
        echo -en '\x1b[31m'
        echo "[!] $name: \$($command)"
        printf "      result = %q\n" "$result"
        printf "      expect = %q\n" "$expect"
        echo -en '\x1b[0m'
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

test 'convert as bin' 'echo -n 052 | ./dog -c bin' '0b101010'
test 'convert as oct' 'echo -n 42 | ./dog -c oct' '052'
test 'convert as dec' 'echo -n 0x2a | ./dog -c dec' '42'
test 'convert as hex' 'echo -n 0b101010 | ./dog -c hex' '0x2a'
test 'convert as crlf' 'echo -en "/\r\n/\r/\n/" | ./dog -c crlf' $'/\r\n/\r\n/\r\n/'
test 'convert as cr' 'echo -en "/\r\n/\r/\n/" | ./dog -c cr' $'/\r/\r/\r/'
test 'convert as lf' 'echo -en "/\r\n/\r/\n/" | ./dog -c lf' $'/\n/\n/\n/'
test 'convert as upper' 'echo -n 1234TESTtest | ./dog -c upper' '1234TESTTEST'
test 'convert as lower' 'echo -n 1234TESTtest | ./dog -c lower' '1234testtest'
test 'convert as rot13' 'echo -n 1234TESTtest | ./dog -c rot13' '1234GRFGgrfg'
test 'convert with uppercase arg' 'echo -n 1234TESTtest | ./dog -c ROT13' '1234GRFGgrfg'

test 'encode as hex' 'echo -n 日本語 | ./dog -e hex' "\\xe6\\x97\\xa5\\xe6\\x9c\\xac\\xe8\\xaa\\x9e"
test 'encode as jsescape' 'echo -n 日本語 | ./dog -e jsescape' "%u97e6%ue6a5%uac9c%uaae8%u009e"
test 'encode as url' 'echo -n 日本語 | ./dog -e url' '%E6%97%A5%E6%9C%AC%E8%AA%9E'
test 'encode as html' 'echo -n 日本語 | ./dog -e html' '&#x65e5&#x672c&#x8a9e'
test 'encode as base64' 'echo -n 日本語 | ./dog -e base64' '5pel5pys6Kqe'
test 'encode as quopri' 'echo -n 日本語 | ./dog -e quopri' '=E6=97=A5=E6=9C=AC=E8=AA=9E'
test 'encode as punycode' 'echo -n 日本語 | ./dog -e punycode' 'xn--wgv71a119e'
test 'encode as uu' 'echo -n 日本語 | ./dog -e uu | base64' 'YmVnaW4gNjY2IDxkYXRhPgopWUk+RVlJUkxaKko+CiAKZW5kCg=='
test 'encode as deflate' 'echo -n 日本語 | ./dog -e deflate | base64' 'eJx7Nn3pszlrXqyaBwAhJAaB'
test 'encode as bz2' 'echo -n 日本語 | ./dog -e bz2 | base64' 'QlpoOTFBWSZTWV1AcnsAAAMAMQCFAhQBQCAAIZDCEMCIHtTl8XckU4UJBdQHJ7A='
test 'encode with uppercase arg' 'echo -n 日本語 | ./dog -e BZ2 | base64' 'QlpoOTFBWSZTWV1AcnsAAAMAMQCFAhQBQCAAIZDCEMCIHtTl8XckU4UJBdQHJ7A='

test 'decode as hex' 'echo -n \\xe6\\x97\\xa5\\xe6\\x9c\\xac\\xe8\\xaa\\x9e | ./dog -d hex' '日本語'
test 'decode as jsescape' 'echo -n %u97e6%ue6a5%uac9c%uaae8%u009e | ./dog -d jsescape' '日本語'
test 'decode as url' 'echo -n %E6%97%A5%E6%9C%AC%E8%AA%9E | ./dog -d url' '日本語'
test 'decode as html' 'echo -n \&#x65e5\&#x672c\&#x8a9e | ./dog -d html' '日本語'
test 'decode as base64' 'echo -n 5pel5pys6Kqe | ./dog -d base64' '日本語'
test 'decode as quopri' 'echo -n =E6=97=A5=E6=9C=AC=E8=AA=9E | ./dog -d quopri' '日本語'
test 'decode as punycode' 'echo -n xn--wgv71a119e | ./dog -d punycode' '日本語'
test 'decode as uu' 'echo -n YmVnaW4gNjY2IDxkYXRhPgopWUk+RVlJUkxaKko+CiAKZW5kCg== | base64 -d | ./dog -d uu' '日本語'
test 'decode as deflate' 'echo -n eJx7Nn3pszlrXqyaBwAhJAaB | base64 -d | ./dog -d deflate' '日本語'
test 'decode as bz2' 'echo -n QlpoOTFBWSZTWV1AcnsAAAMAMQCFAhQBQCAAIZDCEMCIHtTl8XckU4UJBdQHJ7A= | base64 -d | ./dog -d bz2' '日本語'
test 'decode with uppercase arg' 'echo -n QlpoOTFBWSZTWV1AcnsAAAMAMQCFAhQBQCAAIZDCEMCIHtTl8XckU4UJBdQHJ7A= | base64 -d | ./dog -d BZ2' '日本語'

test 'calculate hash CRC-32' 'echo -n 1234TESTtest | ./dog -h crc32' '0dabf39c'
test 'calculate hash Adler-32' 'echo -n 1234TESTtest | ./dog -h adler32' '14c203cb'
test 'calculate hash MD5' 'echo -n 1234TESTtest | ./dog -h md5' '7dd0bab05b5cb88b2719cf0442e58de5'
test 'calculate hash SHA-1' 'echo -n 1234TESTtest | ./dog -h sha1' 'bfd0652177588965c996afc4fe42d7d01e583032'
test 'calculate hash SHA-224' 'echo -n 1234TESTtest | ./dog -h sha224' '31c65baa0d74c6cf66e41aac2e8e8486260d77c1924ebf69000f32a2'
test 'calculate hash SHA-256' 'echo -n 1234TESTtest | ./dog -h sha256' '40e3243c6d9dfdb8bb1cc139263f0238e4658be0ab15fc562797e5ce3a535756'
test 'calculate hash SHA-384' 'echo -n 1234TESTtest | ./dog -h sha384' '33609320885b35b8a288dea5176c6d2e47e7acfb8172c0b616dc92faa14718d42a102b0eb79da3f24fd6d7fbbcb20152'
test 'calculate hash SHA-512' 'echo -n 1234TESTtest | ./dog -h sha512' '5e1f95319c563cbd7a66fa1239d5ca18101b61016e49501443af21ab80a6417e85dd260ad4bcd285b2fbd24496a28465fdd1b7b2a8ccaf34b65ca3dcef6d455c'
test 'calculate hash with uppercase arg' 'echo -n 1234TESTtest | ./dog -h SHA512' '5e1f95319c563cbd7a66fa1239d5ca18101b61016e49501443af21ab80a6417e85dd260ad4bcd285b2fbd24496a28465fdd1b7b2a8ccaf34b65ca3dcef6d455c'

test 'iconvert from UTF-8 to SJIS' 'echo -n 日本語 | ./dog -i utf8:sjis | base64' 'k/qWe4zq'
test 'iconvert from SJIS to UTF-8' 'echo -n k/qWe4zq | base64 -d | ./dog -i sjis:utf8' '日本語'
test 'iconvert from SJIS (auto) to UTF-8' 'echo -n k/qWe4zq | base64 -d | ./dog -i :utf8' '日本語'
test 'iconvert from SJIS to UTF-8 (auto)' 'echo -n k/qWe4zq | base64 -d | ./dog -i sjis:' '日本語'
test 'iconvert from SJIS (auto) to UTF-8 (auto)' 'echo -n k/qWe4zq | base64 -d | ./dog -i :' '日本語'
test 'iconvert with uppercase arg' 'echo -n 日本語 | ./dog -i UTF8:SJIS | base64' 'k/qWe4zq'

targz='H4sIAA1nBVUAA+3OMQ6DMBBFQR/FR1hjDOdJQRkJEVLk9nEiRUpFB9VM84r9xS73dX+lc0U3jeOnZW7x359UhhZlmGqda4rS5y3lOPmvr+djv2059y7b8e74DgAAAAAAAAAAABd6Ax/0KEsAKAAA'
tarbz2='QlpoOTFBWSZTWTiG3j8AAHH7gMCAAEBAAH+AAAhiAl4gAgggAHUMhQ9RoPUB6agkiajQekABx5f8JBSEIRMEzhS4yZJA7PV3qQLWE4zKNkZCoiLaqEYQHfJwwmrj6UE0cKzvVmJIPxdyRThQkDiG3j8='
tarxz='/Td6WFoAAATm1rRGAgAhARYAAAB0L+Wj4Cf/AGVdADKbSmgkA4fGSjkXbrXKf3b1sCym+R2hd7LQR/21pc5iGythU/78Pn83h49UaiQjfH8lTcFC/ulJPt0qYNW/g4YUIyBb84vbXM7JhCkhpsTnbe9rPd1epZxctR0XwlXcp892C/AAAAAAAEN564HDaY1BAAGBAYBQAACbojyqscRn+wIAAAAABFla'
zip='UEsDBAoAAAAAAGygb0YAAAAAAAAAAAAAAAAFABwAZW1wdHlVVAkAA/tmBVX7ZgVVdXgLAAEE6AMAAAToAwAAUEsBAh4DCgAAAAAAbKBvRgAAAAAAAAAAAAAAAAUAGAAAAAAAAAAAAKSBAAAAAGVtcHR5VVQFAAP7ZgVVdXgLAAEE6AMAAAToAwAAUEsFBgAAAAABAAEASwAAAD8AAAAAAA=='
otherwise='H4sICPtmBVUAA2VtcHR5AAMAAAAAAAAAAAA='
test 'list tar.gz' 'echo -n $targz | base64 -d | ./dog -l' $'gzip compressed data, from Unix, last modified: Sun Mar 15 20:03:41 2015\n-rw-r--r-- user/user         0 2015-03-15 20:03 empty'
test 'list tar.bz2' 'echo -n $tarbz2 | base64 -d | ./dog -l' $'bzip2 compressed data, block size = 900k\n-rw-r--r-- user/user         0 2015-03-15 20:03 empty'
test 'list tar.xz' 'echo -n $tarxz | base64 -d | ./dog -l' $'XZ compressed data\n-rw-r--r-- user/user         0 2015-03-15 20:03 empty'
test 'list zip' 'echo -n $zip | base64 -d | ./dog -l' $'Zip archive data, at least v1.0 to extract\n  Length      Date    Time    Name\n---------  ---------- -----   ----\n        0  2015-03-15 20:03   empty\n---------                     -------\n        0                     1 file'
test 'list otherwise' 'echo -n $otherwise | base64 -d | ./dog -l' $'gzip compressed data, was "empty", from Unix, last modified: Sun Mar 15 20:03:23 2015\n000000 1f 8b 08 08 fb 66 05 55 00 03 65 6d 70 74 79 00  >.....f.U..empty.<\n000010 03 00 00 00 00 00 00 00 00 00                    >..........<\n00001a'
