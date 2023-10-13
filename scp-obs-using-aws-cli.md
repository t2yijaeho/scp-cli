# Samsung Cloud Platform (SCP) Object Storage using the AWS CLI

## 1. Install AWS CLI

You can follow the instructions provided in the **[AWS CLI User Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)** to install or update the latest version

## 2. Configure AWS CLI

***Refer to AWS CLI User Guide: [Configuration and credential file settings](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)***

### Set SCP Object Storage credential to AWS CLI configuration settings as profile named ***`scp`***

>***Replace `<obsAccessKey>`, `<obsSecretKey>`***

```sh
aws configure set aws_access_key_id <obsAccessKey> --profile scp
aws configure set aws_secret_access_key <obsSecretKey> --profile scp
```

```sh
ubuntu@SCP:~$ aws configure list --profile scp
      Name                    Value             Type    Location
      ----                    -----             ----    --------
   profile                      scp           manual    --profile
access_key     ****************xxxx shared-credentials-file
secret_key     ****************xxxx shared-credentials-file
    region                <not set>             None    None
```

## 3. Specify API URL as AWS Command Line Options

To list the buckets, specify the API URL using the following command

>***Replace `<obsRestEndpoint>`***

```sh
aws s3 ls --endpoint-url <obsRestEndpoint> --profile scp
```

```sh
ubuntu@SCP:~$ aws s3 ls --endpoint-url https://xxxxxx:xxxx --profile scp
2023-05-05 12:34:56 bucket-scp
2023-05-08 18:27:36 bucket-sds
```

### Set Default Profile as Environment Variable (Optional)

To use the ***`scp`*** named profile for multiple commands without specifying it each time, you can set the AWS_PROFILE environment variable as the default profile

```sh
export AWS_PROFILE=scp
```

### Create Alias Function to Shell Profile (Optional)

You can add the following code to your shell profile to include the ***`--endpoint-url`*** option automatically when running AWS S3 commands

>***Replace `<obsRestEndpoint>`***

```sh
aws() {
    if [ "$1" == "s3" ] || [ "$1" == "s3api" ] || [ "$1" == "s3control" ]; then
        command aws --endpoint-url <obsRestEndpoint> "$@"
    else
        command aws "$@"
    fi
}
```
