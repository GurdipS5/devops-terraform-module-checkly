# modules/checkly/main.tf

# Check Group
resource "checkly_check_group" "main" {
  name        = "${var.environment}-monitors"
  activated   = true
  concurrency = 3
  locations   = var.default_locations

  alert_settings {
    escalation_type = "RUN_BASED"

    run_based_escalation {
      failed_run_threshold = 2
    }

    reminders {
      amount   = 2
      interval = 5
    }
  }

  retry_strategy {
    type                  = "LINEAR"
    base_backoff_seconds  = 60
    max_retries           = 2
    max_duration_seconds  = 600
    same_region           = true
  }
}

# API Checks
resource "checkly_check" "api" {
  for_each = var.api_checks

  name                   = each.key
  type                   = "API"
  activated              = each.value.activated
  frequency              = each.value.frequency
  locations              = coalesce(each.value.locations, var.default_locations)
  degraded_response_time = each.value.degraded_response_time
  max_response_time      = each.value.max_response_time
  group_id               = checkly_check_group.main.id
  tags                   = concat(each.value.tags, [var.environment])

  request {
    url              = each.value.url
    method           = each.value.method
    follow_redirects = true
    skip_ssl         = false

    dynamic "headers" {
      for_each = each.value.headers
      content {
        key   = headers.key
        value = headers.value
      }
    }

    assertion {
      source     = "STATUS_CODE"
      comparison = "EQUALS"
      target     = each.value.expected_status
    }

    assertion {
      source     = "RESPONSE_TIME"
      comparison = "LESS_THAN"
      target     = tostring(each.value.max_response_time)
    }
  }

  retry_strategy {
    type                  = "LINEAR"
    base_backoff_seconds  = 60
    max_retries           = 2
    max_duration_seconds  = 600
    same_region           = true
  }

  dynamic "alert_channel_subscription" {
    for_each = local.alert_channel_ids
    content {
      channel_id = alert_channel_subscription.value
      activated  = true
    }
  }
}

# Browser Checks
resource "checkly_check" "browser" {
  for_each = var.browser_checks

  name      = each.key
  type      = "BROWSER"
  activated = each.value.activated
  frequency = each.value.frequency
  locations = coalesce(each.value.locations, var.default_locations)
  group_id  = checkly_check_group.main.id
  tags      = concat(each.value.tags, [var.environment])

  script = file(each.value.script_path)

  retry_strategy {
    type                  = "LINEAR"
    base_backoff_seconds  = 60
    max_retries           = 2
    max_duration_seconds  = 600
    same_region           = true
  }

  dynamic "alert_channel_subscription" {
    for_each = local.alert_channel_ids
    content {
      channel_id = alert_channel_subscription.value
      activated  = true
    }
  }
}
