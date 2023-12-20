terraform {
  cloud {
    organization = "theutz"

    workspaces {
      name = "theutz-com"
    }
  }

  required_providers {
    linode = {
      source  = "linode/linode"
      version = "2.9.1"
    }
    doppler = {
      source  = "DopplerHQ/doppler"
      version = "1.3.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "linode" {
  token = var.linode_token
}

provider "doppler" {
  doppler_token = var.doppler_token
}

provider "github" {
  token = var.github_token
}

variable "doppler_token" {
  type      = string
  sensitive = true
}

variable "linode_token" {
  type      = string
  sensitive = true
}

variable "github_token" {
  type      = string
  sensitive = true
}

variable "doppler_config" {
  type = string
}

variable "doppler_project" {
  type = string
}

data "linode_object_storage_cluster" "this" {
  id = "eu-central-1"
}

data "doppler_secrets" "this" {}

data "github_user" "current" {
  username = "theutz"
}

locals {
  cluster_id  = data.linode_object_storage_cluster.this.id
  bucket_name = data.doppler_secrets.this.map.BUCKET_NAME
}

resource "doppler_secret" "bucket_region" {
  config  = var.doppler_config
  project = var.doppler_project
  name    = "BUCKET_REGION"
  value   = local.cluster_id
}

resource "doppler_secret" "bucket_name" {
  config  = var.doppler_config
  project = var.doppler_project
  name    = "BUCKET_NAME"
  value   = "theutz-com"
}

resource "github_repository" "this" {
  name = "theutz.com"
}

resource "github_repository_environment" "prd" {
  environment = "production"
  repository  = github_repository.this.name
}

resource "linode_object_storage_key" "this" {
  label = "theutz-com-tf"
  bucket_access {
    bucket_name = local.bucket_name
    cluster     = local.cluster_id
    permissions = "read_write"
  }
}

resource "linode_object_storage_bucket" "this" {
  access_key = linode_object_storage_key.this.access_key
  secret_key = linode_object_storage_key.this.secret_key

  label   = local.bucket_name
  cluster = local.cluster_id

  acl          = "public-read"
  cors_enabled = true
}
