variable "checkly_api_key" {
  description = "Checkly API key"
  type        = string
  sensitive   = true
}

variable "checkly_account_id" {
  description = "Checkly account ID"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., prod, staging)"
  type        = string
  default     = "prod"
}

variable "default_locations" {
  description = "Default check locations"
  type        = list(string)
  default     = ["eu-west-1", "us-east-1"]
}

variable "api_checks" {
  description = "Map of API checks to create"
  type = map(object({
    url                    = string
    method                 = optional(string, "GET")
    frequency              = optional(number, 5)
    activated              = optional(bool, true)
    locations              = optional(list(string), null)
    expected_status        = optional(string, "200")
    degraded_response_time = optional(number, 5000)
    max_response_time      = optional(number, 10000)
    headers                = optional(map(string), {})
    tags                   = optional(list(string), [])
  }))
  default = {}
}

variable "browser_checks" {
  description = "Map of browser checks to create"
  type = map(object({
    script_path = string
    frequency   = optional(number, 10)
    activated   = optional(bool, true)
    locations   = optional(list(string), null)
    tags        = optional(list(string), [])
  }))
  default = {}
}

variable "alert_channels" {
  description = "Alert channel configurations"
  type = object({
    slack_webhook_url = optional(string, null)
    pagerduty_key     = optional(string, null)
    opsgenie_api_key  = optional(string, null)
    email_addresses   = optional(list(string), [])
  })
  default = {}
}

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
