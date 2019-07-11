import dredd_hooks as hooks


@hooks.before("/alambda > GET > 500 > application/json")
def before_alambda_put_500(transaction):
    transaction["skip"] = True
