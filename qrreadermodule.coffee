############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("qrreadermodule")
#endregion

############################################################
import QRScanner from "qr-scanner"
import * as msgBox from "./messageboxmodule.js"
import * as utl from "./utilsmodule.js"

############################################################
currentReader = null
currentResolver = null
hasCamera = false

############################################################
export initialize = ->
    log "qrreadermodule.initialize"
    hasCamera = await QRScanner.hasCamera()
    log hasCamera
    return unless hasCamera
    
    options = 
        maxScansPerSecond: 5
        highlightCodeOutline: true

    #qrreaderVideoElement.
    currentReader = new QRScanner(qrreaderVideoElement, dataRead, options)

    qrreaderBackground.addEventListener("click", readerClicked)
    return

############################################################
dataRead = (data) ->
    log "dataRead"
    data = data.data
    log data.length
    olog data
    if data.length == 64 and currentResolver?
        currentResolver(data)
        currentResolver = null
        currentReader.stop()
        qrreaderBackground.classList.remove("active")
        return
    if data.length == 66 and currentResolver? and data[0] == '0' and data[1] == 'x'
        data = utl.strip0x(data)
        currentResolver(data)
        currentResolver = null
        currentReader.stop()
        qrreaderBackground.classList.remove("active")
        return
    
    ## else
    msgBox.error("Unknown Format!")
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

    
