############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("qrreadermodule")
#endregion

############################################################
import QRScanner from "qr-scanner"
msgBox = null

############################################################
currentReader = null
currentResolver = null
hasCamera = false

############################################################
export initialize = ->
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
export read = ->
    log "qrreadermodule.read"
    if !hasCamera
        msgBox.error("We don't have a Camera!")
        return

    currentReader.start()
    qrreaderBackground.classList.add("active")

    return new Promise (resolve) -> currentResolver = resolve

    
