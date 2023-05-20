# Samsung Cloud Platform (SCP) Object Storage with the AWS CLI

## 1. Prerequisites

Before proceeding with the integration of Samsung Cloud Platform (SCP) Object Storage and the AWS Command Line Interface (CLI), please ensure that you have the AWS CLI installed on your system. If you haven't installed it yet, you can follow the instructions provided in the **[AWS CLI User Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)** to install or update the latest version

## 2. Obtain API information

To obtain the necessary API information. Please refer to the SCP User Guide section on **[Utilizing the API](https://cloud.samsungsds.com/manual/en/scp_user_guide.html#utilizing_object_storage_api)** for detailed instructions.

### List object storage bucket Name and bucket ID in comma seperated format

```Bash
scpc object-storage list-bucket-v2 | jq -r '.contents[] | [.obsBucketName, .obsBucketId] | @csv'
```

```Bash
ubuntu@T3XBC:~$ scpc object-storage list-bucket-v2 | jq -r '.contents[] | [.obsBucketName, .obsBucketId] | @csv'
"bucket-scp","S3_OBS_BUCKET-xxxxx"
"bucket-sds","S3_OBS_BUCKET-xxxxx"
```

### Retrieve the desired bucket's API URL and credentials(SCP Object Storage Access Key and Secret Key)

>***Replace `<obsBucketId>`***

```Bash
scpc object-storage read-api-info-v2 --obs-bucket-id <obsBucketId> | jq '.obsRestEndpoint, .obsAccessKey, .obsSecretKey'
```

```Bash
ubuntu@T3XBC:~$ scpc object-storage read-api-info-v2 --obs-bucket-id S3_OBS_BUCKET-d_B7NSO7r1bRoRj6Ey_Hch | jq '.obsRestEndpoint, .obsAccessKey, .obsSecretKey'
"https://objxx.kr-west-xx.samsungsdscloud.com:xxxx"
"xxxxxxxxxxxxxx"
"xxxxxxxxxxxxxxxxxx"
ubuntu@T3XBC:~$
```

## 3. Configure AWS CLI

***Refer to AWS CLI User Guide: [Configuration and credential file settings](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)***

### Set SCP Object Storage credential to AWS CLI configuration settings as profile named ***`scp`***

>***Replace `<obsAccessKey>`, `<obsSecretKey>`***

```Bash
aws configure set aws_access_key_id <obsAccessKey> --profile scp
aws configure set aws_secret_access_key <obsSecretKey> --profile scp
```

```Bash
ubuntu@T3XBC:~$ aws configure list --profile scp
      Name                    Value             Type    Location
      ----                    -----             ----    --------
   profile                      scp           manual    --profile
access_key     ****************xxxx shared-credentials-file
secret_key     ****************xxxx shared-credentials-file
    region                <not set>             None    None
```

## 4. Specify API URL as AWS Command Line Options

To list the buckets, specify the API URL using the following command

>***Replace `<obsRestEndpoint>`***

```Bash
aws s3 ls --endpoint-url <obsRestEndpoint> --profile scp
```

```Bash
ubuntu@T3XBC:~$ aws s3 ls --endpoint-url https://xxxxxx:xxxx --profile scp
2023-05-05 12:34:56 bucket-scp
2023-05-08 18:27:36 bucket-sds
```

### Set Default Profile as Environment Variable (Optional)

>To use the ***`scp`*** named profile for multiple commands without specifying it each time, you can set the AWS_PROFILE environment variable as the default profile

```Bash
export AWS_PROFILE=scp
```

### Create Alias Function to Shell Profile (Optional)

>You can add the following code to your shell profile to include the ***`--endpoint-url`*** option automatically when running AWS S3 commands

>***Replace `<obsRestEndpoint>`***

```Bash
aws() {
    if [ "$1" == "s3" ]; then
        command aws --endpoint-url <obsRestEndpoint> "$@"
    else
        command aws "$@"
    fi
}
```
