# Performance Evaluation of Samsung Cloud Platform (SCP) Object Storage Using s5cmd

## Purpose

This document aims to:

- Assess the performance, efficiency, and reliability of SCP object storage with `s5cmd` under a variety of conditions.
- Verify that s5cmd can manage large data transfers effectively, maintain high performance under diverse network conditions, and deliver reliable and consistent results.

## Setting Up the Test Environment

- **Hardware**: A Linux server equipped with 4 vCPU cores, 64 GiB RAM, and 300 GiB storage.
- **Software**: The latest stable version(`v2.2.2-48f7e59`) of s5cmd, installed on a Linux operating system (`Ubuntu 22.04.3 LTS`). All necessary dependencies for s5cmd are installed.
- **Network**: A stable internet connection with a minimum bandwidth of 100 Mbps.

## 1. **Variable Size Data Transfers**

### 1.1 **Prepare files**

Three files of varying sizes are created with random data using the following commands:

```sh
dd if=/dev/urandom of=file1g bs=1M count=1024
dd if=/dev/urandom of=file10g bs=1M count=10240
dd if=/dev/urandom of=file100g bs=1M count=102400
```

These commands generate files of 1 GiB, 10 GiB, and 100 GiB respectively in the current directory.

```sh
ubuntu@scp:~/s5cmd$ dd if=/dev/urandom of=file1g bs=1M count=1024
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 3.17677 s, 338 MB/s
ubuntu@scp:~/s5cmd$ dd if=/dev/urandom of=file10g bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB, 10 GiB) copied, 31.8136 s, 338 MB/s
ubuntu@scp:~/s5cmd$ dd if=/dev/urandom of=rfile100g bs=1M count=102400
102400+0 records in
102400+0 records out
107374182400 bytes (107 GB, 100 GiB) copied, 324.346 s, 338 MB/s
ubuntu@scp:~/s5cmd$ ls -lh
total 112G
-rw-rw-r-- 1 ubuntu ubuntu 100G Nov  9 17:31 file100g
-rw-rw-r-- 1 ubuntu ubuntu  10G Nov  9 17:30 file10g
-rw-rw-r-- 1 ubuntu ubuntu 1.0G Nov  9 17:30 file1g
```

### 1.2 **Time Measurement**

The `time` command is used in conjunction with the `s5cmd cp` command to measure the time taken to copy each file to the S3 bucket named `s5cmd`. The command syntax is as follows:

```sh
/usr/bin/time -f "Time: %es" s5cmd  --numworkers xx cp --concurrency xx file<xx>g s3://s5cmd/
```

Transfer the file, denoted as `file<xx>g`, to your S3 bucket named `s5cmd` and record the duration of the operation.

```sh
ubuntu@scp:~/s5cmd$ /usr/bin/time -f "Time: %es" s5cmd  --numworkers 10 cp --concurrency 10 file1g s3://s5cmd/
cp file1g s3://s5cmd/file1g
Time: 10.14s
```

```sh
ubuntu@scp:~/s5cmd$ /usr/bin/time -f "Time: %es" s5cmd  --numworkers 50 cp --concurrency 50 file10g s3://s5cmd/file/
cp file10g s3://s5cmd/file/file10g
Time: 54.63s
```

```sh
ubuntu@scp:~/s5cmd$ /usr/bin/time -f "Time: %es" s5cmd  --numworkers 50 cp --concurrency 50 file100g s3://s5cmd/file/
cp file100g s3://s5cmd/file/file100g
Time: 488.63s
```

### 1.3 **Monitor the data transfer**

#### Install monitoring tool

The `dstat` application is installed for monitoring the data transfer. The installation command is:

```sh
sudo apt install -y dstat
```

#### Monitor the transfer

The following command is used to monitor the data transfer and generate a report every second:

```sh
dstat --time --all --color | tee "dstat$(date +%Y%m%d%H%M%S).ans"
```

This command generates a real-time report that includes various system statistics such as total CPU usage, disk activity, network activity, paging, and system interrupts. Here's an example of the output:

```sh
----system---- --total-cpu-usage-- -dsk/total- -net/total- ---paging-- ---system--
     time     |usr sys idl wai stl| read  writ| recv  send|  in   out | int   csw
12-25 10:01:17|  0   0 100   0   0|  83k 7376B|   0     0 |   0     0 | 334   543
12-25 10:01:18|  0   0 100   0   0|   0     0 |  60B  882B|   0     0 | 514   849
12-25 10:01:19| 51  11  33   6   0| 257M    0 |1817k   21M|   0     0 |  16k   11k
12-25 10:01:20| 37  11  45   6   0| 153M    0 |3335k  373M|   0     0 |  36k   11k
12-25 10:01:21| 34   8  47  11   0| 196M   32k|1453k  205M|   0     0 |  16k   10k
12-25 10:01:22| 42   9  31  17   0| 245M    0 |1579k  253M|   0     0 |  21k   14k
12-25 10:01:23| 36   8  41  15   0| 206M 4096B|1168k  211M|   0     0 |  18k   11k
12-25 10:01:24| 38   7  38  17   0| 217M    0 |1150k  220M|   0     0 |  19k   12k
12-25 10:01:25| 42   8  36  15   0| 235M    0 |1326k  236M|   0     0 |  21k   15k
12-25 10:01:26| 36   9  42  13   0| 220M   60k|1192k  218M|   0     0 |  19k   13k
12-25 10:01:27| 38   8  40  14   0| 228M    0 |1229k  234M|   0     0 |  19k   12k
12-25 10:01:28| 38   9  40  14   0| 226M    0 |1194k  226M|   0     0 |  18k   10k
12-25 10:01:29| 38   7  42  12   0| 222M 4096B|1211k  226M|   0     0 |  19k   12k
12-25 10:01:30| 19   3  72   6   0|  95M    0 | 701k  105M|   0     0 |  12k 7440
12-25 10:01:31|  1   1  99   0   0|   0    20k|  65k 1252k|   0     0 |3190  3768
12-25 10:01:32|  0   0 100   0   0|   0     0 | 120B 1064B|   0     0 | 223   327
12-25 10:01:33|  0   0 100   0   0|   0     0 |  60B  354B|   0     0 | 194   314
```

In this output:

- `usr` refers to the percentage of CPU utilization that occurred while executing at the user level (application).
- `sys` is the percentage of CPU utilization that occurred while executing at the system level (kernel).
- `idl` is the percentage of time that the CPU or CPUs were idle and the system did not have an outstanding disk I/O request.
- `wai` is the percentage of time that the CPU or CPUs were idle during which the system had an outstanding disk I/O request.
- `stl` is the percentage of time spent in involuntary wait by the virtual CPU or CPUs while the hypervisor was servicing another virtual processor.
- `read` and `writ` refer to the amount of data read from and written to the disk, respectively.
- `recv` and `send` refer to the amount of data received and sent over the network, respectively.
- `in` and `out` refer to the number of packets received (input) and transmitted (output) per second.
- `int` is the number of interrupts per second.
- `csw` is the number of context switches per second.

#### Monitoring s5cmd process

The `watch` command is used to monitor the s5cmd process in real-time. The command used is as follows:

```sh
watch -n 0.1 ps -C s5cmd -L
```

This command refreshes every 0.1 seconds and displays the status of the s5cmd process. The output includes the process ID (PID), lightweight process ID (LWP), terminal type (TTY), CPU time consumed by the process (TIME), and the command executed (CMD). Here's an example of the output:

```sh
Every 0.1s: ps -C s5cmd -L                         scp: Sun Nov 12 20:09:12 2023

    PID     LWP TTY          TIME CMD
 215127  215127 pts/6    00:00:00 s5cmd
 215127  215128 pts/6    00:00:00 s5cmd
 215127  215129 pts/6    00:00:03 s5cmd
 215127  215130 pts/6    00:00:00 s5cmd
 215127  215131 pts/6    00:00:00 s5cmd
 215127  215132 pts/6    00:00:00 s5cmd
 215127  215133 pts/6    00:00:03 s5cmd
 215127  215134 pts/6    00:00:00 s5cmd
 215127  215135 pts/6    00:00:00 s5cmd
 215127  215139 pts/6    00:00:00 s5cmd
 215127  215140 pts/6    00:00:03 s5cmd
 215127  215141 pts/6    00:00:03 s5cmd
 215127  215142 pts/6    00:00:00 s5cmd
 215127  215143 pts/6    00:00:03 s5cmd
 215127  215144 pts/6    00:00:00 s5cmd
```

## 2. **Concurrent Operations**

### 2.1 **File Preparation**

[make-files.sh](/scripts/make-files.sh)

A script is used to generate multiple files for testing concurrent operations. This script will create 2,500 files, each of 1 MB size, in the current directory. The script, named `make-files.sh`, is executed as follows:

```sh
bash make-files.sh 2500 1
```

Upon execution, the script generates the files and provides a progress update as shown below:

```sh
ubuntu@scp:~/scp$ bash makefiles.sh 2500 1
.....................................................................................................................
...
.........................................
All files have been generated.
```

After the script completes, the `s5cmd du -H .` command is used to confirm the total size of the generated files:

```sh
s5cmd du -H .
```

This output indicates that 2,500 files, totaling 2.4 GB, have been successfully created in the current directory.

```sh
ubuntu@scp:~/scp$ s5cmd du -H .
2.4G bytes in 2500 objects: .
```

### 2.2 **Time Measurement**

The `time` command is used in conjunction with the `s5cmd cp` command to measure the time taken to copy the test files to the S3 bucket named `s5cmd`. The command syntax is as follows:

```sh
/usr/bin/time -f "Time: %es" s5cmd cp 'file*' s3://s5cmd/files/
```

Upon execution, the command copies the test files to the S3 bucket and displays the time taken to complete the operation. Here's an example of the output:

```sh
ubuntu@scp:~/s5cmd$ /usr/bin/time -f "Time: %es" s5cmd cp 'file*' s3://s5cmd/files/
cp file0001 s3://s5cmd/files/file0001
cp file0003 s3://s5cmd/files/file0003
cp file0005 s3://s5cmd/files/file0005
...
cp file2449 s3://s5cmd/files/file2449
cp file2482 s3://s5cmd/files/file2482
cp file2490 s3://s5cmd/files/file2490
Time: 11.30s
ubuntu@scp:~/s5cmd$ s5cmd du -H s3://s5cmd/files/
2.4G bytes in 2500 objects: s3://s5cmd/files/
```

In this example, the operation took `11.30 seconds` to complete, and the total size of the files in the S3 bucket is confirmed to be `2.4 GiB`.

### 2.3 **Monitor the data transfer**

The `dstat` command is used to monitor the data transfer in real-time. The command used is as follows:

```sh
dstat --time --all --color | tee "dstat$(date +%Y%m%d%H%M%S).ans"
```

This command generates a report every second, providing various system metrics such as total CPU usage, disk activity, network activity, paging, and system interrupts. Here's an example of the output:

```sh
12-25 16:51:18|  1   1  98   0   0|   0     0 |1228B  944B|   0     0 | 950  1252
12-25 16:51:19|  2   3  95   0   0|7216k    0 |7959B   86k|   0     0 |2508  3505
12-25 16:51:20| 58  13  24   5   0| 251M    0 |3358k  189M|   0     0 |  32k   11k
12-25 16:51:21| 36  10  44   9   0| 206M    0 |2190k  279M|   0     0 |  21k 8947
12-25 16:51:22| 46  10  31  12   0| 241M   16k|1922k  244M|   0     0 |  16k 9568
12-25 16:51:23| 32   9  50   9   0| 187M    0 |1094k  199M|   0     0 |  15k 9370
12-25 16:51:24| 42  10  33  15   0| 254M 8192B|1456k  249M|   0     0 |  18k 9509
12-25 16:51:25| 41  10  36  13   0| 231M    0 |1547k  244M|   0     0 |  18k   11k
12-25 16:51:26| 32   8  50  11   0| 193M    0 | 963k  193M|   0     0 |  15k 9108
12-25 16:51:27| 36   9  43  12   0| 234M   32k|1250k  232M|   0     0 |  19k   10k
12-25 16:51:28| 34   8  44  14   0| 212M    0 |1165k  220M|   0     0 |  16k 9431
12-25 16:51:29| 34   8  47  11   0| 209M    0 |1015k  211M|   0     0 |  16k   10k
12-25 16:51:30| 37   8  42  13   0| 225M    0 |1167k  227M|   0     0 |  17k 9928
12-25 16:51:31| 10   4  84   2   0|  50M    0 | 449k   53M|   0     0 |9140  8630
12-25 16:51:32|  1   2  97   0   0|   0    16k|  24k   23k|   0     0 |1939  1919
12-25 16:51:33|  1   2  98   0   0|   0    16k| 180B  566B|   0     0 | 708   652
12-25 16:51:34|  1   2  97   0   0|   0    16k| 362B 1914B|   0     0 | 683   639
```

In the provided output, you can see that the CPU usage (usr and sys), disk activity (read), and network activity (send) increase significantly during the file transfer operation. This is expected as the system is reading the files from the disk, processing them, and then sending them over the network. After the operation is completed, the CPU usage, disk activity, and network activity return to their normal levels.

This detailed view can help identify potential bottlenecks or issues in the system. For example, if the wai (I/O wait time) is consistently high, it might indicate that the disk is a bottleneck. Similarly, if the recv and send values are lower than the network’s capacity, it might indicate a network issue. By monitoring these values, you can gain insights into the system’s performance and make necessary adjustments to optimize the file transfer operation.
