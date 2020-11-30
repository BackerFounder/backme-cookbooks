# ALB support

## Setup

1. Create Application Load Balancer & Target group.

2. Create a IAM policy for register / deregister targets.

  ```json
  {
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Action": [
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets"
        ],
        "Resource": [
          "arn:aws:elasticloadbalancing:....."
        ]
      },
      {
        "Effect": "Allow",
        "Action": "elasticloadbalancing:DescribeTargetHealth",
        "Resource": "*"
      }
    ]
  }
  ```

3. Apply the policy to your EC2's role.

4. Append target group arn to cookbook attribute `default[:alb_support][:target_group_arn]`.

## References
- [Use Application Load Balancers with your AWS OpsWorks Chef 12 Stacks - AWS Management & Governance Blog](https://aws.amazon.com/tw/blogs/mt/use-application-load-balancers-with-your-aws-opsworks-chef-12-stacks/)
