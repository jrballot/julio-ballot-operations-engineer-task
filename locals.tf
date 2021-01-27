##
## Local_file resource, used in order to create the config.py for our rates app
##
resource "local_file" "local" {
  content = format("DB = { 'name': 'postgres', 'user': 'postgres', 'host': '%s'}", aws_db_instance.main.endpoint)
  filename = "rates/config.py"
}
