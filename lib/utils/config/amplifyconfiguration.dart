const dev = ''' {
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "Default": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://2x7qjjxv2rgitern3w35t7ygsq.appsync-api.us-west-2.amazonaws.com/graphql",
                    "region": "us-west-2",
                    "authorizationType": "AMAZON_COGNITO_USER_POOLS"
                },
                "family-connect-api-development_AWS_IAM": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://2x7qjjxv2rgitern3w35t7ygsq.appsync-api.us-west-2.amazonaws.com/graphql",
                    "region": "us-west-2",
                    "authorizationType": "AWS_IAM",
                   "apiKey": "da2-uebx3lqi5fekpgq3cz4zwc3ip4"
                },
                "family-connect-api-development_API_KEY": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://2x7qjjxv2rgitern3w35t7ygsq.appsync-api.us-west-2.amazonaws.com/graphql",
                    "region": "us-west-2",
                    "authorizationType": "API_KEY",
                   "apiKey": "da2-uebx3lqi5fekpgq3cz4zwc3ip4"
                },
                "family-connect-api-development": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://2x7qjjxv2rgitern3w35t7ygsq.appsync-api.us-west-2.amazonaws.com/graphql",
                    "region": "us-west-2",
                    "authorizationType": "AMAZON_COGNITO_USER_POOLS",
                    "apiKey": "da2-uebx3lqi5fekpgq3cz4zwc3ip4"
                }
            }
        }
    },
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "us-west-2:9e2de753-54b3-4b99-9ae0-d06af96fd5fe",
                            "Region": "us-west-2"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-west-2_nTbfSsqjJ",
                        "AppClientId": "5v68jdhknv13b2em2up9cj9ks1",
                        "Region": "us-west-2"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "socialProviders": [],
                        "usernameAttributes": [],
                        "signupAttributes": [],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": []
                        },
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [],
                        "verificationMechanisms": []
                    }
                },
                "S3TransferUtility": {
                    "Default": {
                        "Bucket": "mobex-health-development-data-us-west-2",
                        "Region": "us-west-2"
                    }
                },
                "AppSync": {
                    "Default": {
                        "ApiUrl": "https://2x7qjjxv2rgitern3w35t7ygsq.appsync-api.us-west-2.amazonaws.com/graphql",
                        "Region": "us-west-2",
                        "AuthMode": "AMAZON_COGNITO_USER_POOLS",
                        "ClientDatabasePrefix": "family-connect-api-development_AMAZON_COGNITO_USER_POOLS"
                    },
                    "family-connect-api-development": {
                        "ApiUrl": "https://2x7qjjxv2rgitern3w35t7ygsq.appsync-api.us-west-2.amazonaws.com/graphql",
                        "Region": "us-west-2",
                        "AuthMode": "AMAZON_COGNITO_USER_POOLS",
                        "ClientDatabasePrefix": "family-connect-api-development_AMAZON_COGNITO_USER_POOLS"
                    },
                    "family-connect-api-development_AWS_IAM": {
                        "ApiUrl": "https://2x7qjjxv2rgitern3w35t7ygsq.appsync-api.us-west-2.amazonaws.com/graphql",
                        "Region": "us-west-2",
                        "AuthMode": "AWS_IAM",
                        "ClientDatabasePrefix": "family-connect-api-development_AWS_IAM"
                    },
                    "family-connect-api-development_API_KEY": {
                        "ApiUrl": "https://2x7qjjxv2rgitern3w35t7ygsq.appsync-api.us-west-2.amazonaws.com/graphql",
                        "Region": "us-west-2",
                        "AuthMode": "API_KEY",
                        "ApiKey": "da2-uebx3lqi5fekpgq3cz4zwc3ip4",
                        "ClientDatabasePrefix": "family-connect-api-development_API_KEY"
                    }
                }
            }
        }
    },
    "storage": {
        "plugins": {
            "awsS3StoragePlugin": {
                "bucket": "mobex-health-development-data-us-west-2",
                "region": "us-west-2",
                "defaultAccessLevel": "guest"
            }
        }
    }
}''';

const uat  = ''' {
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "Default": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://gxiktrt44rhfzpfjplk4aykj6i.appsync-api.us-west-2.amazonaws.com/graphql",
                    "region": "us-west-2",
                    "authorizationType": "AMAZON_COGNITO_USER_POOLS"
                },
                "family-connect-api-uat_AWS_IAM": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://gxiktrt44rhfzpfjplk4aykj6i.appsync-api.us-west-2.amazonaws.com/graphql",
                    "region": "us-west-2",
                    "authorizationType": "AWS_IAM",
                   "apiKey": "da2-pblzpqtrsjctjci2e6anm6ylcu"
                },
                "family-connect-api-uat_API_KEY": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://gxiktrt44rhfzpfjplk4aykj6i.appsync-api.us-west-2.amazonaws.com/graphql",
                    "region": "us-west-2",
                    "authorizationType": "API_KEY",
                   "apiKey": "da2-pblzpqtrsjctjci2e6anm6ylcu"
                },
                "family-connect-api-uat": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://gxiktrt44rhfzpfjplk4aykj6i.appsync-api.us-west-2.amazonaws.com/graphql",
                    "region": "us-west-2",
                    "authorizationType": "AMAZON_COGNITO_USER_POOLS",
                    "apiKey": "da2-pblzpqtrsjctjci2e6anm6ylcu"
                }
            }
        }
    },
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "us-west-2:ee187a44-fdd9-4b3f-b8a0-65be1c7b0911",
                            "Region": "us-west-2"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-west-2_dKkf9GkRp",
                        "AppClientId": "2g1kna0kpg4s1okhgnle33sg0o",
                        "Region": "us-west-2"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "socialProviders": [],
                        "usernameAttributes": [],
                        "signupAttributes": [],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": []
                        },
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [],
                        "verificationMechanisms": []
                    }
                },
                "S3TransferUtility": {
                    "Default": {
                        "Bucket": "mobex-health-uat-data-us-west-2",
                        "Region": "us-west-2"
                    }
                },
                "AppSync": {
                    "Default": {
                        "ApiUrl": "https://gxiktrt44rhfzpfjplk4aykj6i.appsync-api.us-west-2.amazonaws.com/graphql",
                        "Region": "us-west-2",
                        "AuthMode": "AMAZON_COGNITO_USER_POOLS",
                        "ClientDatabasePrefix": "family-connect-api-uat_AMAZON_COGNITO_USER_POOLS"
                    },
                    "family-connect-api-uat": {
                        "ApiUrl": "https://gxiktrt44rhfzpfjplk4aykj6i.appsync-api.us-west-2.amazonaws.com/graphql",
                        "Region": "us-west-2",
                        "AuthMode": "AMAZON_COGNITO_USER_POOLS",
                        "ClientDatabasePrefix": "family-connect-api-uat_AMAZON_COGNITO_USER_POOLS"
                    },
                    "family-connect-api-uat_AWS_IAM": {
                        "ApiUrl": "https://gxiktrt44rhfzpfjplk4aykj6i.appsync-api.us-west-2.amazonaws.com/graphql",
                        "Region": "us-west-2",
                        "AuthMode": "AWS_IAM",
                        "ClientDatabasePrefix": "family-connect-api-uat_AWS_IAM"
                    },
                    "family-connect-api-uat_API_KEY": {
                        "ApiUrl": "https://gxiktrt44rhfzpfjplk4aykj6i.appsync-api.us-west-2.amazonaws.com/graphql",
                        "Region": "us-west-2",
                        "AuthMode": "API_KEY",
                        "ApiKey": "da2-pblzpqtrsjctjci2e6anm6ylcu",
                        "ClientDatabasePrefix": "family-connect-api-uat_API_KEY"
                    }
                }
            }
        }
    },
    "storage": {
        "plugins": {
            "awsS3StoragePlugin": {
                "bucket": "mobex-health-uat-data-us-west-2",
                "region": "us-west-2",
                "defaultAccessLevel": "guest"
            }
        }
    }
}''';

const prod = ''' {
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "Default": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://feuhkay3rrdlvc7bz44ioxp4ie.appsync-api.us-east-1.amazonaws.com/graphql",
                    "region": "us-east-1",
                    "authorizationType": "AMAZON_COGNITO_USER_POOLS"
                },
                "family-connect-api-prod_AWS_IAM": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://feuhkay3rrdlvc7bz44ioxp4ie.appsync-api.us-east-1.amazonaws.com/graphql",
                    "region": "us-east-1",
                    "authorizationType": "AWS_IAM",
                   "apiKey": "da2-xvdsu7wn2zevvcsuhbu7spbqs4"
                },
                "family-connect-api-prod_API_KEY": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://feuhkay3rrdlvc7bz44ioxp4ie.appsync-api.us-east-1.amazonaws.com/graphql",
                    "region": "us-east-1",
                    "authorizationType": "API_KEY",
                   "apiKey": "da2-xvdsu7wn2zevvcsuhbu7spbqs4"
                },
                "family-connect-api-prod": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://feuhkay3rrdlvc7bz44ioxp4ie.appsync-api.us-east-1.amazonaws.com/graphql",
                    "region": "us-east-1",
                    "authorizationType": "AMAZON_COGNITO_USER_POOLS",
                    "apiKey": "da2-xvdsu7wn2zevvcsuhbu7spbqs4"
                }
            }
        }
    },
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "us-east-1:19d62fc9-57c1-439d-bb96-22d534625b7b",
                            "Region": "us-east-1"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-east-1_cgIh6YuNV",
                        "AppClientId": "3kp8o4nd7vio2qu7legtkb77ne",
                        "Region": "us-east-1"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "socialProviders": [],
                        "usernameAttributes": [],
                        "signupAttributes": [],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": []
                        },
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [],
                        "verificationMechanisms": []
                    }
                },
                "S3TransferUtility": {
                    "Default": {
                        "Bucket": "mobex-health-production-data-us-east-1",
                        "Region": "us-east-1"
                    }
                },
                "AppSync": {
                    "Default": {
                        "ApiUrl": "https://feuhkay3rrdlvc7bz44ioxp4ie.appsync-api.us-east-1.amazonaws.com/graphql",
                        "Region": "us-east-1",
                        "AuthMode": "AMAZON_COGNITO_USER_POOLS",
                        "ClientDatabasePrefix": "family-connect-api-prod_AMAZON_COGNITO_USER_POOLS"
                    },
                    "family-connect-api-prod": {
                        "ApiUrl": "https://feuhkay3rrdlvc7bz44ioxp4ie.appsync-api.us-east-1.amazonaws.com/graphql",
                        "Region": "us-east-1",
                        "AuthMode": "AMAZON_COGNITO_USER_POOLS",
                        "ClientDatabasePrefix": "family-connect-api-prod_AMAZON_COGNITO_USER_POOLS"
                    },
                    "family-connect-api-prod_AWS_IAM": {
                        "ApiUrl": "https://feuhkay3rrdlvc7bz44ioxp4ie.appsync-api.us-east-1.amazonaws.com/graphql",
                        "Region": "us-east-1",
                        "AuthMode": "AWS_IAM",
                        "ClientDatabasePrefix": "family-connect-api-prod_AWS_IAM"
                    },
                    "family-connect-api-prod_API_KEY": {
                        "ApiUrl": "https://feuhkay3rrdlvc7bz44ioxp4ie.appsync-api.us-east-1.amazonaws.com/graphql",
                        "Region": "us-east-1",
                        "AuthMode": "API_KEY",
                        "ApiKey": "da2-xvdsu7wn2zevvcsuhbu7spbqs4",
                        "ClientDatabasePrefix": "family-connect-api-prod_API_KEY"
                    }
                }
            }
        }
    },
    "storage": {
        "plugins": {
            "awsS3StoragePlugin": {
                "bucket": "mobex-health-production-data-us-east-1",
                "region": "us-east-1",
                "defaultAccessLevel": "guest"
            }
        }
    }
}''';

const demo  = ''' {
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "Default": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://zytrgzxafrgbbjcatj6kutj4mm.appsync-api.us-west-2.amazonaws.com/graphql",
                    "region": "us-east-2",
                    "authorizationType": "AMAZON_COGNITO_USER_POOLS"
                },
                "family-connect-api-development_AWS_IAM": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://zytrgzxafrgbbjcatj6kutj4mm.appsync-api.us-west-2.amazonaws.com/graphql",
                    "region": "us-east-2",
                    "authorizationType": "AWS_IAM",
                   "apiKey": "da2-kzsrj4jhu5cpzahbfhy2cwupqa"
                },
                "family-connect-api-development_API_KEY": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://zytrgzxafrgbbjcatj6kutj4mm.appsync-api.us-west-2.amazonaws.com/graphql",
                    "region": "us-east-2",
                    "authorizationType": "API_KEY",
                   "apiKey": "da2-kzsrj4jhu5cpzahbfhy2cwupqa"
                },
                "family-connect-api-development": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://zytrgzxafrgbbjcatj6kutj4mm.appsync-api.us-west-2.amazonaws.com/graphql",
                    "region": "us-east-2",
                    "authorizationType": "AMAZON_COGNITO_USER_POOLS",
                    "apiKey": "da2-kzsrj4jhu5cpzahbfhy2cwupqa"
                }
            }
        }
    },
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "us-west-2:800d97df-921d-4e7a-9bd3-d8131a9c7c0d",
                            "Region": "us-west-2"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-west-2_kuFCEHuPq",
                        "AppClientId": "27m9vgik2pci2v65i3b8smikti",
                        "Region": "us-west-2"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "socialProviders": [],
                        "usernameAttributes": [],
                        "signupAttributes": [],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": []
                        },
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [],
                        "verificationMechanisms": []
                    }
                },
                "S3TransferUtility": {
                    "Default": {
                        "Bucket": "mobex-health-hub-development-data",
                        "Region": "us-east-2"
                    }
                },
                "AppSync": {
                    "Default": {
                        "ApiUrl": "https://zytrgzxafrgbbjcatj6kutj4mm.appsync-api.us-west-2.amazonaws.com/graphql",
                        "Region": "us-east-2",
                        "AuthMode": "AMAZON_COGNITO_USER_POOLS",
                        "ClientDatabasePrefix": "family-connect-api-development_AMAZON_COGNITO_USER_POOLS"
                    },
                    "family-connect-api-development": {
                        "ApiUrl": "https://zytrgzxafrgbbjcatj6kutj4mm.appsync-api.us-west-2.amazonaws.com/graphql",
                        "Region": "us-east-2",
                        "AuthMode": "AMAZON_COGNITO_USER_POOLS",
                        "ClientDatabasePrefix": "family-connect-api-development_AMAZON_COGNITO_USER_POOLS"
                    },
                    "family-connect-api-development_AWS_IAM": {
                        "ApiUrl": "https://zytrgzxafrgbbjcatj6kutj4mm.appsync-api.us-west-2.amazonaws.com/graphql",
                        "Region": "us-east-2",
                        "AuthMode": "AWS_IAM",
                        "ClientDatabasePrefix": "family-connect-api-development_AWS_IAM"
                    },
                    "family-connect-api-development_API_KEY": {
                        "ApiUrl": "https://zytrgzxafrgbbjcatj6kutj4mm.appsync-api.us-west-2.amazonaws.com/graphql",
                        "Region": "us-east-2",
                        "AuthMode": "API_KEY",
                        "ApiKey": "da2-kzsrj4jhu5cpzahbfhy2cwupqa",
                        "ClientDatabasePrefix": "family-connect-api-development_API_KEY"
                    }
                }
            }
        }
    },
    "storage": {
        "plugins": {
            "awsS3StoragePlugin": {
                "bucket": "mobex-health-development-data-us-east-2",
                "region": "us-east-2",
                "defaultAccessLevel": "guest"
            }
        }
    }
}''';

const internal = ''' {
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "Default": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://tc3sw6ndxnefzhkgyzgvu2r22m.appsync-api.us-west-2.amazonaws.com/graphql",
                    "region": "us-west-2",
                    "authorizationType": "AMAZON_COGNITO_USER_POOLS"
                },
                "family-connect-api-development_AWS_IAM": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://tc3sw6ndxnefzhkgyzgvu2r22m.appsync-api.us-west-2.amazonaws.com/graphql",
                    "region": "us-west-2",
                    "authorizationType": "AWS_IAM",
                   "apiKey": "da2-34x7gehkr5a4bn4vzw44n6awwu"
                },
                "family-connect-api-development_API_KEY": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://tc3sw6ndxnefzhkgyzgvu2r22m.appsync-api.us-west-2.amazonaws.com/graphql",
                    "region": "us-west-2",
                    "authorizationType": "API_KEY",
                   "apiKey": "da2-34x7gehkr5a4bn4vzw44n6awwu"
                },
                "family-connect-api-development": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://tc3sw6ndxnefzhkgyzgvu2r22m.appsync-api.us-west-2.amazonaws.com/graphql",
                    "region": "us-west-2",
                    "authorizationType": "AMAZON_COGNITO_USER_POOLS",
                    "apiKey": "da2-34x7gehkr5a4bn4vzw44n6awwu"
                }
            }
        }
    },
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "us-west-2:f5a1117a-acc4-4ad5-a553-e29d2062b552",
                            "Region": "us-west-2"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-west-2_vmgsPhF78",
                        "AppClientId": "7fbc511pb3bp44i7dnk9rs166q",
                        "Region": "us-west-2"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "socialProviders": [],
                        "usernameAttributes": [],
                        "signupAttributes": [],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": []
                        },
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [],
                        "verificationMechanisms": []
                    }
                },
                "S3TransferUtility": {
                    "Default": {
                        "Bucket": "mobex-health-hub-internal-data-us-west-2",
                        "Region": "us-west-2"
                    }
                },
                "AppSync": {
                    "Default": {
                        "ApiUrl": "https://tc3sw6ndxnefzhkgyzgvu2r22m.appsync-api.us-west-2.amazonaws.com/graphql",
                        "Region": "us-west-2",
                        "AuthMode": "AMAZON_COGNITO_USER_POOLS",
                        "ClientDatabasePrefix": "family-connect-api-development_AMAZON_COGNITO_USER_POOLS"
                    },
                    "family-connect-api-development": {
                        "ApiUrl": "https://tc3sw6ndxnefzhkgyzgvu2r22m.appsync-api.us-west-2.amazonaws.com/graphql",
                        "Region": "us-west-2",
                        "AuthMode": "AMAZON_COGNITO_USER_POOLS",
                        "ClientDatabasePrefix": "family-connect-api-development_AMAZON_COGNITO_USER_POOLS"
                    },
                    "family-connect-api-development_AWS_IAM": {
                        "ApiUrl": "https://tc3sw6ndxnefzhkgyzgvu2r22m.appsync-api.us-west-2.amazonaws.com/graphql",
                        "Region": "us-west-2",
                        "AuthMode": "AWS_IAM",
                        "ClientDatabasePrefix": "family-connect-api-development_AWS_IAM"
                    },
                    "family-connect-api-development_API_KEY": {
                        "ApiUrl": "https://tc3sw6ndxnefzhkgyzgvu2r22m.appsync-api.us-west-2.amazonaws.com/graphql",
                        "Region": "us-west-2",
                        "AuthMode": "API_KEY",
                        "ApiKey": "da2-34x7gehkr5a4bn4vzw44n6awwu",
                        "ClientDatabasePrefix": "family-connect-api-development_API_KEY"
                    }
                }
            }
        }
    },
    "storage": {
        "plugins": {
            "awsS3StoragePlugin": {
                "bucket": "mobex-health-hub-internal-data-us-west-2",
                "region": "us-west-2",
                "defaultAccessLevel": "guest"
            }
        }
    }
}''';