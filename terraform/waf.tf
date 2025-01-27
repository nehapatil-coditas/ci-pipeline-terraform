# resource "aws_wafregional_ipset" "ipset" {
#   name = "tfIPSet"

#   ip_set_descriptor {
#     type  = "IPV4"
#     value = "103.167.184.136/32"
#   }
# }

# resource "aws_wafregional_rule" "WafRule" {
#   name        = "WAFRule"
#   metric_name = "WAFRuleMetric"

#   predicate {
#     data_id = "${aws_wafregional_ipset.ipset.id}"
#     negated = false
#     type    = "IPMatch"
#   }
# }

# resource "aws_wafregional_web_acl" "TFWebACL" {
#   name        = "TFWebACL"
#   metric_name = "WebACLMetric"

#   default_action {
#     type = "ALLOW"
#   }

#   rule {
#     action {
#       type = "BLOCK"
#     }

#     priority = 1
#     rule_id  = "${aws_wafregional_rule.WafRule.id}"
#   }
# }


# resource "aws_wafregional_web_acl_association" "WAFAssociation" {
#   resource_arn = "${aws_lb.web_elb.arn}"
#   web_acl_id   = "${aws_wafregional_web_acl.TFWebACL.id}"
# }