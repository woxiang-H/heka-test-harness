data "aws_caller_identity" "current" {
}

locals {
  availability_zone      = "us-east-1b"
  cidr_block             = "10.0.0.0/16"
  test_configuration     = var.test_configuration
  test_name              = var.test_name
  user_id                = var.user_id
  results_s3_bucket_name = var.results_s3_bucket_name
}

module "vpc" {
  source = "../aws_vpc"

  providers = {
    aws = aws
  }

  availability_zone = local.availability_zone
  cidr_block        = local.cidr_block
  test_name         = local.test_name
  user_id           = local.user_id
}

resource "aws_security_group" "producer" {
  name        = "vector-test-${local.user_id}-${local.test_name}-producer"
  description = "Security group for members of the Vector ${local.user_id}-${local.test_name} test producer group"
  vpc_id      = module.vpc.vpc_id


  # Inter-node egress
  egress {
    from_port = var.subject_from_port
    to_port   = var.subject_to_port
    protocol  = "tcp"
    self      = true
  }

  tags = {
    Name       = "vector-test-${local.user_id}-${local.test_name}-producer"
    TestName   = local.test_name
    TestRole   = "producer"
    TestUserID = local.user_id
  }
}

resource "aws_security_group" "subject" {
  name        = "vector-test-${local.user_id}-${local.test_name}-subject"
  description = "Security group for members of the Vector ${local.user_id}-${local.test_name} test subject group"
  vpc_id      = module.vpc.vpc_id


  # Inter-node ingress
  ingress {
    from_port   = var.subject_from_port
    to_port     = var.subject_to_port
    protocol    = "tcp"
    cidr_blocks = [module.vpc.cidr_block]
  }

  tags = {
    Name       = "vector-test-${local.user_id}-${local.test_name}-subject"
    TestName   = local.test_name
    TestRole   = "subject"
    TestUserID = local.user_id
  }
}

module "aws_instance_profile" {
  source = "../aws_instance_profile"

  providers = {
    aws = aws
  }

  test_configuration     = local.test_configuration
  test_name              = local.test_name
  user_id                = local.user_id
  results_s3_bucket_name = local.results_s3_bucket_name
}

module "aws_instance_producer" {
  source = "../aws_instance"

  providers = {
    aws = aws
  }

  instance_count = var.producer_instance_count

  availability_zone     = local.availability_zone
  instance_profile_name = module.aws_instance_profile.name
  instance_type         = var.producer_instance_type
  public_key            = file(var.pub_key)
  role_name             = "producer"
  security_group_ids    = [module.vpc.default_security_group_id, aws_security_group.producer.id]
  subnet_id             = module.vpc.default_subnet_id
  test_configuration    = local.test_configuration
  test_name             = local.test_name
  user_id               = local.user_id
}

module "aws_instance_subject" {
  source = "../aws_instance"

  providers = {
    aws = aws
  }

  availability_zone     = local.availability_zone
  instance_profile_name = module.aws_instance_profile.name
  instance_type         = var.subject_instance_type
  public_key            = file(var.pub_key)
  role_name             = "subject"
  security_group_ids    = [module.vpc.default_security_group_id, aws_security_group.subject.id]
  subnet_id             = module.vpc.default_subnet_id
  test_configuration    = local.test_configuration
  test_name             = local.test_name
  user_id               = local.user_id
}
