variable "rgid" {
  description = "RGID used for naming"
}

variable "location" {
  default     = "southcentralus"
  description = "Location for resources to be created"
}

variable "count" {
  default = "1"
}

variable "name_prefix" {
  default     = ""
  description = "Allows users to override the standard naming prefix.  If left as an empty string, the standard naming conventions will apply."
}

variable "environment" {
  default     = "dev"
  description = "Environment used in naming lookups"
}

variable "rg_name" {
  description = "Default resource group name that the database will be created in."
}

variable "collation" {
  description = "The collation for the database. Default is utf8_unicode_ci."
  default     = "utf8_unicode_ci"
}

variable "charset" {
  description = "The charset for the database. Default is utf8."
  default     = "utf8"
}

variable "server_name" {
  description = "Azure SQL server where the database will be created."
}

variable "db_username" {
  description = "Azure MySQL database username.  Has all privileges granted by default."
}

# Compute default name values
locals {
  env_id = "${lookup(module.naming.env-map, var.environment, "env")}"
  type   = "${lookup(module.naming.type-map, "azurerm_mysql_database", "typ")}"

  default_rgid        = "${var.rgid != "" ? var.rgid : "norgid"}"
  default_name_prefix = "c${local.default_rgid}${local.env_id}"

  name_prefix = "${var.name_prefix != "" ? var.name_prefix : local.default_name_prefix}"
  name        = "${local.name_prefix}${local.type}"
  db_username = "${var.db_username ? var.db_username : local.name}"
}

# This module provides a data map output to lookup naming standard references
module "naming" {
  source = "git::https://github.com/CLEAResult/cr-azurerm-naming.git?ref=v1.0.1"
}
