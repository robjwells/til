# pytest parameterized test cases can have custom descriptions

By default Pytest's parameterized tests will automatically generate test case descriptions for the test output, which are logical but not descriptive.

However, you can supply (as the `ids` argument) a sequence of custom names that describe the test case.

For example, given this synthetic example of a broken test for addition:

```python
import pytest

@pytest.mark.parametrize(
    "a,b,expected",
    [
        (0, 1, 1),
        (1, 1, 2),
        (-1, 1, 0),
        (1, -1, 0),
    ],
)
def test_add(a: int, b: int, expected: int) -> None:
    assert False
```

You get the following summmary:

```
FAILED test_list.py::test_add[0-1-1] - assert False
FAILED test_list.py::test_add[1-1-2] - assert False
FAILED test_list.py::test_add[-1-1-0] - assert False
FAILED test_list.py::test_add[1--1-0] - assert False
```

Where the text in the square brackets is the automatically generated description, with the arguments separated by hyphens (for less primitive arguments you see the argument names with a suffix).

It’s not always obvious from the test data what the test case is verifying, though. This is where supplying `ids` comes in.

We can write the test as follows (also taking advantage of the fact that the argument names can be a sequence of strings):

```python
import pytest

add_arguments = {
    "zero plus x is x": (0, 1, 1),
    "one plus one is two": (1, 1, 2),
    "x plus -x is zero": (-1, 1, 0),
    "-x plus x is zero": (1, -1, 0),
}

@pytest.mark.parametrize(
    argnames=["a", "b", "expected"],
    argvalues=add_arguments.values(),
    ids=add_arguments.keys(),
)
def test_add(a: int, b: int, expected: int) -> None:
    assert False
```

And we get the following summary from pytest:

```
FAILED test_list.py::test_add[zero plus x is x] - assert False
FAILED test_list.py::test_add[one plus one is two] - assert False
FAILED test_list.py::test_add[x plus -x is zero] - assert False
FAILED test_list.py::test_add[-x plus x is zero] - assert False
```

Note that `parameterize` matches each group of argument values with its ID based on its index in the sequence.

[See the docs for (the underlying implementation of) `pytest.mark.parametrize`][docs].

## Update 2021-02-20 18:26

There is also the [`pytest.param`][param] function, which you can use inline like so:

```python
@pytest.mark.parametrize(
    argnames=["a", "b", "expected"],
    argvalues=[
        pytest.param(0, 1, 1, id="zero plus x is x"),
        pytest.param(1, 1, 2, id="one plus one is two"),
        pytest.param(-1, 1, 0, id="x plus -x is zero"),
        pytest.param(1, -1, 0, id="-x plus x is zero"),
    ]
)
def test_add(a: int, b: int, expected: int) -> None:
    assert False
```

Though I’m not sure this is necessarily more clear than the dictionary approach above.

[docs]: https://docs.pytest.org/en/stable/reference.html#pytest.python.Metafunc.parametrize
[param]: https://docs.pytest.org/en/stable/reference.html?highlight=pytest%20param#pytest.param

#til #til-python #pytest

