# Always prefer setuptools over distutils
from setuptools import setup, find_packages

setup(
    name="single_function_caller_elimination",
    version="1.0",
    description="""Python program that eliminates callers that call only a
    single function from the call graph""",
    author="André Silva Telles",
    py_modules=["main"],
    entry_points={
        "console_scripts":{
            "eliminate_singles=main:main"
        }
    }
)
