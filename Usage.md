<!-- markdownlint-disable MD026 -->
# :wrench: Usage

This template is designed for Python 3.11 and Streamlit 1.38.0.

> :point_right: *You can delete this file before committing your project to GitHub.*

## Project Structure

- `streamlit_app.py`: The main entry point for your Streamlit application.
- `pages/`: Directory for additional pages in your multipage app.
- `utils/`: For helper functions and other modules.
- `assets/`: For static assets like images, css files, etc.
- `requirements.txt`: Python dependencies.
- `packages.txt`: System-level dependencies for Docker.

## Local Development

You can develop your app locally using either a Python virtual environment or Docker.

### Python Virtual Environment

1.  **Create and activate a virtual environment:**
    ```bash
    python -m venv .venv
    source .venv/bin/activate  # On Windows, use `.venv\Scripts\activate`
    ```
2.  **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```
3.  **Run the app:**
    ```bash
    streamlit run streamlit_app.py
    ```

### Docker

1.  **Build the Docker image:**
    ```bash
    docker build -t streamlit-app .
    ```
2.  **Run the Docker container:**
    ```bash
    docker run -p 8501:8501 streamlit-app
    ```

## Multipage Apps

To create a multipage app, simply add more Python files to the `pages/` directory. Each file will appear as a new page in the sidebar. For more details, see the [Streamlit documentation on multipage apps](https://docs.streamlit.io/library/get-started/multipage-apps).

## Deployment

This template is ready to be deployed to [Streamlit Community Cloud](https://streamlit.io/cloud). Connect your GitHub repository to Streamlit Cloud and deploy your app with a few clicks.

## Customization

- **Add Python packages:** Add them to `requirements.txt`.
- **Add system-level packages:** Add them to `packages.txt` and uncomment the relevant lines in the `Dockerfile`.
- **Add custom CSS:** Edit `assets/styles/style.css` and uncomment the corresponding lines in `streamlit_app.py`.

## :heavy_check_mark: Status

> Last changed: 2025-09-06
