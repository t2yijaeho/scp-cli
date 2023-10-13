# Samsung Cloud Platform (SCP) Object Storage using the MinIO CLI

Samsung Cloud Platform (SCP) Object Storage is a robust, scalable, and secure service that allows you to store and manage vast amounts of data. With the MinIO CLI, you can easily manage your SCP Object Storage right from your command line, providing you with powerful control over your data

## 1. Install the MinIO CLI

### Download, Change permission, move to local binary directory

Start by downloading the MinIO CLI, changing its permissions, and moving it to your local binary directory. This will allow you to use the MinIO CLI commands from anywhere on your system

```sh
wget https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x ./mc
sudo mv ./mc /usr/local/bin/mc
```

```sh
ubuntu@scp:~$ wget https://dl.min.io/client/mc/release/linux-amd64/mc
--2023-10-13 10:36:22--  https://dl.min.io/client/mc/release/linux-amd64/mc
Resolving dl.min.io (dl.min.io)... 178.128.69.202, 138.68.11.125
Connecting to dl.min.io (dl.min.io)|178.128.69.202|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 26357760 (25M) [application/octet-stream]
Saving to: ‘mc’

mc                                100%[===========================================================>]  25.14M  10.7MB/s    in 2.4s

2023-10-13 10:36:25 (10.7 MB/s) - ‘mc’ saved [26357760/26357760]

ubuntu@scp:~$ chmod +x ./mc
ubuntu@scp:~$ sudo mv ./mc /usr/local/bin/mc
ubuntu@scp:~$ mc --version
mc version RELEASE.2023-10-04T06-52-56Z (commit-id=eca8310ac822cf0e533c6bd3fb85c8d6099d1465)
Runtime: go1.21.1 linux/amd64
Copyright (c) 2015-2023 MinIO, Inc.
License GNU AGPLv3 <https://www.gnu.org/licenses/agpl-3.0.html>
ubuntu@scp:~$
```

## 2. Configure MinIO CLI

### Create an alias to config Endpoint URL, Access key ID, Secret Access Key

Next, create an alias to configure the Endpoint URL, Access Key ID, and Secret Access Key. This will allow the MinIO CLI to interact with your SCP Object Storage

>***Replace `<obsAccessKey>`, `<obsSecretKey>`, and `<obsRestEndpoint>` with your credentials and endpoint URL***

```sh
export AWS_ACCESS_KEY_ID="<obsAccessKey>"
export AWS_SECRET_ACCESS_KEY="<obsSecretKey>"
export S3_ENDPOINT_URL="<obsRestEndpoint>"
```

```sh
mc alias set scp $S3_ENDPOINT_URL $AWS_ACCESS_KEY_ID $AWS_SECRET_ACCESS_KEY
```

```sh
ubuntu@scp:~$ mc alias set scp $S3_ENDPOINT_URL $AWS_ACCESS_KEY_ID $AWS_SECRET_ACCESS_KEY
mc: Configuration written to `/home/ubuntu/.mc/config.json`. Please update your access credentials.
mc: Successfully created `/home/ubuntu/.mc/share`.
mc: Initialized share uploads `/home/ubuntu/.mc/share/uploads.json` file.
mc: Initialized share downloads `/home/ubuntu/.mc/share/downloads.json` file.
Added `scp` successfully.
ubuntu@scp:~$
```

### .mc/config.json

```json
{
        "version": "10",
        "aliases": {
                "local": {
                        "url": "http://localhost:9000",
                        "accessKey": "",
                        "secretKey": "",
                        "api": "S3v4",
                        "path": "auto"
                },
                "scp": {
                        "url": "https://objxx.kr-xxx-xx.samsungsdscloud.com:xxxx",
                        "accessKey": "xxxxxxxxxxxxxx",
                        "secretKey": "xxxxxxxxxxxxxxxxxx",
                        "api": "s3v4",
                        "path": "auto"
                }
        }
}
```

### List an alias

```sh
ubuntu@scp:~$ mc alias list scp
scp
  URL       : https://objxx.kr-xxx-xx.samsungsdscloud.com:xxxx
  AccessKey : xxxxxxxxxxxxxx
  SecretKey : xxxxxxxxxxxxxxxxxx
  API       : s3v4
  Path      : auto
ubuntu@scp:~$
```

## 3. MinIO CLI Commands

Finally, use the MinIO CLI commands to create a bucket, list buckets, copy objects, and delete objects. These commands give you full control over your SCP Object Storage

[MinIO CLI Command Quick Reference](https://min.io/docs/minio/linux/reference/minio-mc.html#command-quick-reference)

### Create a Bucket and List Bucket

```sh
mc mb scp/bk-minio
mc ls scp
```

```sh
ubuntu@scp:~$ mc mb scp/bk-minio
Bucket created successfully `scp/bk-minio`.
ubuntu@scp:~$ mc ls scp
[2023-07-17 09:46:59 KST]     0B bk-scp/
[2023-10-03 12:34:56 KST]     0B bk-minio/
ubuntu@scp:~$
```

### Copy, List, and Remove Objects

```sh
mc ls
mc cp --recursive ./* scp/bk-minio/
mc ls scp/bk-minio/
```

```sh
ubuntu@scp:~/minio$ mc ls
[2023-10-03 13:18:03 KST]     0B first.md
[2023-10-03 13:18:10 KST]     0B second.md
[2023-10-03 13:18:15 KST]     0B third.md
ubuntu@scp:~/minio$ mc cp --recursive ./* scp/bk-minio/
 0 B / ? ━┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉━━
ubuntu@scp:~/minio$ mc ls scp/bk-minio/
[2023-10-03 13:22:28 KST]     0B STANDARD first.md
[2023-10-03 13:22:28 KST]     0B STANDARD second.md
[2023-10-03 13:22:28 KST]     0B STANDARD third.md
```

```sh
mc rm *
mc cp --recursive scp/bk-minio/ .
mc rm scp/bk-minio/third.md
```

```sh
ubuntu@scp:~/minio$ mc rm *
Removed `first.md`.
Removed `second.md`.
Removed `third.md`.
ubuntu@scp:~/minio$ mc ls
ubuntu@scp:~/minio$ mc cp --recursive scp/bk-minio/ .
 0 B / ? ━┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉━━
ubuntu@scp:~/minio$ mc ls
[2023-10-03 13:28:13 KST]     0B first.md
[2023-10-03 13:28:13 KST]     0B second.md
[2023-10-03 13:28:13 KST]     0B third.md
ubuntu@scp:~/minio$ mc rm scp/bk-minio/third.md
Removed `scp/bk-minio/third.md`.
ubuntu@scp:~/minio$ mc ls scp/bk-minio/
[2023-10-03 13:22:28 KST]     0B STANDARD first.md
[2023-10-03 13:22:28 KST]     0B STANDARD second.md
ubuntu@scp:~/minio$
```

### Standard Input to Object

```sh
echo "Third Text" | mc pipe scp/bk-minio/third.txt
```

```sh
mc head scp/bk-minio/third.txt
```

```sh
ubuntu@scp:~/minio$ echo "Third Text" | mc pipe scp/bk-minio/third.txt
 0 B / ? ━┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉━━ubuntu@scp:~/minio$ mc ls scp/bk-minio/
[2023-10-03 13:22:28 KST]     0B STANDARD first.md
[2023-10-03 13:22:28 KST]     0B STANDARD second.md
[2023-10-13 13:58:28 KST]    11B STANDARD third.txt
ubuntu@scp:~/minio$ mc head scp/bk-minio/third.txt
Third Text
ubuntu@scp:~/minio$
```

### Remove Bucket

```sh
mc rm --recursive --force scp/bk-minio/
mc rb --force scp/bk-minio/
```

```sh
ubuntu@scp:~/minio$ mc rm --recursive --force scp/bk-minio/
Removed `scp/bk-minio/first.md`.
Removed `scp/bk-minio/second.md`.
Removed `scp/bk-minio/third.txt`.
ubuntu@scp:~/minio$ mc rb --force scp/bk-minio
Removed `scp/bk-minio` successfully.
ubuntu@scp:~/minio$ mc ls scp
[2023-07-17 09:46:59 KST]     0B bk-scp/
ubuntu@scp:~/minio$
```
