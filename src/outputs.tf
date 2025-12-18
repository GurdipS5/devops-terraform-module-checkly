# modules/checkly/outputs.tf
output "check_group_id" {
  description = "ID of the check group"
  value       = checkly_check_group.main.id
}

output "api_check_ids" {
  description = "Map of API check names to IDs"
  value       = { for k, v in checkly_check.api : k => v.id }
}

output "browser_check_ids" {
  description = "Map of browser check names to IDs"
  value       = { for k, v in checkly_check.browser : k => v.id }
}

output "alert_channel_ids" {
  description = "List of alert channel IDs"
  value       = local.alert_channel_ids
}
