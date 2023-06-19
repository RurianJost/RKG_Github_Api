const express = require('express')

const app = express()

const LANGUAGE = {
    CALLBACK: 'Ensure realizado!',
    API_RUNNING: '^5RKG_Api running^0',
    CANNOT_STOP_RESOURCE: `Resource ^9{0}^0 can't be ^1stopped^0`,
    CANNOT_START_RESOURCE: `^1Unable to start^0 resource ^9{0}^0`,
    RESOURCE_STARTED: `Resource ^9{0}^0 successfully ^2started^0`,
    RESOURCE_RESTARTED: `Resource ^9{0}^0 successfully ^3restarted^0`,
    ERROR_RECEIVING_RESOURCE_NAME: '^1Error receiving resource name^0',
    CANNOT_FIND_RESOURCE: `Could not find ^1{0}^0 in the resourceName list`
}

const BLOCKED_RESOURCES = {
    'vrp': true,
    'RKG_Api': true,
    'oxmysql': true
}

app.use(express.json())

app.get('/', (req, res) => {
    const data = req.query.resources

    if (!data) {
        console.log(LANGUAGE.ERROR_RECEIVING_RESOURCE_NAME)
    } else {
        const args = data.split(',')

        setImmediate(() => {
            for (resourceName of args) {
                resourceName = resourceName.trim()

                if (BLOCKED_RESOURCES[resourceName]) {
                    const text = LANGUAGE.CANNOT_STOP_RESOURCE.format(resourceName)
                
                    emit('RKG_Api:Notify', text)
                } else {
                    const resourceState = GetResourceState(resourceName)
            
                    if (resourceState != 'unknown' && resourceState != 'missing') {
                        let text = LANGUAGE.RESOURCE_STARTED.format(resourceName)
        
                        if (resourceState == 'started') {
                            const stoped = StopResource(resourceName)

                            if (stoped) {
                                text = LANGUAGE.RESOURCE_RESTARTED.format(resourceName)
                            }
                        }
        
                        const started = StartResource(resourceName)

                        if (!started) {
                            text = LANGUAGE.CANNOT_START_RESOURCE.format(resourceName)
                        }

                        emit('RKG_Api:Notify', text)
                    } else {
                        const text = LANGUAGE.CANNOT_FIND_RESOURCE.format(resourceName)
        
                        emit('RKG_Api:Notify', text)
                    }
                }
            }
        })

        res.status(201).json(LANGUAGE.CALLBACK)
    }
})

app.listen(5000, (() => {
    console.log(LANGUAGE.API_RUNNING)
}))

String.prototype.format = function() {
    a = this
   
    for (index in arguments) {
        a = a.replace('{' + index + '}', arguments[index])
    }

    return a
}