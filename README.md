# Samsung Cloud Platform (SCP) Command Line Interface (CLI)

## 1. Prerequisites

Before using the SCP Command Line Interface (CLI), ensure that the following dependencies are installed

- Java Runtime Environment (JRE) for running CLI Java programs from the command line
- Unzip utility for extracting the CLI installation file
- JSON processor for querying CLI output

To install these dependencies, execute the following command

```Bash
sudo apt update && sudo apt install openjdk-8-jre unzip jq -y
```

## 2. Download and Installation

Download the CLI installation file

```Bash
wget https://github.com/t2yijaeho/scp-cli/raw/matia/scp-tool-cli-1.0.10.zip
```

Extract the downloaded file to the ***`/usr/local`*** directory

```Bash
unzip scp-tool-cli-1.0.10.zip && sudo mv scp-tool-cli-1.0.10 /usr/local/
```

```Bash
ubuntu@SCP:~$ unzip scp-tool-cli-1.0.10.zip && sudo mv scp-tool-cli-1.0.10 /usr/local/
Archive:  scp-tool-cli-1.0.10.zip
   creating: scp-tool-cli-1.0.10/
   creating: scp-tool-cli-1.0.10/lib/
  inflating: scp-tool-cli-1.0.10/lib/scp-tool-cli-1.0.10.jar
   creating: scp-tool-cli-1.0.10/bin/
  inflating: scp-tool-cli-1.0.10/bin/scp-tool-cli
  inflating: scp-tool-cli-1.0.10/bin/scp-tool-cli.bat
   creating: scp-tool-cli-1.0.10/license/
  inflating: scp-tool-cli-1.0.10/license/scp-tool-cli 오픈소스고지문.txt
```

Create a symbolic link named ***`scpc`*** in the ***`/usr/local/bin`*** directory that points to the scp-tool-cli binary in the ***`/usr/local/scp-tool-cli-1.0.10/bin`*** directory

```Bash
sudo ln -s /usr/local/scp-tool-cli-1.0.10/bin/scp-tool-cli /usr/local/bin/scpc
```

## 3. Usage

To use the CLI command, consult the help and [CLI guide](https://cloud.samsungsds.com/openapiguide/#/docs/v2-en-overview-overview) in the SCP console

```Bash
scpc --help
```

## 4. Configuration

Configure CLI authenticating information
>***Replace `<Project ID>`, `<Access Key>`, `<Secret key>`***

```Bash
scpc configure set cmp-url https://openapi.samsungsdscloud.com
scpc configure set current-profile default
scpc configure set project-id <Project ID>
scpc configure set access-key <Access Key>
scpc configure set access-secret <Secret Key>
```

Use the following command to list the configured information

```Bash
scpc configure list
```

```Bash
ubuntu@SCP:~$ scpc configure list
[default]
cmp-url=https://openapi.samsungsdscloud.com
project-id=xxxxxxxxxxxxxxxxxxxx
current-profile=default
access-secret=xxxxxxxxxxxx
access-key=xxxxxxxxxxxxx
```

To verify the configuration of the CLI, you can use the following command to list the access keys

```Bash
scpc iam list-access-keys-v2
```

```Bash
ubuntu@SCP:~$ scpc iam list-access-keys-v2 | jq
{
  "totalCount": 1,
  "contents": [
    {
      "accessKey": "accesskey",
      "accessKeyActivated": true,
      "accessKeyId": "accesskeyid",
      "createdBy": "xxxxx",
      "createdByEmail": "scp.support@samsung.com",
      "**createdByName**": "SCP Support",
      "createdDt": "2023-12-25T06:13:55.462Z",
      "expiredDt": null,
      "modifiedBy": "xxxxx",
      "modifiedByEmail": "scp.support@samsung.com",
      "modifiedByName": "SCP Support",
      "modifiedDt": "2023-12-25T06:13:55.462Z",
      "projectId": "",
      "projectName": null
    }
  ],
  "page": 0,
  "size": 20,
  "sort": null
}
```

## 5. Using AWS CLI for SCP Object Storage

***SCP Object Storage provide AWS S3 compatible APIs***

- ***[SCP Object Storage with the AWS CLI](SCP-obs-with-aws-cli.md)***