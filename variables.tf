
variable "global_random_var"{
  type    = string
  default = "f5tg45t4"
}

variable "networking" {
  type = object({
    cidr_block      = string
    region          = string
    vpc_name        = string
    azs             = list(string)
    public_subnets  = list(string)
    nat_gateways    = bool
  })
  default = {
    cidr_block      = "10.0.0.0/16"
    region          = "us-east-1"
    vpc_name        = "custom-vpc"
    azs             = ["avz1", "avz2"]
    public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
    nat_gateways    = true
  }
}

variable "security_groups" {
  type = list(object({
    name        = string
    description = string
    ingress = list(object({
      description      = string
      protocol         = string
      from_port        = number
      to_port          = number
      cidr_blocks      = list(string)
      ipv6_cidr_blocks = list(string)
    }))
    egress = list(object({
      description      = string
      protocol         = string
      from_port        = number
      to_port          = number
      cidr_blocks      = list(string)
      ipv6_cidr_blocks = list(string)
    }))
  }))
  default = [{
    name        = "custom-security-group"
    description = "Inbound & Outbound traffic for custom-security-group"
    ingress = [
      {
        description      = "Allow HTTPS"
        protocol         = "tcp"
        from_port        = 443
        to_port          = 443
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = null
      },
      {
        description      = "Allow HTTP"
        protocol         = "tcp"
        from_port        = 80
        to_port          = 80
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = null
      },
      {
        description      = "Allow SSH"
        protocol         = "tcp"
        from_port        = 22
        to_port          = 22
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = null
      }
    ]
    egress = [
      {
        description      = "Allow all outbound traffic"
        protocol         = "-1"
        from_port        = 0
        to_port          = 0
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
      }
    ]
  }]
}


variable "cluster_config" {
  type = object({
    name    = string
    version = string
  })
  default = {
    name    = "pc-national-bank"
    version = "1.27"
  }
}

variable "node_groups" {
  type = list(object({
    name           = string
    instance_types = list(string)
    ami_type       = string
    capacity_type  = string
    disk_size      = number
    scaling_config = object({
      desired_size = number
      min_size     = number
      max_size     = number
    })
    update_config = object({
      max_unavailable = number
    })
  }))
  default = [
    {
      name           = "t3-medium-standard"
      instance_types = ["t3.medium"]
      ami_type       = "AL2_x86_64"
      capacity_type  = "ON_DEMAND"
      disk_size      = 20
      scaling_config = {
        desired_size = 5
        max_size     = 5
        min_size     = 3
      }
      update_config = {
        max_unavailable = 1
      }
    },
    {
      name           = "t3-medium-spot"
      instance_types = ["t3.medium"]
      ami_type       = "AL2_x86_64"
      capacity_type  = "ON_DEMAND"
      disk_size      = 20
      scaling_config = {
        desired_size = 5
        max_size     = 5
        min_size     = 3
      }
      update_config = {
        max_unavailable = 1
      }
    },
  ]

}

variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
  default = [
    {
      name    = "kube-proxy"
      version = "v1.27.1-eksbuild.1"
    },
    {
      name    = "vpc-cni"
      version = "v1.12.6-eksbuild.2"
    },
    {
      name    = "coredns"
      version = "v1.10.1-eksbuild.1"
    },
    {
      name    = "aws-ebs-csi-driver"
      version = "v1.22.0-eksbuild.2"
    }
  ]
}