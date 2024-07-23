# This is a sample code to create identity provider and assuming the role
# resource "aws_iam_openid_connect_provider" "OIDCProvider" {
#   url = "https://token.actions.githubusercontent.com"

#   client_id_list = [
#     "sts.amazonaws.com",
#   ]

#   thumbprint_list = ["ffffffffffffffffffffffffffffffffffffffff"]
# }

# # Policy for assuming role
# data "aws_iam_policy_document" "oidc" {
#   version = "2012-10-17"
#   statement {
#     effect  = "Allow"
#     principals {
#       type        = "Federated"
#       identifiers = "arn:aws:iam::654654566690:oidc-provider/token.actions.githubusercontent.com"
#     }
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#     condition {
#       test     = "StringEquals"
#       values   = ["sts.amazonaws.com"]
#       variable = "token.actions.githubusercontent.com:aud"
#     }

#     condition {
#       test     = "StringLike"
#       values   = ["repo:nehapatil-coditas/ci-pipeline-terraform:ref:refs/heads/main"]
#       variable = "token.actions.githubusercontent.com:sub"
#     }
#   }
# }

# # Creating role and assuming policy
# resource "aws_iam_role" "GithubOIDCRole" {
#   name               = "github_oidc_role"
#   assume_role_policy = data.aws_iam_policy_document.oidc.json
# }

# # Creating policy document for give necessary permissions to Github
# data "aws_iam_policy_document" "AdminAccess" {
#   version = "2012-10-17"
#   statement {
#     effect  = "Allow"
#     actions = ["*"]
#     resources = ["*"]
#   }
# }

# # Attaching policy document to iam policy
# resource "aws_iam_policy" "deployPolicy" {
#   name        = "github-deploy-policy"
#   description = "Policy used for deployments on CI"
#   policy      = data.aws_iam_policy_document.AdminAccess.json
# }

# # Attaching policy to role
# resource "aws_iam_role_policy_attachment" "attach-deploy" {
#   role       = aws_iam_role.GithubOIDCRole.name
#   policy_arn = aws_iam_policy.deployPolicy.arn
# }