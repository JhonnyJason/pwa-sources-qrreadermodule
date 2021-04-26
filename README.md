###### tags: `strunfun`

# [pwa-sources-qrreadermodule](https://github.com/JhonnyJason/pwa-sources-qrreadermodule) - qrreadermodule

## Description
Component to read specific information from a QR-Code

## Expectation to the Environment
- QRScanner = require("[qr-scanner](https://www.npmjs.com/package/qr-scanner").default
- video element available in the DOM which looks like this:
    ```pug
    #qrreader-background
        video#qrreader-video-element
    ```
- `qrreaderBackground°` available
- [messageboxmodule](https://hackmd.io/sHf9p8mPS_yEh35_NxHeaw?view) available
- [serviceworker](https://github.com/nimiq/qr-scanner/blob/master/qr-scanner-worker.min.js) available at `/scannerworker.js`

## Structure
- `QRScanner°`
- `msgBox°`
- `currentReader°`
- `currentResolver°`
- `hasCamera?`
- `qrreaderBackground°`
- `dataRead§`
- `readerClicked§`
- `.initialize§`
- `.read§`

## Specification
- `QRScanner°` = the [qr-scanner](https://www.npmjs.com/package/qr-scanner") module default import
- `msgBox°` = the [messageboxmodule](https://hackmd.io/sHf9p8mPS_yEh35_NxHeaw?view) from `allModules.messageboxmodule`
- `currentReader°` = instance of the `QRScanner` object = `new QRScanner(qrreaderVideoElement°, dataRead§)`
- `currentResolver°` = deferred promise resolver as handle to stop "blocking" as soon as we are done
- `hasCamera?` = indicator if we have any camera available
- `qrreaderBackground°` = JS object for the DOM element `qreader-background`
- `dataRead§` = callback for the QRScanner - is being called when it was able to read any data -> stops scanning for a QR-code, passes the read data to the resolver, and removes class `active` from `qrreaderBackground°`
- `readerClicked§` = callback on click - stops scanning for QR-code, passes `null` to the resolver and removes class`active` from `qrreaderBackground`  
- `.initialize§` = links up QRScanner with the `/scannerworked.js`, checks for camera and sets `hasCamera?` appropriately if we have a camera then it creates the `currentReader°` instance and links up the `readerClicked§` with the click event of the `qrreaderBackground°`
- `.read§` = the main service to the outside world - returns a promise which will either resolve with the data read or null when cancelled oor it returns undefined and writes an errormessage to `msgBox°` for the case we don't have any camera available
