resource "checkly_private_location" "location" {
  name      = var.private_location_name
  slug_name = var.private_location_slug_name
}
