### Build
```
docker build -t easy_ocr.web .
```

### Run
```
docker run -it --rm -p 8001:8080 easy_ocr.web bash
docker run -d --rm -p 8001:8080 easy_ocr.web
```

### Request
http://localhost:8001/ocr?image_url=https://raw.githubusercontent.com/JaidedAI/EasyOCR/master/examples/korean.png
```

curl -X POST -H "Content-Type: application/json" \
-d " \
{ \
 \"image_url\":\"https://raw.githubusercontent.com/JaidedAI/EasyOCR/master/examples/chinese.jpg\" \
}\
" \
http://localhost:8001/ocr
```