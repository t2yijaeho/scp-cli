# Samsung Cloud Platform (SCP) Command Line Interface (CLI)

## 1. Prerequisites

Before using the SCP Command Line Interface (CLI), ensure that the following dependencies are installed

- Java Runtime Environment (JRE) for running CLI Java programs from the command line
- Unzip utility for extracting the CLI installation file
- JSON processor for querying CLI output

To install these dependencies, execute the following command

```sh
sudo apt update && sudo apt install openjdk-17-jre-headless unzip jq -y
```

## 2. Download and Installation

Download the CLI installation file

```sh
wget https://github.com/t2yijaeho/scp-cli/raw/matia/releases/scp-tool-cli-2.0.0.zip
```

Extract the downloaded file to the ***`/usr/local`*** directory

```sh
unzip scp-tool-cli-2.0.0.zip && sudo mv scp-tool-cli-2.0.0 /usr/local/
```

```sh
ubuntu@SCP:~$ unzip scp-tool-cli-2.0.0.zip && sudo mv scp-tool-cli-2.0.0 /usr/local/
Archive:  scp-tool-cli-2.0.0.zip
   creating: scp-tool-cli-2.0.0/
   creating: scp-tool-cli-2.0.0/lib/
  inflating: scp-tool-cli-2.0.0/lib/scp-tool-cli-2.0.0.jar
   creating: scp-tool-cli-2.0.0/bin/
  inflating: scp-tool-cli-2.0.0/bin/scp-tool-cli
  inflating: scp-tool-cli-2.0.0/bin/scp-tool-cli.bat
   creating: scp-tool-cli-2.0.0/license/
  inflating: scp-tool-cli-2.0.0/license/scp-tool-cli-LICENSE.txt
```

Create a symbolic link named ***`scloud`*** in the ***`/usr/local/bin`*** directory that points to the scp-tool-cli binary in the ***`/usr/local/scp-tool-cli-2.0.0/bin`*** directory

```sh
sudo ln -s /usr/local/scp-tool-cli-2.0.0/bin/scp-tool-cli /usr/local/bin/scloud
```

## 3. Usage

To use the CLI command, consult the help and [CLI guide](https://cloud.samsungsds.com/openapiguide/#/docs/v2-en-overview-overview) in the SCP console

```sh
scloud --help
```

## 4. Configuration

Configure CLI authenticating information
>***Replace `<Project ID>`, `<Access Key>`, `<Secret key>`***

```sh
scloud configure set cmp-url https://openapi.samsungsdscloud.com
scloud configure set host https://openapi.samsungsdscloud.com
scloud configure set current-profile default
scloud configure set project-id <Project ID>
scloud configure set access-key <Access Key>
scloud configure set access-secret <Secret Key>
```

Use the following command to list the configured information

```sh
scloud configure list
```

```sh
ubuntu@SCP:~$ scloud configure list
[default]
cmp-url=https://openapi.samsungsdscloud.com
host=https://openapi.samsungsdscloud.com
project-id=xxxxxxxxxxxxxxxxxxxx
current-profile=default
access-secret=xxxxxxxxxxxx
access-key=xxxxxxxxxxxxx
```

To verify the configuration of the CLI, you can use the following command to list the access keys

```sh
scloud iam list-access-keys-v3
```

```json
ubuntu@SCP:~$ scloud iam list-access-keys-v3 | jq
{
  "totalCount": 1,
  "contents": [
    {
      "accessKey": "xxxxx",
      "accessKeyActivated": true,
      "accessKeyId": "ACCESSKEY-xxxxx",
      "accessKeyState": "ACTIVATED",
      "createdBy": "xxxxx",
      "createdByEmail": "scp.support@samsung.com",
      "createdByName": "SCP Support",
      "createdDt": "2024-03-11T23:25:07.383Z",
      "expiredDt": "2024-04-13T23:25:07.384Z",
      "modifiedBy": "xxxxx",
      "modifiedByEmail": "scp.support@samsung.com",
      "modifiedByName": "SCP Support",
      "modifiedDt": "2024-03-11T23:25:07.383Z",
      "projectId": "",
      "projectName": null,
      "secretVaultCount": 0
    }
  ],
  "page": 0,
  "size": 20,
  "sort": [
    "blockedState",
    "createdDt:desc"
  ]
}
```

## 5. SCP Object Storage using S3 API

SCP Object Storage provides a simple and scalable cloud storage service that is compatible with the S3 APIs. You can use any of the S3 compatible tools to manage your SCP Object Storage buckets and objects.

### Obtain API information

To obtain the necessary API information. Please refer to the SCP User Guide section on **[Utilizing the API](https://cloud.samsungsds.com/manual/en/scp_user_guide.html#utilizing_object_storage_api)** for detailed instructions.

List object storage bucket Name and bucket ID in comma seperated format

```sh
scloud object-storage list-bucket-v2 | jq -r '.contents[] | [.obsBucketName, .obsBucketId] | @csv'
```

```sh
ubuntu@SCP:~$ scloud object-storage list-bucket-v2 | jq -r '.contents[] | [.obsBucketName, .obsBucketId] | @csv'
"bucket-scp","S3_OBS_BUCKET-xxxxx"
"bucket-sds","S3_OBS_BUCKET-xxxxx"
```

Retrieve the desired bucket's API URL and credentials(SCP Object Storage Access Key and Secret Key)

>***Replace `<obsBucketId>`***

```sh
scloud object-storage read-api-info-v2 --obs-bucket-id <obsBucketId> | jq '.obsRestEndpoint, .obsAccessKey, .obsSecretKey'
```

```sh
ubuntu@SCP:~$ scloud object-storage read-api-info-v2 --obs-bucket-id S3_OBS_BUCKET-xxxxx | jq '.obsRestEndpoint, .obsAccessKey, .obsSecretKey'
"https://objxx.kr-xxx-xx.samsungsdscloud.com:xxxx"
"xxxxxxxxxxxxxx"
"xxxxxxxxxxxxxxxxxx"
```

### - ***[SCP Object Storage using the AWS CLI](scp-obs-using-aws-cli.md)***

### - ***[SCP Object Storage using the MinIO CLI](scp-obs-using-minio-cli.md)***

### - ***[SCP Object Storage using the s5cmd](scp-obs-using-s5cmd.md)***
