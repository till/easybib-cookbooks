#Mail Notifcation

Example Stack JSON:
```
  "monit": {
    "mailhost": "email-smtp.us-east-1.amazonaws.com",
    "mailuser": "XXX",
    "mailpass": "YYY",
    "mailsender": "some@sender.tld",
    "notification_recipients": ["some@recipient.tld"]
  },
```

Please note: When using Amazon SES, the domain of the mailsender\
and all notification\_recipients need to be verified in Amazon SES
(at least when using in test mode).