import subprocess
import sys
import os
from flask import Flask, request, jsonify, render_template_string

# Function to check if pip is installed
def check_pip_installed():
    try:
        subprocess.check_call([sys.executable, "-m", "pip", "--version"])
        print("pip is already installed.")
    except subprocess.CalledProcessError:
        print("pip not found, installing pip using apt...")
        # Attempt to install pip via apt
        subprocess.check_call(["sudo", "apt", "update"])
        subprocess.check_call(["sudo", "apt", "install", "-y", "python3-pip"])

# Function to check if Flask is installed
def check_flask_installed():
    try:
        import flask
        print("Flask is already installed.")
    except ImportError:
        print("Flask not found. Checking for system-wide installation...")
        
        # Check if Flask is available via apt
        try:
            print("Attempting to install Flask using apt...")
            subprocess.check_call(["sudo", "apt", "update"])
            subprocess.check_call(["sudo", "apt", "install", "-y", "python3-flask"])
            print("Flask installed using apt.")
        except subprocess.CalledProcessError as e:
            print(f"Error installing Flask with apt: {e}")
            sys.exit(1)

# Check and install pip and Flask if necessary
check_pip_installed()
check_flask_installed()

# Define the path to your shell scripts
SCRIPTS_PATH = "/path/to/your/scripts"  # Adjust this path accordingly

# Initialize Flask app
app = Flask(__name__)

# Home route to render the HTML form
@app.route('/')
def index():
    return render_template_string(open('index.html').read())  # Make sure your HTML file is named 'index.html'

# Route to handle the VDI conversion form submission
@app.route('/convert_vdi', methods=['POST'])
def convert_vdi():
    vdi_file = request.form.get('vdi-file')
    output_name = request.form.get('output-name')
    output_format = request.form.get('output-format')

    # Ensure the input file exists
    if not os.path.isfile(vdi_file):
        return jsonify({"error": "VDI file does not exist"}), 400
    
    # Construct the command
    script = os.path.join(SCRIPTS_PATH, 'convert_vdi.sh')
    cmd = f"bash {script} {vdi_file} {output_name} {output_format}"

    try:
        # Run the shell script
        result = subprocess.run(cmd, shell=True, check=True, capture_output=True, text=True)
        return jsonify({"message": result.stdout})
    except subprocess.CalledProcessError as e:
        return jsonify({"error": e.stderr}), 500

# Route to handle the disk import form submission
@app.route('/import_disk', methods=['POST'])
def import_disk():
    vm_name = request.form.get('vm-name')
    disk_name = request.form.get('disk-name')
    storage_id = request.form.get('storage-id')

    script = os.path.join(SCRIPTS_PATH, 'import_disk-new.sh')
    cmd = f"bash {script} {vm_name} {disk_name} {storage_id}"

    try:
        result = subprocess.run(cmd, shell=True, check=True, capture_output=True, text=True)
        return jsonify({"message": result.stdout})
    except subprocess.CalledProcessError as e:
        return jsonify({"error": e.stderr}), 500

# Route to handle the OVF import form submission
@app.route('/import_ovf', methods=['POST'])
def import_ovf():
    vm_id = request.form.get('vm-id')
    ovf_file = request.form.get('ovf-file')
    vm_name = request.form.get('vm-name')
    storage = request.form.get('storage')
    network_bridge = request.form.get('network-bridge')
    cpu_cores = request.form.get('cpu-cores', 1)
    memory = request.form.get('memory', 1024)

    script = os.path.join(SCRIPTS_PATH, 'import_ovf.sh')
    cmd = f"bash {script} {vm_id} {ovf_file} {vm_name} {storage} {network_bridge} {cpu_cores} {memory}"

    try:
        result = subprocess.run(cmd, shell=True, check=True, capture_output=True, text=True)
        return jsonify({"message": result.stdout})
    except subprocess.CalledProcessError as e:
        return jsonify({"error": e.stderr}), 500

# Error handler for 404
@app.errorhandler(404)
def page_not_found(e):
    return jsonify({"error": "Page not found"}), 404

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
