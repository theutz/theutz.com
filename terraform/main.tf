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
  }
}

provider "linode" {
  token = var.linode_token
}

variable "bucket_name" {
  type = string
}

variable "linode_token" {
  type      = string
  sensitive = true
}

locals {
  cluster_id = data.linode_object_storage_cluster.this.id
}

data "linode_object_storage_cluster" "this" {
  id = "eu-central-1"
}

resource "linode_object_storage_key" "this" {
  label = "theutz-com-tf"
  bucket_access {
    bucket_name = var.bucket_name
    cluster     = local.cluster_id
    permissions = "read_write"
  }
}

resource "linode_object_storage_bucket" "this" {
  access_key = linode_object_storage_key.this.access_key
  secret_key = linode_object_storage_key.this.secret_key

  label   = var.bucket_name
  cluster = local.cluster_id

  acl          = "public-read"
  cors_enabled = true
}
