def hello_func(name: str) -> dict:
    msg = "HELLO FROM %s" % name.upper()
    return {"message": msg}
