# batch-python-mongo-poc

 A trivial AWS Batch script that increments a counter in MongoDB using Python. The database files--not JSON or a mongodump--on is synced in  S3 between runs. This is a proof of principle not intended for production use.

# Prerequisites

* Ansible Installed
* AWS Account Details

# Setup vars
Edit ansible vars directory under `batch-python-mongo-poc-role/vars/main.yml` to match your AWS Environment

```
AWS_ACCESS_KEY_ID: XXXX
AWS_SECRET_ACCESS_KEY: XXX
AWS_REGION: eu-west-1
AWS_STORAGE_BUCKET_NAME: batch-mongo-poc

task_name: batch_python_mongo_poc
minv_cpus: 3
maxv_cpus: 3
desiredv_cpus: 3
security_group_ids: default
subnets: "default-subnet-{{ AWS_REGION }}a"
instance_role: "arn:aws:iam::XXX:instance-profile/ecsInstanceRole"
service_role: "arn:aws:iam::XXXX:role/service-role/AWSBatchServiceRole"
job_role: "arn:aws:iam::XXXX:role/ecsTaskExecutionRole"```

# Run

shell
```ansible-playbook playbook.yml```
