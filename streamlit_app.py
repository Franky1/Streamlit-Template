import streamlit as st
from utils.helpers import get_greeting

# Set the page configuration
# This is a good practice to do this at the top of the script.
# See: https://docs.streamlit.io/library/api-reference/utilities/st.set_page_config
st.set_page_config(
    page_title="Streamlit Template",
    page_icon="👋",
    layout="centered",
    initial_sidebar_state="expanded",
)

# It is also a good practice to use a main function to structure your app.
def main():
    """
    This is the main function of the Streamlit app.
    """

    st.title("👋 Welcome to the Streamlit Template!")

    st.markdown(
        """
        This template is a starting point for building your own Streamlit apps.
        It includes a basic structure, example code, and best practices.

        ### Get Started

        - **Edit `streamlit_app.py`** to customize this main page.
        - **Add new pages** in the `pages/` directory.
        - **Use `utils/`** for your helper functions.

        ### More Information

        - [Streamlit Documentation](https://docs.streamlit.io)
        - [Streamlit Cheat Sheet](https://docs.streamlit.io/library/cheatsheet)
    """
    )

    # Example of using st.session_state to store data across reruns.
    # See: https://docs.streamlit.io/library/api-reference/session-state
    if "counter" not in st.session_state:
        st.session_state.counter = 0

    st.write("---")
    st.header("Example: Using Session State")

    if st.button("Increment Counter"):
        st.session_state.counter += 1

    st.write(f"Counter: {st.session_state.counter}")

    # You can also use st.form to group widgets and submit them together.
    # See: https://docs.streamlit.io/library/api-reference/control-flow/st.form
    st.write("---")
    st.header("Example: Using a Form")

    with st.form("my_form"):
        name = st.text_input("Enter your name")
        submitted = st.form_submit_button("Submit")

        if submitted:
            st.write(get_greeting(name))


if __name__ == "__main__":
    main()
