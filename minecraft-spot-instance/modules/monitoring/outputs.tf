output "sns_topic_arn" {
  description = "SNS topic ARN"
  value       = aws_sns_topic.minecraft_alerts.arn
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.discord_notifier.function_name
} 