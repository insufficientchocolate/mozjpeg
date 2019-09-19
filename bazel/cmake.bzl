def _expand_cmake_substitution(variables):
    expanded = {}
    for k, v in variables.items():
        if v == "0":
            expanded["#cmakedefine %s" % (k)] = "/* #undef %s %s */" % (k, v)
        else:
            expanded["#cmakedefine %s" % (k)] = "#define %s " % (k)
        expanded["@%s@" % (k)] = v
    return expanded

def _impl(ctx):
    ctx.actions.expand_template(
        template = ctx.file.src,
        output = ctx.outputs.out,
        substitutions = _expand_cmake_substitution(ctx.attr.variables),
    )

cmake_config = rule(
    implementation = _impl,
    attrs = {
        "src": attr.label(mandatory = True, allow_single_file = True),
        "out": attr.output(mandatory = True),
        "variables": attr.string_dict(),
    },
)
