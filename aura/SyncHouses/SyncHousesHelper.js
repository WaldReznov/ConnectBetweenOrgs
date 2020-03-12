({
    syncHousesHelper : function(component, event, helper) {
        let action = component.get('c.houseActions');

        action.setParams({
            method: 'upsert'
        });

        action.setCallback(this,$A.getCallback(function (response) {
            let state = response.getState();

            if (state === 'SUCCESS') {
                console.log('Success');
            } else if (state === "ERROR") {
                let errors = response.getError();
                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        }));

        $A.enqueueAction(action);
    },

    deleteHousesHelper : function(component, event, helper) {
        let action = component.get('c.houseActions');

        action.setParams({
            method: 'delete'
        });

        action.setCallback(this,$A.getCallback(function (response) {
            let state = response.getState();

            if (state === 'SUCCESS') {
                console.log('Success');
            } else if (state === "ERROR") {
                let errors = response.getError();

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        }));

        $A.enqueueAction(action);
    }
})