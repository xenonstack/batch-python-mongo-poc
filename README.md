# batch-python-mongo-poc

 A trivial AWS Batch script that increments a counter in MongoDB using Python. The database files--not JSON or a mongodump--on is synced in  S3 between runs. This is a proof of principle not intended for production use.

# Prerequisites

* Ansible Installed
* AWS Account Details

# AWS Batch

## Setup vars
Edit ansible vars directory under `batch-python-mongo-poc-role/vars/main.yml` to match your AWS Environment

```
## required for both unamanged and managed
AWS_ACCESS_KEY_ID: XX
AWS_SECRET_ACCESS_KEY: XXX
AWS_REGION: us-east-1
AWS_STORAGE_BUCKET_NAME: batch-mongo-poc
task_name: batch_python_mongo_poc
minv_cpus: 3
maxv_cpus: 5
desiredv_cpus: 3
security_group_ids: default
subnets: "subnet-c4cc799e"
instance_role: "arn:aws:iam::117802438413:instance-profile/ecsInstanceRole"
service_role: "arn:aws:iam::117802438413:role/service-role/AWSBatchServiceRole"
job_role: "arn:aws:iam::117802438413:role/ecsTaskExecutionRole"

## Select unamanged and managed appropiately
compute: unmanaged

compute_environment_name: "{{task_name}}_{{compute}}"

## required for unamanged
subnet_unamanged: subnet-00XXX
ami: ami-0de53d8956e8dcf80
instance_type: t2.medium
keypair: test_guri
volume_size: "10"

```


## Run AWS Batch with Managed Compute

```
$ ansible-playbook aws_batch_managed_compute.yml
```

##  AWS Batch with Unmanaged Compute
```
$ ansible-playbook aws_batch_unmanaged_compute.yml
```

# On Plain EC2

## Setup vars
Edit ansible vars directory under `batch-python-mongo-poc-role/vars/main.yml` to match your AWS Environment

```
docker_image: XXX
vpc_subnet_id: subnet-XXXXXX
region: us-east-1
image: ami-0de53d8956e8dcf80
instance_type: t2.medium
security_group: default
keypair: test_guri
volume_size: "10"
docker_version: "1.83"
```

## Run

```
$ ansible-playbook aws-ec2-compute.yaml -e AWS_ACCESS_KEY_ID=XXXXXXXXXXXX -e AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXX -e aws_region=us-east-1
```

# AWS Batch with Unmanaged Compute
