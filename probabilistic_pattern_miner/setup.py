# Always prefer setuptools over distutils
from setuptools import setup, find_packages

setup(
    name="probabilistic_pattern_miner_formatters",
    version="1.0",
    description="""Python project that formats the input and output data to
    interact with the probabilistic api miner""",
    author="André Silva Telles",
    py_modules=["format_input", "format_output"],
    entry_points={
        "console_scripts":{
            "format_input=format_input:main",
            "format_output=format_output:main"
        }
    }
)
