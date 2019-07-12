import dredd_hooks as hooks


@hooks.before("/blambda > GET > 500 > application/json")
def before_blambda_put_500(transaction):
    transaction["skip"] = True
