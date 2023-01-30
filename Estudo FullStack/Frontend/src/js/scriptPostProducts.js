// captura o elemento form
document.addEventListener("DOMContentLoaded", e => {
    var form = document.getElementById("form")

    form.addEventListener("submit", function (event) {
        // cancela o envio do form
        event.preventDefault()
        // captura o valor do input
        const prePayload = new FormData(form)
        const payload = new URLSearchParams(prePayload)

        // envia o valor do input para o backend
        fetch("http://localhost:8081/rest/api/v2/products/", {
            method: "POST",
            body: payload,
        }).then(response => {
            return response.json()
        }).then(data => {
            console.log(data)
        }).catch(error => {
            console.log(error)
        })
        window.location.href = "../html/index.html"
    })
});