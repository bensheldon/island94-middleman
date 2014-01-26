Island94 Middleman
========================

[![Build Status](https://travis-ci.org/bensheldon/island94-middleman.png?branch=master)](https://travis-ci.org/bensheldon/island94-middleman)

A middle-man based single page static website that automatically deploys to an s3 bucket via Travis-CI.

Installation & usage
--------------------

Install:

```
bundle install
```

Run:

```
bundle exec middleman
```

...and open the browser to [http://0.0.0.0:4567](http://0.0.0.0:4567)


Deployment
----------

Any commits pushed to the `master` branch are automatically built and deployed to an s3 bucket using travis-ci.

Duplicating joyful deployments
-----------------------------

This was accomplished with a combination of:

1. Creating an AWS S3 bucket
2. Creating a new Amazon User through the IAM panel with a custom group policy locked to the bucket because you probably shouldn't put your main AWS users credentials in Travis (even if encrypted); and be sue to include both the `/` and `/*` permisisons for the bucket resource:

        {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Action": [
                "s3:*"
              ],
              "Sid": "Stmt1383882348000",
              "Resource": [
                "arn:aws:s3:::island94.org"
              ],
              "Effect": "Allow"
            },
            {
              "Action": [
                "s3:*"
              ],
              "Sid": "Stmt1383882349000",
              "Resource": [
                "arn:aws:s3:::island94.org/*"
              ],
              "Effect": "Allow"
            }
          ]
        }

3. Telling Travis-CI to watch this Github repository
4. Using the [travis CLI gem](https://rubygems.org/gems/travis) to encrypt the AWS user credentials as environment variables (check out the [`.env.sample`](.env.sample) file):

        $ travis encrypt AWS_ACCESS_KEY_ID=The0Key1Master --add
        $ travis encrypt AWS_SECRET_ACCESS_KEY=Your2Precious3Secrets --add
5. Configuring the `s3_sync` configuration in `config.rb` to point to your s3 bucket.
6. Commit, push, pray.
