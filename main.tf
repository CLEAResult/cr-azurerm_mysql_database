resource "random_string" "password" {
  length           = 16
  special          = true
  override_special = "/@\" "
}

resource "azurerm_mysql_database" "db" {
  name                = "${local.name}${format("%03d", count.index + 1)}"
  count               = "${var.count}"
  resource_group_name = "${var.rg_name}"
  location            = "${var.location}"
  collation           = "${var.collation}"
  charset             = "${var.charset}"
  server_name         = "${var.server_name}"

  tags = {
    InfrastructureAsCode = "True"
  }

  lifecycle {
    ignore_changes = ["tags"]
  }
}

resource "mysql_user" "db-user" {
  user     = "${local.db_username}"
  host     = "${var.server_name}"
  password = "${random_string.password.result}"
}

resource "mysql_grant" "db-user-grant" {
  user       = "${mysql_user.db-user.user}"
  host       = "${mysql_user.db-user.host}"
  database   = "${azurerm_mysql_database.db.name}"
  grant      = true
  privileges = ["ALL"]
}
