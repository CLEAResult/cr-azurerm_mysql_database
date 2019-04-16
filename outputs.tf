output "database_name" {
  description = "Database name of the Azure MySQL Database created."
  value       = ["${azurerm_mysql_database.db.*.name}"]
}

output "id" {
  description = "The Azure MySQL Database ID."
  value       = ["${azurerm_mysql_database.db.*.id}"]
}
