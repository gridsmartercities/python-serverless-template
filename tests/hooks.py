import dredd_hooks as hooks


@hooks.before_each
def un_skip(transaction):
    transaction["skip"] = False


@hooks.before("/Prod/alambda > GET > 500 > application/json")
def before_alambda_put_500(transaction):
    transaction["skip"] = True


@hooks.before("/Prod/blambda > GET > 500 > application/json")
def before_blambda_put_500(transaction):
    transaction["skip"] = True
