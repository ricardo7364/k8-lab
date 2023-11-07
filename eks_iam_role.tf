# EKS CLUSTER ROLE
resource "aws_iam_role" "EKSClusterRole" {
  name               = "EKSClusterRole-${var.global_random_var}"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

//This policy provides Kubernetes the permissions it requires to manage resources on your behalf. Kubernetes requires Ec2:CreateTags permissions to place identifying information on EC2 resources including but not limited to Instances, Security Groups, and Elastic Network Interfaces
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.EKSClusterRole.name
}

# NODE GROUP ROLE
resource "aws_iam_role" "NodeGroupRole" {
  name               = "EKSNodeGroupRole-${var.global_random_var}"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

//This policy allows Amazon EKS worker nodes to connect to Amazon EKS Clusters.
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.NodeGroupRole.name
}

// Provides read-only access to Amazon EC2 Container Registry repositories.
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.NodeGroupRole.name
}

// This policy provides the Amazon VPC CNI Plugin (amazon-vpc-cni-k8s) the permissions it requires to modify the IP address configuration on your EKS worker nodes. This permission set allows the CNI to list, describe, and modify Elastic Network Interfaces on your behalf
resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.NodeGroupRole.name
}

resource "aws_iam_role_policy_attachment" "APP_DNA_Policy" {
  policy_arn = aws_iam_policy.s3_ap_policy.arn
  role       = aws_iam_role.NodeGroupRole.name
}

resource "aws_iam_policy" "s3_ap_policy" {
  name   = "s3_ap_policy_${var.global_random_var}"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:PassRole",
          "sagemaker:CreateNotebookInstance",
          "sagemaker:CreateProcessingJob",
          "sagemaker:CreateTrainingJob",
          "ec2:*",
          "elasticloadbalancing:*",
          "cloudwatch:*",
          "autoscaling:*",
          "iam:CreateServiceLinkedRole",
          "s3:GetObject",
          "s3:GetObjectVersionTagging",
          "s3:GetStorageLensConfigurationTagging",
          "s3:GetObjectAcl",
          "s3:GetBucketObjectLockConfiguration",
          "s3:GetIntelligentTieringConfiguration",
          "s3:DeleteAccessPointPolicyForObjectLambda",
          "s3:DeleteJobTagging",
          "s3:GetObjectVersionAcl",
          "s3:PutBucketAcl",
          "s3:PutObjectTagging",
          "s3:DeleteObjectTagging",
          "s3:PutAccessPointPolicyForObjectLambda",
          "s3:GetBucketPolicyStatus",
          "s3:GetObjectRetention",
          "s3:GetBucketWebsite",
          "s3:PutMultiRegionAccessPointPolicy",
          "s3:GetJobTagging",
          "s3:DeleteStorageLensConfigurationTagging",
          "s3:GetMultiRegionAccessPoint",
          "s3:GetObjectAttributes",
          "s3:DeleteObjectVersionTagging",
          "s3:GetObjectLegalHold",
          "s3:GetBucketNotification",
          "s3:DeleteBucketPolicy",
          "s3:DescribeMultiRegionAccessPointOperation",
          "s3:GetReplicationConfiguration",
          "s3:ListMultipartUploadParts",
          "s3:GetObject",
          "s3:DescribeJob",
          "s3:PutObjectVersionAcl",
          "s3:GetAnalyticsConfiguration",
          "s3:GetObjectVersionForReplication",
          "s3:PutAccessPointPolicy",
          "s3:GetAccessPointForObjectLambda",
          "s3:GetStorageLensDashboard",
          "s3:GetLifecycleConfiguration",
          "s3:GetInventoryConfiguration",
          "s3:GetBucketTagging",
          "s3:GetAccessPointPolicyForObjectLambda",
          "s3:GetBucketLogging",
          "s3:ListBucketVersions",
          "s3:ReplicateTags",
          "s3:ListBucket",
          "s3:GetAccelerateConfiguration",
          "s3:GetObjectVersionAttributes",
          "s3:GetBucketPolicy",
          "s3:GetEncryptionConfiguration",
          "s3:GetObjectVersionTorrent",
          "s3:PutBucketTagging",
          "s3:GetBucketRequestPayment",
          "s3:GetAccessPointPolicyStatus",
          "s3:GetObjectTagging",
          "s3:GetMetricsConfiguration",
          "s3:GetBucketOwnershipControls",
          "s3:PutObjectAcl",
          "s3:GetBucketPublicAccessBlock",
          "s3:GetMultiRegionAccessPointPolicyStatus",
          "s3:ListBucketMultipartUploads",
          "s3:PutBucketPublicAccessBlock",
          "s3:GetMultiRegionAccessPointPolicy",
          "s3:GetAccessPointPolicyStatusForObjectLambda",
          "s3:PutStorageLensConfigurationTagging",
          "s3:PutObjectVersionTagging",
          "s3:PutJobTagging",
          "s3:GetBucketVersioning",
          "s3:GetBucketAcl",
          "s3:GetAccessPointConfigurationForObjectLambda",
          "s3:BypassGovernanceRetention",
          "s3:GetObjectTorrent",
          "s3:ObjectOwnerOverrideToBucketOwner",
          "s3:GetMultiRegionAccessPointRoutes",
          "s3:GetStorageLensConfiguration",
          "s3:GetBucketCORS",
          "s3:PutBucketPolicy",
          "s3:DeleteAccessPointPolicy",
          "s3:GetBucketLocation",
          "s3:GetAccessPointPolicy",
          "s3:GetObjectVersion",
          "ec2:RunInstances",
          "lambda:InvokeFunction"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::*/*"
      }
    ]
  })
}