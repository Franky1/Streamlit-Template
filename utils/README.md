# Utilities

This directory is intended for Python utility functions and modules that can be used across your Streamlit app.

## Example

You can create a helper module, for example `utils/helpers.py`:

```python
# utils/helpers.py

def get_greeting(name: str) -> str:
    """
    Returns a greeting string for the given name.
    """
    return f"Hello, {name}!"
```

And then import it in your main app or any page:

```python
# streamlit_app.py

from utils.helpers import get_greeting

name = "Streamlit"
greeting = get_greeting(name)
st.write(greeting)
```
