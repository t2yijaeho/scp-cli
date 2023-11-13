# Samsung Cloud Platform (SCP) Object Storage using the s5cmd

***`s5cmd`*** is a fast S3 and local filesystem execution tool supporting for a multitude of operations including tab completion and wildcard support for files, which can be very handy for Samsung Cloud Platform object storage workflow while working with large number of files

[s5cmd](https://github.com/peak/s5cmd)

## 1. Install the s5cmd

[s5cmd Release](https://github.com/peak/s5cmd/releases)

Start by downloading the s5cmd, moving it to your local binary directory. This will allow you to use the s5cmd commands from anywhere on your system

### Download the CLI installation file

```sh
wget -q --show-progress https://github.com/peak/s5cmd/releases/download/v2.2.2/s5cmd_2.2.2_Linux-64bit.tar.gz
```

```sh
ubuntu@scp:~$ wget -q --show-progress https://github.com/peak/s5cmd/releases/download/v2.2.2/s5cmd_2.2.2_Linux-64bit.tar.gz
s5cmd_2.2.2_Linux-64bit.tar.gz    100%[==========================================================>]   4.60M  4.12MB/s    in 1.1s
```

### Extract the downloaded file and move to the /usr/local directory

```sh
mkdir s5cmd
tar xvfz s5cmd_2.2.2_Linux-64bit.tar.gz -C ./s5cmd
sudo mv s5cmd /usr/local/
```

```sh
ubuntu@scp:~$ mkdir s5cmd
ubuntu@scp:~$ tar xvfz s5cmd_2.2.2_Linux-64bit.tar.gz -C ./s5cmd
CHANGELOG.md
LICENSE
README.md
s5cmd
ubuntu@scp:~$ ll ./s5cmd
total 15252
drwxrwxr-x  2 ubuntu ubuntu     4096 Nov  8 17:28 ./
drwxr-x--- 10 ubuntu ubuntu     4096 Nov  8 17:28 ../
-rw-r--r--  1 ubuntu ubuntu    22374 Sep 16 01:34 CHANGELOG.md
-rw-r--r--  1 ubuntu ubuntu     1061 Sep 16 01:34 LICENSE
-rw-r--r--  1 ubuntu ubuntu    30434 Sep 16 01:34 README.md
-rwxr-xr-x  1 ubuntu ubuntu 15548416 Sep 16 01:36 s5cmd*
ubuntu@scp:~$ sudo mv s5cmd /usr/local/
ubuntu@scp:~$
```

### Create a symbolic link

Create a symbolic link in the `/usr/local/bin` directory that points to the s5cmd binary in the `/usr/local/s5cmd/` directory

```sh
sudo ln -s /usr/local/s5cmd/s5cmd /usr/local/bin/s5cmd
s5cmd version
```

```sh
ubuntu@scp:~$ sudo ln -s /usr/local/s5cmd/s5cmd /usr/local/bin/s5cmd
ubuntu@scp:~$ s5cmd version
v2.2.2-48f7e59
ubuntu@scp:~$
```

## 2. Configure the s5cmd

### Export environmental variables

Next, export environmental variables to configure the `Access Key ID`, `Secret Access Key` and `Endpoint URL`. This will allow the `s5cmd` to interact with your SCP Object Storage

>***Replace `<obsAccessKey>`, `<obsSecretKey>`, and `<obsRestEndpoint>` with your credentials and endpoint URL***

```sh
export AWS_ACCESS_KEY_ID="<obsAccessKey>"
export AWS_SECRET_ACCESS_KEY="<obsSecretKey>"
export S3_ENDPOINT_URL="<obsRestEndpoint>"
```

```sh
ubuntu@scp:~$ export AWS_ACCESS_KEY_ID="xxxxx"
ubuntu@scp:~$ export AWS_SECRET_ACCESS_KEY="xxxxx"
ubuntu@scp:~$ export S3_ENDPOINT_URL="https://obj1.kr-xxxx-x.samsungsdscloud.com:xxxx"
ubuntu@scp:~$
```

### Create a Bucket and List Bucket

```sh
s5cmd mb s3://s5cmd
s5cmd ls
```

```sh
ubuntu@scp:~$ s5cmd mb s3://s5cmd
mb s3://s5cmd
ubuntu@scp:~$ s5cmd ls
2023/12/25 12:34:56  s3://s5cmd
ubuntu@scp:~$
```

## 3. [Configuring Concurrency](https://github.com/peak/s5cmd/blob/master/README.md#configuring-concurrency)

### numworkers

> `numworkers` is a global option that sets the size of the global worker pool. Default value is `256`

`--numworkers` is set to 10, then `s5cmd` will limit the number of files concurrently uploaded to 10

```sh
s5cmd --numworkers 10 cp '/Users/foo/bar/*' s3://mybucket/foo/bar/
```

### concurrency

>`concurrency` is a `cp` command option. It sets the number of parts that will be uploaded or downloaded in parallel for a single file. Default value of `concurrency` is `5`.

`numworkers` and `concurrency` options can be used together:

```sh
s5cmd --numworkers 10 cp --concurrency 10 '/Users/foo/bar/*' s3://mybucket/foo/bar/
```

>If you have a few, large files to download, setting `--numworkers` to a very high value will not affect download speed. In this scenario setting `--concurrency` to a higher value may have a better impact on the download speed.
