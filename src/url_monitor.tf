variable "url_monitors" {
  description = "Map of URL monitors to create"
  type = map(object({
    name                      = string
    url                       = string
    activated                 = optional(bool, true)
    frequency                 = optional(number, 5)
    use_global_alert_settings = optional(bool, true)
    locations                 = optional(list(string), ["eu-west-1"])
    method                    = optional(string, "GET")
    follow_redirects          = optional(bool, true)
    assertions = optional(list(object({
      source     = string
      comparison = string
      target     = string
    })), [
      {
        source     = "STATUS_CODE"
        comparison = "EQUALS"
        target     = "200"
      }
    ])
    tags = optional(list(string), [])
  }))
  default = {}
}
