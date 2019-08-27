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

Proper Check has been implemented that if there is error on Docker Run, The instance will terminated even with an error.

## Setup vars
Edit ansible vars directory under `aws-batch-python-mongo-poc-role/vars/main.yml` to match your AWS Environment

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


## Generic Permissions for the roles

This PoC used three roles, for which ARNs were part of the configuration to set this PoC up. In this section, permissions attached to these roles are mentioned. These roles are default execution roles required for the job to run anyway. Bare minimum permissions are given below, feel free to make the permissions more fine grained or adding more permissions according to your use case

### instance_role

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeTags",
                "ecs:CreateCluster",
                "ecs:DeregisterContainerInstance",
                "ecs:DiscoverPollEndpoint",
                "ecs:Poll",
                "ecs:RegisterContainerInstance",
                "ecs:StartTelemetrySession",
                "ecs:UpdateContainerInstancesState",
                "ecs:Submit*",
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
```


### service_role

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceAttribute",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeKeyPairs",
                "ec2:DescribeImages",
                "ec2:DescribeImageAttribute",
                "ec2:DescribeSpotInstanceRequests",
                "ec2:DescribeSpotFleetInstances",
                "ec2:DescribeSpotFleetRequests",
                "ec2:DescribeSpotPriceHistory",
                "ec2:DescribeVpcClassicLink",
                "ec2:DescribeLaunchTemplateVersions",
                "ec2:CreateLaunchTemplate",
                "ec2:DeleteLaunchTemplate",
                "ec2:RequestSpotFleet",
                "ec2:CancelSpotFleetRequests",
                "ec2:ModifySpotFleetRequest",
                "ec2:TerminateInstances",
                "ec2:RunInstances",
                "autoscaling:DescribeAccountLimits",
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:CreateLaunchConfiguration",
                "autoscaling:CreateAutoScalingGroup",
                "autoscaling:UpdateAutoScalingGroup",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:DeleteLaunchConfiguration",
                "autoscaling:DeleteAutoScalingGroup",
                "autoscaling:CreateOrUpdateTags",
                "autoscaling:SuspendProcesses",
                "autoscaling:PutNotificationConfiguration",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ecs:DescribeClusters",
                "ecs:DescribeContainerInstances",
                "ecs:DescribeTaskDefinition",
                "ecs:DescribeTasks",
                "ecs:ListClusters",
                "ecs:ListContainerInstances",
                "ecs:ListTaskDefinitionFamilies",
                "ecs:ListTaskDefinitions",
                "ecs:ListTasks",
                "ecs:CreateCluster",
                "ecs:DeleteCluster",
                "ecs:RegisterTaskDefinition",
                "ecs:DeregisterTaskDefinition",
                "ecs:RunTask",
                "ecs:StartTask",
                "ecs:StopTask",
                "ecs:UpdateContainerAgent",
                "ecs:DeregisterContainerInstance",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogGroups",
                "iam:GetInstanceProfile",
                "iam:GetRole"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": [
                "*"
            ],
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": [
                        "ec2.amazonaws.com",
                        "ecs-tasks.amazonaws.com"
                    ]
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": [
                        "spot.amazonaws.com",
                        "spotfleet.amazonaws.com",
                        "autoscaling.amazonaws.com",
                        "ecs.amazonaws.com"
                    ]
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags"
            ],
            "Resource": [
                "*"
            ],
            "Condition": {
                "StringEquals": {
                    "ec2:CreateAction": "RunInstances"
                }
            }
        }
    ]
}
```


### job_role

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
```
