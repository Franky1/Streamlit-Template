import streamlit as st


# set basic page config
st.set_page_config(page_title="Streamlit Template",
                    page_icon='✅',
                    layout='centered',
                    initial_sidebar_state='collapsed')

# apply custom css if needed
# with open('assets/styles/style.css') as css:
#     st.markdown(f'<style>{css.read()}</style>', unsafe_allow_html=True)


if __name__ == "__main__":
    st.title('🔨 Streamlit Template')
    st.markdown("""
        This app is only a template for a new Streamlit project. <br>

        ---
        """, unsafe_allow_html=True)

    st.balloons()
