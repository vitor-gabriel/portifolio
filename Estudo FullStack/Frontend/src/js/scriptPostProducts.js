// captura o elemento form
document.addEventListener("DOMContentLoaded", async e => {
    var form = document.getElementById("form")

    form.addEventListener("submit", async function (event) {
        // cancela o envio do form
        event.preventDefault()
        // captura o valor do input
        const prePayload = new FormData(form)
        const payload = new URLSearchParams(prePayload)

        try {
            // envia o valor do input para o backend
            const response = await fetch("http://192.168.199.37:8081/rest/api/v2/custom/products", {
                method: "POST",
                body: payload,
            });
            const data = await response.json();
            console.log(data);
            alert("Produto cadastrado com sucesso!")
            window.location.href = "../html/index.html"
        } catch (error) {
            alert("Erro ao cadastrar produto!")
            console.error(error);
        }
    });
});