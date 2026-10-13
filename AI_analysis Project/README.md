# Retail Insights Dashboard

A responsive sales dashboard built with Flask and HTML. It reads the
`cleaned_sales.csv` file created by the analysis notebook and displays key
metrics, monthly sales, sales by category, leading products, supplier
concentration, and a retail-versus-warehouse product scatter plot. Months
without records are shown as gaps instead of zero-sales months. A floating
chatbot answers questions about the analysis using the dashboard's calculated
data and can also answer general questions with Gemini.

Sales figures represent recorded quantities, not money.

## Run it locally

1. Install Python 3.10 or newer.
2. Create a Gemini API key in [Google AI Studio](https://aistudio.google.com/apikey).
3. From this project folder, install the dependencies and set the API key in the
   same terminal session that will run the app. In Windows PowerShell, run:

   ```powershell
   py -m venv .venv
   .\.venv\Scripts\Activate.ps1
   pip install -r requirements.txt
   $env:GEMINI_API_KEY = "your-key"
   python app.py
   ```

   Or, instead of setting a terminal variable, create a `.env` file in the
   project folder containing `GEMINI_API_KEY=your-key`, then start the app.

   In Bash (Linux, macOS, or Git Bash), use:

   ```bash
   python -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   export GEMINI_API_KEY="your-key"
   python app.py
   ```

4. Keep the terminal window open while using the site, then open
   <http://127.0.0.1:5000> in Chrome or another browser. The chatbot sends each
   question and its conversation history to Gemini, along with the dashboard
   analysis context. This supports analysis questions, natural follow-ups, and
   general questions. A valid API key is required for all chatbot answers.

The app reads `GEMINI_API_KEY` from the server environment and never exposes it
to browser code. Never add the actual key to this project or commit it to
GitHub. You can optionally set `GEMINI_MODEL` to another model available to
your API key; by default the app uses `gemini-3.8-flash`.

Keep `cleaned_sales.csv` in the project folder. Regenerate it by running the
notebook's cleaning and analysis steps when you update the source data.

## Deploying

GitHub stores the source code but GitHub Pages cannot run the Python backend.
Deploy the project to a Python web host, include `cleaned_sales.csv`, set
`GEMINI_API_KEY` in that host's private environment-variable settings, and use:

- Build command: `pip install -r requirements.txt`
- Start command: `gunicorn app:app`

Gemini API use may incur charges or be subject to service limits. Review your
Google AI Studio usage and limits before sharing a public deployment.
