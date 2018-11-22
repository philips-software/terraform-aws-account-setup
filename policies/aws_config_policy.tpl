{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "config:Put*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Action": [
                "s3:*"
            ],
            "Effect": "Allow",
            "Resource": [
                "${s3_bucket_arn}",
                "${s3_bucket_arn}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "sns:*",
            "Resource": "${sns_topic_arn}"
        }
    ]
}