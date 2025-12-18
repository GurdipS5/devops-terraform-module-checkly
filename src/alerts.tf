# Email Alert Channels
resource "checkly_alert_channel" "email" {
  for_each = toset(var.alert_channels.email_addresses)

  email {
    address = each.value
  }
}
