//listar produtos na tela
document.addEventListener("DOMContentLoaded", async e => {
    //pega os produtos
    let products;
    await getProducts().then(response => { products = response.produtos });
    //captura a tabela
    const table = document.getElementById('table-products');
    table.innerHTML = '';
    //percorre o array de produtos
    if (typeof products === 'object') {
        table.innerHTML = `
        <div class="container">
        <table class="table table-striped table-hover" id="table-products">
            <thead>
                <tr>
                    <th scope="col">Code</th>
                    <th scope="col">Description</th>
                    <th scope="col">Type</th>
                    <th scope="col">Unit</th>
                    <th scope="col">Stock</th>
                    <th scope="col">Addressing</th>
                    <th scope="col">Buttons</th>
                </tr>
            </thead>
            <tbody>'`;
        // loop no array de produtos do backend
        products.forEach(product => {
            table.innerHTML += `
                <tr>
                    <th scope="row">${product.code}</th>
                    <td>${product.description}</td>
                    <td>${product.type}</td>
                    <td>${product.unit}</td>
                    <td>${product.stock}</td>
                    <td>${product.addressing}</td>
                    <td>
                        <a href="./update.html?id=${product.id}" class="btn btn-primary">Update</a>
                        <a href="./delete.html?id=${product.id}" class="btn btn-danger">Delete</a>
                    </td>
                </tr>
            `;
        });
        table.innerHTML += `</tbody></table></div>`;
    } else {
        table.innerHTML += `
            <div class="container text-center">
                
            </div>
        </div>
        `;
    }
    return

    //função para pegar os produtos
    async function getProducts() {
        const response = await fetch("http://192.168.199.37:8081/rest/api/v2/custom/products", {
            method: "GET",
            headers: {
                "Content-Type": "application/json"
            },
        });
        return response.json();
    }

});