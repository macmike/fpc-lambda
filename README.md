# AWS Lambda Custom Runtime for Free Pascal / Delphi

At [AWS Reinvent 2018](https://reinvent.awsevents.com/), Werner Vogels said it was now possible to use any language in AWS Lambda. I thought I’d put that to the test!

I thought it’d be interesting to add lambda support for Pascal, specifically the FreePascal variant found with Lazarus (the free, cross-platform version of Delphi). Mainly because it doesn’t really fit, it’s a compiled language, but I do have a remaining soft spot for the Lazarus project so I thought I’d give it a go.

**Fair warning,** this doesn’t make ton’s of sense. As a compiled language, you can’t initialise things in the runtime and then call them from multiple instances of functions, it also doesn’t deliver an amazing cold-start experience since it needs compiling on each run.

But… it does work! I based this on an [AWS tutorial for creating a custom bash runtime](https://docs.aws.amazon.com/lambda/latest/dg/runtimes-walkthrough.html).

You can write a Pascal lambda function like this (save it as **function.pas**):

    begin
     writeln('{"status":"200", "message":"hello from fpc lambda"}');
    end.

Then, upload as a lambda function (using your own lambda-role) using this custom runtime:

    zip function.zip ./function.pas
    aws lambda create-function --function-name fpc-hello --zip-file fileb://function.zip --handler function.handler --role arn:aws:iam::<your-id>:role/lambda-role --runtime provided --layers arn:aws:lambda:eu-west-1:743697633610:layer:fpc-runtime:20 

Finally, invoke the function like this:

    aws lambda invoke --function-name fpc-hello --payload '{"text":"Hello"}' response.txt
    cat response.txt

Or from the AWS console:


For more detail [see my blog](https://mikemacd.wordpress.com).

## [fpc-hello](/fpc-hello)
The example above, including build and run scripts

## [fpc-lambda-event](/fpc-lambda-event)
A more detailed detailed function that parses payload JSON and responds with custom JSON.

## [fpc-runtime](/fpc-runtime)
The code, configuration, files and build scripts for creating the runtime. Note that I've simply put a chunk of units in the **fpc-runtime/fpc3/lib/fpc/3.0.0/units/x86_64-linux** [folder](/fpc-runtime/fpc3/lib/fpc/3.0.0/units/x86_64-linux), which is a mix of the traditional FPC lib units and fpc-src packages (required to work with JSON). I've left a lot of bloat in here, and the **fpc-runtime/fpc3/bin** folder which could be removed to streamline fpc-lambda.
