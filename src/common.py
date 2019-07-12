import json


def hello_func(name):
    msg = "HELLO FROM %s" % name.upper()
    return json.dumps({"message": msg})
