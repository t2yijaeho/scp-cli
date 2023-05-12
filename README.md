# Samsung Cloud Platform (SCP) Command Line Interface (CLI)

## 1. Prerequisites

Install the Java Runtime Environment (JRE) to run CLI Java programs from the command line, the unzip utility to uncompress the CLI installation file

```Bash
sudo apt update && sudo apt install openjdk-8-jre unzip jq -y
```

## 2. Download and Install

Download the CLI installation file and extract it to the `/usr/local` directory

```Bash
wget https://github.com/t2yijaeho/scp-cli/raw/matia/scp-tool-cli-1.0.9.zip
```

```Bash
unzip scp-tool-cli-1.0.9.zip && sudo mv scp-tool-cli-1.0.9 /usr/local/
```

```Bash
ubuntu@UBUNTU:~$ unzip scp-tool-cli-1.0.9.zip && sudo mv scp-tool-cli-1.0.9 /usr/local/
Archive:  scp-tool-cli-1.0.9.zip
   creating: scp-tool-cli-1.0.9/
   creating: scp-tool-cli-1.0.9/lib/
  inflating: scp-tool-cli-1.0.9/lib/scp-tool-cli-1.0.9.jar
   creating: scp-tool-cli-1.0.9/bin/
  inflating: scp-tool-cli-1.0.9/bin/scp-tool-cli
  inflating: scp-tool-cli-1.0.9/bin/scp-tool-cli.bat
   creating: scp-tool-cli-1.0.9/license/
  inflating: scp-tool-cli-1.0.9/license/scp-tool-cli 오픈소스고지문.txt
```

Create a symbolic link named `scpc` in the `/usr/local/bin` directory that points to the scp-tool-cli binary in the `/usr/local/scp-tool-cli-1.0.9/bin` directory

```Bash
sudo ln -s /usr/local/scp-tool-cli-1.0.9/bin/scp-tool-cli /usr/local/bin/scpc
```

## 3. Usage

To use the CLI command, consult the help and [CLI guide](https://cloud.samsungsds.com/openapiguide/#/docs/v2-en-overview-overview) in the SCP console.

```Bash
scpc --help
```

## 4. Configure

Configure CLI authenticating information
>***Replace `<Project ID>, <Access Key>, <Secret key>`***

```Bash
scpc configure set cmp-url https://openapi.samsungsdscloud.com
scpc configure set current-profile default
scpc configure set project-id <Project ID>
scpc configure set access-key <Access Key>
scpc configure set access-secret <Secret key>
```

List the configuration

```Bash
scpc configure list
```

```Bash
ubuntu@UBUNTU:~$ scpc configure list
[default]
cmp-url=https://openapi.samsungsdscloud.com
project-id=xxxxxxxxxxxxxxxxxxxx
current-profile=default
access-secret=xxxxxxxxxxxx
access-key=xxxxxxxxxxxxx
```