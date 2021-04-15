qrreadermodule = {name: "qrreadermodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["qrreadermodule"]?  then console.log "[qrreadermodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
QRScanner = require("qr-scanner").default
msgBox = null

############################################################
currentReader = null
currentResolver = null
hasCamera = false

############################################################
qrreadermodule.initialize = ->
    log "qrreadermodule.initialize"
    msgBox = allModules.messageboxmodule

    QRScanner.WORKER_PATH = "/scannerworker.js"
    hasCamera = await QRScanner.hasCamera()
    log hasCamera
    
    return unless hasCamera
    #qrreaderVideoElement.
    currentReader = new QRScanner(qrreaderVideoElement, dataRead)

    qrreaderBackground.addEventListener("click", readerClicked)
    return


############################################################
dataRead = (data) ->
    log "dataRead"
    log data.length
    if data.length == 64 and currentResolver?
        currentResolver(data)
        currentResolver = null
        currentReader.stop()
        qrreaderBackground.classList.remove("active")
    return

readerClicked = ->
    log "readerClicked"
    currentReader.stop()
    if currentResolver? then currentResolver(null)
    currentResolver = null
    qrreaderBackground.classList.remove("active")
    return


############################################################
qrreadermodule.read = ->
    log "qrreadermodule.read"
    if !hasCamera
        msgBox.error("We don't have a Camera!")
        return

    currentReader.start()
    qrreaderBackground.classList.add("active")

    return new Promise (resolve) -> currentResolver = resolve

    
module.exports = qrreadermodule