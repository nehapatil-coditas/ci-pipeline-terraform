# Creating IPset Rule for WAF
resource "aws_wafv2_ip_set" "ipset" {
  name       = "tfIPSet"
  scope      = "REGIONAL" 
  ip_address_version = "IPV4"

  addresses = [
    "103.167.184.136/32"
  ]
}

# Creating Web acl and adding IPset rule
resource "aws_wafv2_web_acl" "TFWebACL" {
  name        = "TFWebACL"
  scope       = "REGIONAL"  
  description = "My WAFv2 Web ACL"

    #If none of the below rules match then allow the traffic
  default_action {
    allow {}
  }

    # Rule to block my IP using IPset
  rule {
    name     = "IPMatchRule"
    priority = 1
    action {
      block {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ipset.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "IPMatchMetric"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "WebACLMetric"
    sampled_requests_enabled   = true
  }

    # Rule to block request from INDIA
  rule {
    name = "IndiaGeoMatchRule"
    priority = 2
    action {
      block {}
    }

    statement {
      geo_match_statement {
        country_codes = "IN"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name = "GeoACLMetric"
      sampled_requests_enabled = true
    }
  }
}

# Associating Web ACL with Load Balancer
resource "aws_wafv2_web_acl_association" "WAFAssociation" {
  resource_arn = aws_lb.web_elb.arn
  web_acl_arn   = aws_wafv2_web_acl.TFWebACL.arn
}