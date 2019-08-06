import dredd_hooks as hooks


@hooks.before("/alambda > GET > 500 > application/json")
def before_a_lambda_get_500(transaction):
    transaction["skip"] = True
