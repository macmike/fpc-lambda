uses
  fpjson, jsonparser, sysutils;

var
  lambdaEventData: TJSONData;
  lambdaEvent: TJSONObject;
  nameParameter, outputJSON: string;
begin
  //get incoming JSON and parse
  lambdaEventData := GetJSON(ParamStr(1));

  // cast as TJSONObject to make access easier
  lambdaEvent := TJSONObject(lambdaEventData);

  nameParameter := lambdaEvent.Get('name');
  outputJSON := format('{"status":"200", "message":"hello %s from fpc lambda"}',[nameParameter]);
  WriteLn(outputJSON);

end.
