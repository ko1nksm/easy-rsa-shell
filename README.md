# easy-rsa-shell

Easy and secure shell for manage a PKI CA using EasyRSA

**Project status:** Public Beta

## How it works

Build a docker image at first run. It contains EasyRSA3, zuluCrypt and other tools.
You will login to docker container after build. The encrypted data file will be
mounted at home directory (/root). The home directory is prepared for EasyRSA.
You can work freely under /root. All files under the directory are encrypted.

## Supported OS

* Linux
* Windows (Currently WSL only)
* macOS

Requirements: docker

## Login

```console
$ easy-rsa-shell DATAFILE
```

**Demo**

```console
$ ./easy-rsa-shell datafile
Building easy-rsa-shell docker image. Wait for seconds...
Create encrypted volume
Enter passphrase:
Re enter passphrase:
Wait a few seconds...
SUCCESS: luks volume opened successfully
volume mounted at: /run/media/private/root/data
The encrypted volume was merged the '/root' directory using by unionfs

======================================================================
|| easy_rsa shell                                                   ||
======================================================================
The files under the /root directory are encrypted.
The directories /root and /tmp are writable, others are read-only.

Commands:
  help    See this message.
  cheat   See cheat sheet.
  exit    Exit with commit changes.
  abort   Exit with discard changes.

root@ca:~# ls -al
total 29
drwx------ 1 root root 1024 Jan 11 05:48 .
drwxr-xr-x 1 root root 4096 Jan 11 08:08 ..
-rw-r--r-- 1 root root  570 Jan 31  2010 .bashrc
-rw-r--r-- 1 root root  148 Aug 17  2015 .profile
lrwxrwxrwx 1 root root   27 Jan 11 04:40 easyrsa -> /usr/share/easy-rsa/easyrsa
-rw-r--r-- 1 root root 4652 Jan 11 04:40 openssl-easyrsa.cnf
-rw-r--r-- 1 root root 8576 Jan 11 04:40 vars
lrwxrwxrwx 1 root root   30 Jan 11 04:40 x509-types -> /usr/share/easy-rsa/x509-types
root@ca:~#
```

## How to securely transfer certificate and key files

### 1. SSH / SCP

You can use ssh and scp inside of easy-rsa-shell.

### 2. OpenSSL S/MIME

You can export S/MIME encripted file.

#### Create certificate

* The recipient creates the certificate.
* You can skip if already have certificate.

Create self-signed certificate from id_rsa

```console
$ openssl req -new -key id_rsa > id_rsa.csr
$ openssl x509 -days 3650 -req -signkey id_rsa < id_rsa.csr > id_rsa.crt
```

#### Export

```console
$ easy-rsa-shell.sh DATAFILE smime NAME < id_rsa.crt
$ easy-rsa-shell DATAFILE export NAME -f tgz -e openssl:smime > NAME.tgz.encrypted
```

#### Decode

```console
$ openssl smime -decrypt -in NAME.tgz.encrypted -inkey id_rsa -o NAME.tgz
```

### 3. OpenSSL Secret key encryption

#### Export

```console
$ easy-rsa-shell.sh DATAFILE password NAME
$ easy-rsa-shell DATAFILE export NAME -f tgz -e openssl:password -m -aes-256-cbc > NAME.tgz.encrypted
```

#### Decode

```console
$ openssl enc -d -aes-256-cbc -in NAME.tgz.encrypted -o NAME.tgz
```

### 4. Password protected ZIP

#### Export

```console
$ easy-rsa-shell.sh DATAFILE password NAME
$ easy-rsa-shell DATAFILE export NAME -f zip -e password -r > NAME.zip
```

## Customize easy-rsa-shell

Create `docker/root/.onbuild` if you want to customize easy-rsa-shell (e.g. install other package).
The `.onbuild` script is invoked at building docker image stage.

And also you can place various files freely in the `docker/root/` directory.
