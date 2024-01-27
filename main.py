from flask import Flask, request, jsonify
import easyocr

app = Flask(__name__)

@app.route('/ocr', methods=['GET', 'POST'])
def ocr():
  reader = easyocr.Reader(['en'])
  if request.method == "POST":
    image_url = request.json['image_url']
  elif request.method == "GET":
    image_url = request.args.get('image_url')
  result = reader.readtext(image_url)
  # return jsonify(result)
  return str(result)

@app.route('/hello')
def hello():
    return 'world'
    
if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=8080)