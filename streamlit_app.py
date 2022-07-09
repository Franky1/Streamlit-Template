import streamlit as st


if __name__ == "__main__":
    st.set_page_config(page_title="Streamlit Template",
                    page_icon='✅',
                    initial_sidebar_state='collapsed')
    st.title('🔨 Streamlit Template')
    st.markdown("""
        This app is only a template for a new Streamlit project. <br>

        ---
        """, unsafe_allow_html=True)

    st.balloons()
