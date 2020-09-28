
export default {
    delete : function(id) {
        fetch('/api/v1/tins/' + id,{
            method: 'DELETE',
            headers: {
            }
        })
        .then( response => response)
        .then( response => {
            document.getElementById("tin-row-" + id ).remove();
            console.log(json)
        }).catch(err => {
            console.log(err)
        });
    },

    test: function() {
        fetch('/admin').then( response => console.log(response))
    },

    banByTin: function(id) {
        let time = parseInt(document.querySelector("#tin-row-bantime-" + id).value,10);
        let data = {time: time};
        fetch('/api/v1/banned/' + id,{
            method: 'POST',
            headers: {
            },
            body: JSON.stringify(data)
        })
        .then( response => response.json())
        .then( json => {
            alert("Успешно");
            console.log(json);
        }).catch(err => {
            console.log(err)
        });
    },

    unbanByIp: function(ip) {
        fetch('/api/v1/banned/' + ip,{
            method: 'DELETE',
            headers: {
            }
        })
        .then( response => response.json())
        .then( json => {
            document.getElementById("banned-row-" + ip ).remove();
            console.log(json)
        }).catch(err => {
            console.log(err)
        });
    }
}
