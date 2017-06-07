# This cookbook enables VPC ClassicLink

Please create proper VPC, security group and if necessary peering connection between VPCs.

## Configuration

Please ensure you have an instance policy like the following setup:

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1495110219469",
      "Action": [
        "ec2:AttachClassicLinkVpc"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
```

Add the following to your OpsWorks Stack custom json:

```
{
  "vpc-classiclink": {
    "classiclink_vpc_id": "YOUR VPC ID",
    "classiclink_security_group_id": "YOUR SECURITY GROUP TO LINK TO"
  }
}
```
