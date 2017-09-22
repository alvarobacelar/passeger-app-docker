# Image for appllication with passeger

Copy your aplication for path passeger-app
```code 
# cp app /home/passeger-app
```

Bild image
```code
# docker build -t image-name .
```

Run container with image created
```code
# docker run -dit --name you-application -p 80:80 --env=''
```
