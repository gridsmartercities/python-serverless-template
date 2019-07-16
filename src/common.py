import json


def hello_func(name):
    msg = "HELLO FROM %s" % name.upper()
    return {"message": msg}
