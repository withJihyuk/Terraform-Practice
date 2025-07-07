# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "minecraft-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for Lambda
resource "aws_iam_policy" "lambda_policy" {
  name        = "minecraft-lambda-policy"
  description = "Policy for Minecraft Lambda function"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach policy to Lambda role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Lambda function for Discord notifications
resource "aws_lambda_function" "discord_notifier" {
  filename         = "discord_notifier.zip"
  function_name    = "minecraft-discord-notifier"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "python3.9"
  timeout         = 30

  environment {
    variables = {
      DISCORD_WEBHOOK_URL = var.discord_webhook_url
    }
  }

  depends_on = [data.archive_file.lambda_zip]
}

# Create Lambda deployment package
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "discord_notifier.zip"
  
  source {
    content = <<EOF
import json
import urllib3
import os
import boto3

def handler(event, context):
    webhook_url = os.environ['DISCORD_WEBHOOK_URL']
    
    try:
        # Check if event is from SNS (CloudWatch Alarm) or EventBridge (EC2 State Change)
        if 'Records' in event:
            # SNS event from CloudWatch Alarm
            message = json.loads(event['Records'][0]['Sns']['Message'])
            
            discord_message = {
                "content": f"🚨 **Minecraft Server Alert** 🚨\n"
                          f"**Alarm:** {message['AlarmName']}\n"
                          f"**Status:** {message['NewStateValue']}\n"
                          f"**Reason:** {message['NewStateReason']}\n"
                          f"**Time:** {message['StateChangeTime']}"
            }
            
        elif 'source' in event and event['source'] == 'aws.ec2':
            # EventBridge event from EC2 State Change
            detail = event['detail']
            instance_id = detail['instance-id']
            state = detail['state']
            
            # Get instance details
            ec2_client = boto3.client('ec2')
            try:
                response = ec2_client.describe_instances(InstanceIds=[instance_id])
                instance = response['Reservations'][0]['Instances'][0]
                
                # Get instance name from tags
                instance_name = "Unknown"
                if 'Tags' in instance:
                    for tag in instance['Tags']:
                        if tag['Key'] == 'Name':
                            instance_name = tag['Value']
                            break
                
                # Get public IP if available
                public_ip = instance.get('PublicIpAddress', 'N/A')
                
                if state == 'running':
                    discord_message = {
                        "content": f"🚀 **Minecraft Server Started!** 🚀\n"
                                  f"**Instance:** {instance_name} ({instance_id})\n"
                                  f"**State:** {state}\n"
                                  f"**Public IP:** {public_ip}\n"
                                  f"**Time:** {event['time']}"
                    }
                elif state == 'stopped':
                    discord_message = {
                        "content": f"⏹️ **Minecraft Server Stopped** ⏹️\n"
                                  f"**Instance:** {instance_name} ({instance_id})\n"
                                  f"**State:** {state}\n"
                                  f"**Time:** {event['time']}"
                    }
                elif state == 'terminated':
                    discord_message = {
                        "content": f"💀 **Minecraft Server Terminated** 💀\n"
                                  f"**Instance:** {instance_name} ({instance_id})\n"
                                  f"**State:** {state}\n"
                                  f"**Time:** {event['time']}"
                    }
                else:
                    discord_message = {
                        "content": f"ℹ️ **Minecraft Server State Change** ℹ️\n"
                                  f"**Instance:** {instance_name} ({instance_id})\n"
                                  f"**State:** {state}\n"
                                  f"**Time:** {event['time']}"
                    }
                    
            except Exception as e:
                discord_message = {
                    "content": f"ℹ️ **Minecraft Server State Change** ℹ️\n"
                              f"**Instance ID:** {instance_id}\n"
                              f"**State:** {state}\n"
                              f"**Time:** {event['time']}\n"
                              f"**Note:** Could not fetch instance details"
                }
        
        else:
            # Unknown event type
            discord_message = {
                "content": f"❓ **Unknown Event** ❓\n"
                          f"**Event:** {json.dumps(event, indent=2)}"
            }
        
        # Send to Discord
        http = urllib3.PoolManager()
        response = http.request(
            'POST',
            webhook_url,
            body=json.dumps(discord_message),
            headers={'Content-Type': 'application/json'}
        )
        
        return {
            'statusCode': 200,
            'body': json.dumps('Notification sent successfully')
        }
        
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error: {str(e)}')
        }
EOF
    filename = "index.py"
  }
}

# SNS Topic for CloudWatch alarms
resource "aws_sns_topic" "minecraft_alerts" {
  name = "minecraft-alerts"
  
  tags = merge(var.common_tags, {
    Name = "minecraft-alerts"
  })
}

# SNS Topic Subscription for Lambda
resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = aws_sns_topic.minecraft_alerts.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.discord_notifier.arn
}

# Lambda permission for SNS
resource "aws_lambda_permission" "sns_invoke" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.discord_notifier.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.minecraft_alerts.arn
}

# Lambda permission for EventBridge
resource "aws_lambda_permission" "eventbridge_invoke" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.discord_notifier.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2_state_change.arn
}

# EventBridge Rule for EC2 State Changes
resource "aws_cloudwatch_event_rule" "ec2_state_change" {
  name        = "minecraft-ec2-state-change"
  description = "Capture EC2 instance state changes for Minecraft server"

  event_pattern = jsonencode({
    source      = ["aws.ec2"]
    detail-type = ["EC2 Instance State-change Notification"]
    detail = {
      instance-id = [var.instance_id]
      state       = ["pending", "running", "stopping", "stopped", "terminated"]
    }
  })

  tags = merge(var.common_tags, {
    Name = "minecraft-ec2-state-change"
  })
}

# EventBridge Target for Lambda
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.ec2_state_change.name
  target_id = "MinecraftDiscordNotifierTarget"
  arn       = aws_lambda_function.discord_notifier.arn
}

# CloudWatch Alarm for Spot Instance Termination
resource "aws_cloudwatch_metric_alarm" "spot_instance_termination" {
  alarm_name          = "minecraft-spot-instance-termination"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "0"
  alarm_description   = "This metric monitors minecraft spot instance termination"
  alarm_actions       = [aws_sns_topic.minecraft_alerts.arn]

  dimensions = {
    InstanceId = var.instance_id
  }
}

# CloudWatch Alarm for Instance Status Check
resource "aws_cloudwatch_metric_alarm" "instance_status_check" {
  alarm_name          = "minecraft-instance-status-check"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "StatusCheckFailed_Instance"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "0"
  alarm_description   = "This metric monitors minecraft instance status check"
  alarm_actions       = [aws_sns_topic.minecraft_alerts.arn]

  dimensions = {
    InstanceId = var.instance_id
  }
} 