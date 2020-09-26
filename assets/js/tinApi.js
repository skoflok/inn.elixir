
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
    }
}
