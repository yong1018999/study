# trivy扫描images漏洞

**采用trivy工具**

首先用yum安装trivy工具

```bash
yum -y install trivy
```

确认安装成功

```bash
trivy --version
```

查看当前机器image

```bash
docker images
```

```
# docker images
REPOSITORY                              TAG                 IMAGE ID            CREATED             SIZE
docker.io/busybox                       latest              beae173ccac6        2 weeks ago         1.24 MB
docker.io/nginx                         1.21.4              f6987c8d6ed5        3 weeks ago         141 MB
docker.io/amazonlinux                   2.0.20211201.0      f9d4a99f2542        6 weeks ago         164 MB
docker.io/nginx                         1.21.4-alpine       b46db85084b8        2 months ago        23.2 MB
docker.io/fluxcd/kustomize-controller   v0.16.0             4de40d8fc715        3 months ago        106 MB
k8s.gcr.io/descheduler/descheduler      v0.22.1             8591902620c1        3 months ago        61 MB
```

选择几个images查看，比如busbox

```bash
trivy image busybox:latest
```

显示结果为以下，表示无漏洞

```
2022-01-17T11:36:19.787Z	INFO	Number of language-specific files: 0
```

再选择nginx

```bash
trivy image nginx:1.21.4
```

显示结果如下

```bash
nginx:1.21.4 (debian 11.2)
==========================
Total: 117 (UNKNOWN: 5, LOW: 83, MEDIUM: 9, HIGH: 13, CRITICAL: 7)

+------------------+------------------+----------+--------------------+---------------+-----------------------------------------+
|     LIBRARY      | VULNERABILITY ID | SEVERITY | INSTALLED VERSION  | FIXED VERSION |                  TITLE                  |
+------------------+------------------+----------+--------------------+---------------+-----------------------------------------+
| apt              | CVE-2011-3374    | LOW      | 2.2.4              |               | It was found that apt-key in apt,       |
|                  |                  |          |                    |               | all versions, do not correctly...       |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2011-3374    |
+------------------+------------------+          +--------------------+---------------+-----------------------------------------+
| coreutils        | CVE-2016-2781    |          | 8.32-4             |               | coreutils: Non-privileged               |
|                  |                  |          |                    |               | session can escape to the               |
|                  |                  |          |                    |               | parent session in chroot                |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2016-2781    |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2017-18018   |          |                    |               | coreutils: race condition               |
|                  |                  |          |                    |               | vulnerability in chown and chgrp        |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2017-18018   |
+------------------+------------------+----------+--------------------+---------------+-----------------------------------------+
| curl             | CVE-2021-22945   | CRITICAL | 7.74.0-1.3+deb11u1 |               | curl: use-after-free and                |
|                  |                  |          |                    |               | double-free in MQTT sending             |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-22945   |
+                  +------------------+----------+                    +---------------+-----------------------------------------+
|                  | CVE-2021-22946   | HIGH     |                    |               | curl: Requirement to use                |
|                  |                  |          |                    |               | TLS not properly enforced               |
|                  |                  |          |                    |               | for IMAP, POP3, and...                  |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-22946   |
+                  +------------------+----------+                    +---------------+-----------------------------------------+
|                  | CVE-2021-22947   | MEDIUM   |                    |               | curl: Server responses                  |
|                  |                  |          |                    |               | received before STARTTLS                |
|                  |                  |          |                    |               | processed after TLS handshake           |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-22947   |
+                  +------------------+----------+                    +---------------+-----------------------------------------+
|                  | CVE-2021-22898   | LOW      |                    |               | curl: TELNET stack                      |
|                  |                  |          |                    |               | contents disclosure                     |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-22898   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2021-22922   |          |                    |               | curl: Content not matching hash         |
|                  |                  |          |                    |               | in Metalink is not being discarded      |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-22922   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2021-22923   |          |                    |               | curl: Metalink download                 |
|                  |                  |          |                    |               | sends credentials                       |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-22923   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2021-22924   |          |                    |               | curl: Bad connection reuse              |
|                  |                  |          |                    |               | due to flawed path name checks          |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-22924   |
+------------------+------------------+          +--------------------+---------------+-----------------------------------------+
| libapt-pkg6.0    | CVE-2011-3374    |          | 2.2.4              |               | It was found that apt-key in apt,       |
|                  |                  |          |                    |               | all versions, do not correctly...       |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2011-3374    |
+------------------+------------------+----------+--------------------+---------------+-----------------------------------------+
| libc-bin         | CVE-2021-33574   | CRITICAL | 2.31-13+deb11u2    |               | glibc: mq_notify does                   |
|                  |                  |          |                    |               | not handle separately                   |
|                  |                  |          |                    |               | allocated thread attributes             |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-33574   |
+                  +------------------+----------+                    +---------------+-----------------------------------------+
|                  | CVE-2021-3999    | HIGH     |                    |               | glibc: Off-by-one buffer                |
|                  |                  |          |                    |               | overflow/underflow in getcwd()          |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-3999    |
+                  +------------------+----------+                    +---------------+-----------------------------------------+
|                  | CVE-2021-3998    | MEDIUM   |                    |               | glibc: Unexpected return                |
|                  |                  |          |                    |               | value from realpath() could             |
|                  |                  |          |                    |               | leak data based on the...               |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-3998    |
+                  +------------------+----------+                    +---------------+-----------------------------------------+
|                  | CVE-2010-4756    | LOW      |                    |               | glibc: glob implementation              |
|                  |                  |          |                    |               | can cause excessive CPU and             |
|                  |                  |          |                    |               | memory consumption due to...            |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2010-4756    |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2018-20796   |          |                    |               | glibc: uncontrolled recursion in        |
|                  |                  |          |                    |               | function check_dst_limits_calc_pos_1    |
|                  |                  |          |                    |               | in posix/regexec.c                      |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2018-20796   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2019-1010022 |          |                    |               | glibc: stack guard protection bypass    |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2019-1010022 |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2019-1010023 |          |                    |               | glibc: running ldd on malicious ELF     |
|                  |                  |          |                    |               | leads to code execution because of...   |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2019-1010023 |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2019-1010024 |          |                    |               | glibc: ASLR bypass using                |
|                  |                  |          |                    |               | cache of thread stack and heap          |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2019-1010024 |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2019-1010025 |          |                    |               | glibc: information disclosure of heap   |
|                  |                  |          |                    |               | addresses of pthread_created thread     |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2019-1010025 |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2019-9192    |          |                    |               | glibc: uncontrolled recursion in        |
|                  |                  |          |                    |               | function check_dst_limits_calc_pos_1    |
|                  |                  |          |                    |               | in posix/regexec.c                      |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2019-9192    |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2021-43396   |          |                    |               | glibc: conversion from                  |
|                  |                  |          |                    |               | ISO-2022-JP-3 with iconv may            |
|                  |                  |          |                    |               | emit spurious NUL character on...       |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-43396   |
+                  +------------------+----------+                    +---------------+-----------------------------------------+
|                  | CVE-2022-23218   | UNKNOWN  |                    |               | The deprecated compatibility            |
|                  |                  |          |                    |               | function svcunix_create in the          |
|                  |                  |          |                    |               | sunrpc module of the GNU...             |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2022-23218   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2022-23219   |          |                    |               | The deprecated compatibility            |
|                  |                  |          |                    |               | function clnt_create in the             |
|                  |                  |          |                    |               | sunrpc module of the GNU...             |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2022-23219   |
+------------------+------------------+----------+                    +---------------+-----------------------------------------+
| libc6            | CVE-2021-33574   | CRITICAL |                    |               | glibc: mq_notify does                   |
|                  |                  |          |                    |               | not handle separately                   |
|                  |                  |          |                    |               | allocated thread attributes             |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-33574   |
+                  +------------------+----------+                    +---------------+-----------------------------------------+
|                  | CVE-2021-3999    | HIGH     |                    |               | glibc: Off-by-one buffer                |
|                  |                  |          |                    |               | overflow/underflow in getcwd()          |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-3999    |
+                  +------------------+----------+                    +---------------+-----------------------------------------+
|                  | CVE-2021-3998    | MEDIUM   |                    |               | glibc: Unexpected return                |
|                  |                  |          |                    |               | value from realpath() could             |
|                  |                  |          |                    |               | leak data based on the...               |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-3998    |
+                  +------------------+----------+                    +---------------+-----------------------------------------+
|                  | CVE-2010-4756    | LOW      |                    |               | glibc: glob implementation              |
|                  |                  |          |                    |               | can cause excessive CPU and             |
|                  |                  |          |                    |               | memory consumption due to...            |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2010-4756    |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2018-20796   |          |                    |               | glibc: uncontrolled recursion in        |
|                  |                  |          |                    |               | function check_dst_limits_calc_pos_1    |
|                  |                  |          |                    |               | in posix/regexec.c                      |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2018-20796   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2019-1010022 |          |                    |               | glibc: stack guard protection bypass    |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2019-1010022 |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2019-1010023 |          |                    |               | glibc: running ldd on malicious ELF     |
|                  |                  |          |                    |               | leads to code execution because of...   |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2019-1010023 |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2019-1010024 |          |                    |               | glibc: ASLR bypass using                |
|                  |                  |          |                    |               | cache of thread stack and heap          |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2019-1010024 |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2019-1010025 |          |                    |               | glibc: information disclosure of heap   |
|                  |                  |          |                    |               | addresses of pthread_created thread     |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2019-1010025 |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2019-9192    |          |                    |               | glibc: uncontrolled recursion in        |
|                  |                  |          |                    |               | function check_dst_limits_calc_pos_1    |
|                  |                  |          |                    |               | in posix/regexec.c                      |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2019-9192    |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2021-43396   |          |                    |               | glibc: conversion from                  |
|                  |                  |          |                    |               | ISO-2022-JP-3 with iconv may            |
|                  |                  |          |                    |               | emit spurious NUL character on...       |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-43396   |
+                  +------------------+----------+                    +---------------+-----------------------------------------+
|                  | CVE-2022-23218   | UNKNOWN  |                    |               | The deprecated compatibility            |
|                  |                  |          |                    |               | function svcunix_create in the          |
|                  |                  |          |                    |               | sunrpc module of the GNU...             |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2022-23218   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2022-23219   |          |                    |               | The deprecated compatibility            |
|                  |                  |          |                    |               | function clnt_create in the             |
|                  |                  |          |                    |               | sunrpc module of the GNU...             |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2022-23219   |
+------------------+------------------+----------+--------------------+---------------+-----------------------------------------+
| libcurl4         | CVE-2021-22945   | CRITICAL | 7.74.0-1.3+deb11u1 |               | curl: use-after-free and                |
|                  |                  |          |                    |               | double-free in MQTT sending             |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-22945   |
+                  +------------------+----------+                    +---------------+-----------------------------------------+
|                  | CVE-2021-22946   | HIGH     |                    |               | curl: Requirement to use                |
|                  |                  |          |                    |               | TLS not properly enforced               |
|                  |                  |          |                    |               | for IMAP, POP3, and...                  |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-22946   |
+                  +------------------+----------+                    +---------------+-----------------------------------------+
|                  | CVE-2021-22947   | MEDIUM   |                    |               | curl: Server responses                  |
|                  |                  |          |                    |               | received before STARTTLS                |
|                  |                  |          |                    |               | processed after TLS handshake           |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-22947   |
+                  +------------------+----------+                    +---------------+-----------------------------------------+
|                  | CVE-2021-22898   | LOW      |                    |               | curl: TELNET stack                      |
|                  |                  |          |                    |               | contents disclosure                     |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-22898   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2021-22922   |          |                    |               | curl: Content not matching hash         |
|                  |                  |          |                    |               | in Metalink is not being discarded      |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-22922   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2021-22923   |          |                    |               | curl: Metalink download                 |
|                  |                  |          |                    |               | sends credentials                       |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-22923   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2021-22924   |          |                    |               | curl: Bad connection reuse              |
|                  |                  |          |                    |               | due to flawed path name checks          |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-22924   |
+------------------+------------------+----------+--------------------+---------------+-----------------------------------------+
| libexpat1        | CVE-2022-22822   | CRITICAL | 2.2.10-2           |               | addBinding in xmlparse.c in             |
|                  |                  |          |                    |               | Expat (aka libexpat) before             |
|                  |                  |          |                    |               | 2.4.3 has an integer...                 |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2022-22822   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2022-22823   |          |                    |               | build_model in xmlparse.c in            |
|                  |                  |          |                    |               | Expat (aka libexpat) before             |
|                  |                  |          |                    |               | 2.4.3 has an integer...                 |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2022-22823   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2022-22824   |          |                    |               | defineAttribute in xmlparse.c           |
|                  |                  |          |                    |               | in Expat (aka libexpat)                 |
|                  |                  |          |                    |               | before 2.4.3 has an integer...          |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2022-22824   |
+                  +------------------+----------+                    +---------------+-----------------------------------------+
|                  | CVE-2021-45960   | HIGH     |                    |               | In Expat (aka libexpat) before          |
|                  |                  |          |                    |               | 2.4.3, a left shift by 29 (or...        |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-45960   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2021-46143   |          |                    |               | In doProlog in xmlparse.c               |
|                  |                  |          |                    |               | in Expat (aka libexpat)                 |
|                  |                  |          |                    |               | before 2.4.3, an integer...             |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-46143   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2022-22825   |          |                    |               | lookup in xmlparse.c in                 |
|                  |                  |          |                    |               | Expat (aka libexpat) before             |
|                  |                  |          |                    |               | 2.4.3 has an integer...                 |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2022-22825   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2022-22826   |          |                    |               | nextScaffoldPart in xmlparse.c          |
|                  |                  |          |                    |               | in Expat (aka libexpat)                 |
|                  |                  |          |                    |               | before 2.4.3 has an integer...          |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2022-22826   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2022-22827   |          |                    |               | storeAtts in xmlparse.c in              |
|                  |                  |          |                    |               | Expat (aka libexpat) before             |
|                  |                  |          |                    |               | 2.4.3 has an integer...                 |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2022-22827   |
+                  +------------------+----------+                    +---------------+-----------------------------------------+
|                  | CVE-2013-0340    | LOW      |                    |               | expat: internal entity expansion        |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2013-0340    |
+------------------+------------------+----------+--------------------+---------------+-----------------------------------------+
| libgcrypt20      | CVE-2021-33560   | HIGH     | 1.8.7-6            |               | libgcrypt: mishandles ElGamal           |
|                  |                  |          |                    |               | encryption because it lacks             |
|                  |                  |          |                    |               | exponent blinding to address a...       |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-33560   |
+                  +------------------+----------+                    +---------------+-----------------------------------------+
|                  | CVE-2018-6829    | LOW      |                    |               | libgcrypt: ElGamal implementation       |
|                  |                  |          |                    |               | doesn't have semantic security due      |
|                  |                  |          |                    |               | to incorrectly encoded plaintexts...    |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2018-6829    |
+------------------+------------------+----------+--------------------+---------------+-----------------------------------------+
| libgd3           | CVE-2021-40145   | HIGH     | 2.3.0-2            |               | ** DISPUTED ** gdImageGd2Ptr            |
|                  |                  |          |                    |               | in gd_gd2.c in the GD                   |
|                  |                  |          |                    |               | Graphics Library (aka...                |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-40145   |
+                  +------------------+----------+                    +---------------+-----------------------------------------+
|                  | CVE-2021-38115   | MEDIUM   |                    |               | read_header_tga in gd_tga.c             |
|                  |                  |          |                    |               | in the GD Graphics Library              |
|                  |                  |          |                    |               | (aka LibGD) through 2.3.2...            |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-38115   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2021-40812   |          |                    |               | The GD Graphics Library (aka            |
|                  |                  |          |                    |               | LibGD) through 2.3.2 has                |
|                  |                  |          |                    |               | an out-of-bounds read...                |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-40812   |
+------------------+------------------+----------+--------------------+---------------+-----------------------------------------+
| libgnutls30      | CVE-2011-3389    | LOW      | 3.7.1-5            |               | HTTPS: block-wise chosen-plaintext      |
|                  |                  |          |                    |               | attack against SSL/TLS (BEAST)          |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2011-3389    |
+------------------+------------------+          +--------------------+---------------+-----------------------------------------+
| libgssapi-krb5-2 | CVE-2004-0971    |          | 1.18.3-6+deb11u1   |               | security flaw                           |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2004-0971    |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2018-5709    |          |                    |               | krb5: integer overflow                  |
|                  |                  |          |                    |               | in dbentry->n_key_data                  |
|                  |                  |          |                    |               | in kadmin/dbutil/dump.c                 |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2018-5709    |
+------------------+------------------+          +--------------------+---------------+-----------------------------------------+
| libjbig0         | CVE-2017-9937    |          | 2.1-3.1            |               | libtiff: memory malloc failure          |
|                  |                  |          |                    |               | in tif_jbig.c could cause DOS.          |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2017-9937    |
+------------------+------------------+          +--------------------+---------------+-----------------------------------------+
| libk5crypto3     | CVE-2004-0971    |          | 1.18.3-6+deb11u1   |               | security flaw                           |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2004-0971    |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2018-5709    |          |                    |               | krb5: integer overflow                  |
|                  |                  |          |                    |               | in dbentry->n_key_data                  |
|                  |                  |          |                    |               | in kadmin/dbutil/dump.c                 |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2018-5709    |
+------------------+------------------+          +                    +---------------+-----------------------------------------+
| libkrb5-3        | CVE-2004-0971    |          |                    |               | security flaw                           |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2004-0971    |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2018-5709    |          |                    |               | krb5: integer overflow                  |
|                  |                  |          |                    |               | in dbentry->n_key_data                  |
|                  |                  |          |                    |               | in kadmin/dbutil/dump.c                 |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2018-5709    |
+------------------+------------------+          +                    +---------------+-----------------------------------------+
| libkrb5support0  | CVE-2004-0971    |          |                    |               | security flaw                           |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2004-0971    |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2018-5709    |          |                    |               | krb5: integer overflow                  |
|                  |                  |          |                    |               | in dbentry->n_key_data                  |
|                  |                  |          |                    |               | in kadmin/dbutil/dump.c                 |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2018-5709    |
+------------------+------------------+          +--------------------+---------------+-----------------------------------------+
| libldap-2.4-2    | CVE-2015-3276    |          | 2.4.57+dfsg-3      |               | openldap: incorrect multi-keyword       |
|                  |                  |          |                    |               | mode cipherstring parsing               |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2015-3276    |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2017-14159   |          |                    |               | openldap: Privilege escalation          |
|                  |                  |          |                    |               | via PID file manipulation               |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2017-14159   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2017-17740   |          |                    |               | openldap:                               |
|                  |                  |          |                    |               | contrib/slapd-modules/nops/nops.c       |
|                  |                  |          |                    |               | attempts to free stack buffer           |
|                  |                  |          |                    |               | allowing remote attackers to cause...   |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2017-17740   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2020-15719   |          |                    |               | openldap: Certificate                   |
|                  |                  |          |                    |               | validation incorrectly                  |
|                  |                  |          |                    |               | matches name against CN-ID              |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2020-15719   |
+------------------+------------------+          +--------------------+---------------+-----------------------------------------+
| libpcre3         | CVE-2017-11164   |          | 2:8.39-13          |               | pcre: OP_KETRMAX feature in the         |
|                  |                  |          |                    |               | match function in pcre_exec.c           |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2017-11164   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2017-16231   |          |                    |               | pcre: self-recursive call               |
|                  |                  |          |                    |               | in match() in pcre_exec.c               |
|                  |                  |          |                    |               | leads to denial of service...           |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2017-16231   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2017-7245    |          |                    |               | pcre: stack-based buffer overflow       |
|                  |                  |          |                    |               | write in pcre32_copy_substring          |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2017-7245    |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2017-7246    |          |                    |               | pcre: stack-based buffer overflow       |
|                  |                  |          |                    |               | write in pcre32_copy_substring          |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2017-7246    |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2019-20838   |          |                    |               | pcre: Buffer over-read in JIT           |
|                  |                  |          |                    |               | when UTF is disabled and \X or...       |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2019-20838   |
+------------------+------------------+          +--------------------+---------------+-----------------------------------------+
| libpng16-16      | CVE-2019-6129    |          | 1.6.37-3           |               | libpng: memory leak of                  |
|                  |                  |          |                    |               | png_info struct in pngcp.c              |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2019-6129    |
+------------------+------------------+          +--------------------+---------------+-----------------------------------------+
| libsepol1        | CVE-2021-36084   |          | 3.1-1              |               | libsepol: use-after-free in             |
|                  |                  |          |                    |               | __cil_verify_classperms()               |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-36084   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2021-36085   |          |                    |               | libsepol: use-after-free in             |
|                  |                  |          |                    |               | __cil_verify_classperms()               |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-36085   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2021-36086   |          |                    |               | libsepol: use-after-free in             |
|                  |                  |          |                    |               | cil_reset_classpermission()             |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-36086   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2021-36087   |          |                    |               | libsepol: heap-based buffer             |
|                  |                  |          |                    |               | overflow in ebitmap_match_any()         |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-36087   |
+------------------+------------------+          +--------------------+---------------+-----------------------------------------+
| libssl1.1        | CVE-2007-6755    |          | 1.1.1k-1+deb11u1   |               | Dual_EC_DRBG: weak pseudo               |
|                  |                  |          |                    |               | random number generator                 |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2007-6755    |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2010-0928    |          |                    |               | openssl: RSA authentication weakness    |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2010-0928    |
+------------------+------------------+----------+--------------------+---------------+-----------------------------------------+
| libsystemd0      | CVE-2021-3997    | MEDIUM   | 247.3-6            |               | systemd: Uncontrolled recursion in      |
|                  |                  |          |                    |               | systemd-tmpfiles when removing files    |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-3997    |
+                  +------------------+----------+                    +---------------+-----------------------------------------+
|                  | CVE-2013-4392    | LOW      |                    |               | systemd: TOCTOU race condition          |
|                  |                  |          |                    |               | when updating file permissions          |
|                  |                  |          |                    |               | and SELinux security contexts...        |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2013-4392    |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2020-13529   |          |                    |               | systemd: DHCP FORCERENEW                |
|                  |                  |          |                    |               | authentication not implemented          |
|                  |                  |          |                    |               | can cause a system running the...       |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2020-13529   |
+------------------+------------------+          +--------------------+---------------+-----------------------------------------+
| libtiff5         | CVE-2014-8130    |          | 4.2.0-1            |               | libtiff: divide by zero                 |
|                  |                  |          |                    |               | in the tiffdither tool                  |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2014-8130    |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2017-16232   |          |                    |               | libtiff: Memory leaks in                |
|                  |                  |          |                    |               | tif_open.c, tif_lzw.c, and tif_aux.c    |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2017-16232   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2017-17973   |          |                    |               | libtiff: heap-based use after           |
|                  |                  |          |                    |               | free in tiff2pdf.c:t2p_writeproc        |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2017-17973   |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2017-5563    |          |                    |               | libtiff: Heap-buffer overflow           |
|                  |                  |          |                    |               | in LZWEncode tif_lzw.c                  |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2017-5563    |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2017-9117    |          |                    |               | libtiff: Heap-based buffer              |
|                  |                  |          |                    |               | over-read in bmp2tiff                   |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2017-9117    |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2018-10126   |          |                    |               | libtiff: NULL pointer dereference       |
|                  |                  |          |                    |               | in the jpeg_fdct_16x16                  |
|                  |                  |          |                    |               | function in jfdctint.c                  |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2018-10126   |
+                  +------------------+----------+                    +---------------+-----------------------------------------+
|                  | CVE-2022-22844   | UNKNOWN  |                    |               | LibTIFF 4.3.0 has an out-of-bounds      |
|                  |                  |          |                    |               | read in _TIFFmemcpy in                  |
|                  |                  |          |                    |               | tif_unix.c in certain...                |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2022-22844   |
+------------------+------------------+----------+--------------------+---------------+-----------------------------------------+
| libtinfo6        | CVE-2021-39537   | LOW      | 6.2+20201114-2     |               | ncurses: heap-based buffer overflow     |
|                  |                  |          |                    |               | in _nc_captoinfo() in captoinfo.c       |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-39537   |
+------------------+------------------+----------+--------------------+---------------+-----------------------------------------+
| libudev1         | CVE-2021-3997    | MEDIUM   | 247.3-6            |               | systemd: Uncontrolled recursion in      |
|                  |                  |          |                    |               | systemd-tmpfiles when removing files    |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-3997    |
+                  +------------------+----------+                    +---------------+-----------------------------------------+
|                  | CVE-2013-4392    | LOW      |                    |               | systemd: TOCTOU race condition          |
|                  |                  |          |                    |               | when updating file permissions          |
|                  |                  |          |                    |               | and SELinux security contexts...        |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2013-4392    |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2020-13529   |          |                    |               | systemd: DHCP FORCERENEW                |
|                  |                  |          |                    |               | authentication not implemented          |
|                  |                  |          |                    |               | can cause a system running the...       |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2020-13529   |
+------------------+------------------+          +--------------------+---------------+-----------------------------------------+
| libwebp6         | CVE-2016-9085    |          | 0.6.1-2.1          |               | libwebp: Several integer overflows      |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2016-9085    |
+------------------+------------------+          +--------------------+---------------+-----------------------------------------+
| libxslt1.1       | CVE-2015-9019    |          | 1.1.34-4           |               | libxslt: math.random() in               |
|                  |                  |          |                    |               | xslt uses unseeded randomness           |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2015-9019    |
+------------------+------------------+          +--------------------+---------------+-----------------------------------------+
| login            | CVE-2007-5686    |          | 1:4.8.1-1          |               | initscripts in rPath Linux 1            |
|                  |                  |          |                    |               | sets insecure permissions for           |
|                  |                  |          |                    |               | the /var/log/btmp file,...              |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2007-5686    |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2013-4235    |          |                    |               | shadow-utils: TOCTOU race               |
|                  |                  |          |                    |               | conditions by copying and               |
|                  |                  |          |                    |               | removing directory trees                |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2013-4235    |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2019-19882   |          |                    |               | shadow-utils: local users can           |
|                  |                  |          |                    |               | obtain root access because setuid       |
|                  |                  |          |                    |               | programs are misconfigured...           |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2019-19882   |
+------------------+------------------+          +--------------------+---------------+-----------------------------------------+
| ncurses-base     | CVE-2021-39537   |          | 6.2+20201114-2     |               | ncurses: heap-based buffer overflow     |
|                  |                  |          |                    |               | in _nc_captoinfo() in captoinfo.c       |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-39537   |
+------------------+                  +          +                    +---------------+                                         +
| ncurses-bin      |                  |          |                    |               |                                         |
|                  |                  |          |                    |               |                                         |
|                  |                  |          |                    |               |                                         |
+------------------+------------------+----------+--------------------+---------------+-----------------------------------------+
| nginx            | CVE-2021-3618    | HIGH     | 1.21.4-1~bullseye  |               | ALPACA: Application Layer               |
|                  |                  |          |                    |               | Protocol Confusion - Analyzing          |
|                  |                  |          |                    |               | and Mitigating Cracks in TLS...         |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2021-3618    |
+                  +------------------+----------+                    +---------------+-----------------------------------------+
|                  | CVE-2020-36309   | MEDIUM   |                    |               | ngx_http_lua_module (aka                |
|                  |                  |          |                    |               | lua-nginx-module) before                |
|                  |                  |          |                    |               | 0.10.16 in OpenResty allows             |
|                  |                  |          |                    |               | unsafe characters in an...              |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2020-36309   |
+                  +------------------+----------+                    +---------------+-----------------------------------------+
|                  | CVE-2009-4487    | LOW      |                    |               | nginx: Absent sanitation of             |
|                  |                  |          |                    |               | escape sequences in web server log      |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2009-4487    |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2013-0337    |          |                    |               | The default configuration of nginx,     |
|                  |                  |          |                    |               | possibly 1.3.13 and earlier, uses       |
|                  |                  |          |                    |               | world-readable permissions...           |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2013-0337    |
+------------------+------------------+          +--------------------+---------------+-----------------------------------------+
| openssl          | CVE-2007-6755    |          | 1.1.1k-1+deb11u1   |               | Dual_EC_DRBG: weak pseudo               |
|                  |                  |          |                    |               | random number generator                 |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2007-6755    |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2010-0928    |          |                    |               | openssl: RSA authentication weakness    |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2010-0928    |
+------------------+------------------+          +--------------------+---------------+-----------------------------------------+
| passwd           | CVE-2007-5686    |          | 1:4.8.1-1          |               | initscripts in rPath Linux 1            |
|                  |                  |          |                    |               | sets insecure permissions for           |
|                  |                  |          |                    |               | the /var/log/btmp file,...              |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2007-5686    |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2013-4235    |          |                    |               | shadow-utils: TOCTOU race               |
|                  |                  |          |                    |               | conditions by copying and               |
|                  |                  |          |                    |               | removing directory trees                |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2013-4235    |
+                  +------------------+          +                    +---------------+-----------------------------------------+
|                  | CVE-2019-19882   |          |                    |               | shadow-utils: local users can           |
|                  |                  |          |                    |               | obtain root access because setuid       |
|                  |                  |          |                    |               | programs are misconfigured...           |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2019-19882   |
+------------------+------------------+----------+--------------------+---------------+-----------------------------------------+
| perl-base        | CVE-2020-16156   | HIGH     | 5.32.1-4+deb11u2   |               | perl-CPAN: Bypass of verification       |
|                  |                  |          |                    |               | of signatures in CHECKSUMS files        |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2020-16156   |
+                  +------------------+----------+                    +---------------+-----------------------------------------+
|                  | CVE-2011-4116    | LOW      |                    |               | perl: File::Temp insecure               |
|                  |                  |          |                    |               | temporary file handling                 |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2011-4116    |
+------------------+------------------+          +--------------------+---------------+-----------------------------------------+
| tar              | CVE-2005-2541    |          | 1.34+dfsg-1        |               | tar: does not properly warn the user    |
|                  |                  |          |                    |               | when extracting setuid or setgid...     |
|                  |                  |          |                    |               | -->avd.aquasec.com/nvd/cve-2005-2541    |
+------------------+------------------+----------+--------------------+---------------+-----------------------------------------+
```

查看高危以及危急的漏洞

```bash
trivy image nginx:1.21.4 | egrep "HIGH|CRITICAL"  #查找两个关键字以上采用egrep，用|分隔  一个关键字用grep
```

显示结果如下

```
Total: 117 (UNKNOWN: 5, LOW: 83, MEDIUM: 9, HIGH: 13, CRITICAL: 7)
| curl             | CVE-2021-22945   | CRITICAL | 7.74.0-1.3+deb11u1 |               | curl: use-after-free and                |
|                  | CVE-2021-22946   | HIGH     |                    |               | curl: Requirement to use                |
| libc-bin         | CVE-2021-33574   | CRITICAL | 2.31-13+deb11u2    |               | glibc: mq_notify does                   |
|                  | CVE-2021-3999    | HIGH     |                    |               | glibc: Off-by-one buffer                |
| libc6            | CVE-2021-33574   | CRITICAL |                    |               | glibc: mq_notify does                   |
|                  | CVE-2021-3999    | HIGH     |                    |               | glibc: Off-by-one buffer                |
| libcurl4         | CVE-2021-22945   | CRITICAL | 7.74.0-1.3+deb11u1 |               | curl: use-after-free and                |
|                  | CVE-2021-22946   | HIGH     |                    |               | curl: Requirement to use                |
| libexpat1        | CVE-2022-22822   | CRITICAL | 2.2.10-2           |               | addBinding in xmlparse.c in             |
|                  | CVE-2021-45960   | HIGH     |                    |               | In Expat (aka libexpat) before          |
| libgcrypt20      | CVE-2021-33560   | HIGH     | 1.8.7-6            |               | libgcrypt: mishandles ElGamal           |
| libgd3           | CVE-2021-40145   | HIGH     | 2.3.0-2            |               | ** DISPUTED ** gdImageGd2Ptr            |
| nginx            | CVE-2021-3618    | HIGH     | 1.21.4-1~bullseye  |               | ALPACA: Application Layer               |
| perl-base        | CVE-2020-16156   | HIGH     | 5.32.1-4+deb11u2   |               | perl-CPAN: Bypass of verification       |
```

扫描出漏洞结果发开发修改