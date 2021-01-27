BIN_DIR = "python_install"

def _impl(ctx):
    """Downloads the python source code for and compiles with make on the host system."""
    ctx.report_progress("Fetching python source")
    VERSION = "3.7.9"
    PREFIX = "Python-%s" % VERSION
    ctx.download_and_extract(
        url = ["https://www.python.org/ftp/python/%s/%s.tgz" % (VERSION, PREFIX)],
        sha256 = "39b018bc7d8a165e59aa827d9ae45c45901739b0bbb13721e4f973f3521c166a",
        stripPrefix = PREFIX,
    )
    ctx.report_progress("Configuring")
    configure_args = ["./configure", "--prefix=" + str(ctx.path(BIN_DIR))]
    if "mac" in ctx.os.name:
        brew_ssl = ctx.execute(["/usr/bin/env", "brew", "--prefix", "openssl"])
        if brew_ssl.return_code != 0:
            fail("Could not get openssl prefix from brew")
        configure_args.append("--with-openssl=" + brew_ssl.stdout.strip())
    ctx.execute(
        configure_args,
    )
    ctx.report_progress("Compiling python")
    ctx.execute(
        ["make", "install", "-j4"],
    )

    # expose the compiled version of all files via a BUILD file
    ctx.file(
        str(ctx.path(BIN_DIR).get_child("BUILD")),
        """
# All "installed" files, for py_runtime
filegroup(
    name = "files",
    # Include all files, except files with spaces (those don't matter anyway)
    srcs = glob(["**"], exclude=["**/* *"]),
    visibility = ["//visibility:public"],
)
""",
    )

    # Expose the main binary for py_runtime
    ctx.file(
        str(ctx.path(BIN_DIR).get_child("bin").get_child("BUILD")),
        """
# Main interpreter binary, for python toolchain
exports_files(["python3"])
""",
    )

python_repo = repository_rule(
    implementation = _impl,
)
