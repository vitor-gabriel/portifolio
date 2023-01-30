//listar produtos na tela
document.addEventListener("DOMContentLoaded", e => {
    //pega os produtos
    const products = getProducts();
    const table = document.getElementById('table-products');
    table.innerHTML = '';
    //percorre o array de produtos
    if (typeof products.value === 'object') {
        products.forEach((product) => {
            table.innerHTML += `
            <tr>
                <td>${product.name}</td>
                <td>${product.price}</td>
                <td>${product.quantity}</td>
                <td>
                    <button type="button" class="btn btn-primary" onclick="changeProduct(${product.id})>Change</button>
                    <button type="button" class="btn btn-danger" onclick="deleteProduct(${product.id})">Delete</button>
                </td>
            </tr>
        `;
        });
    } else {
        table.innerHTML = `
            <div class="container text-center">
                <div class="card">
                <div class="card-body">
                    <h5 class="card-title">No products found</h5>
                    <p class="card-text">Click on the button below to create a new product</p>
                    <a href="./create.html" class="btn btn-primary">Create</a>
                </div>
            </div>
        </div>
        `;
    }

    //função para pegar os produtos
    function getProducts() {
        const products = fetch("http://localhost:8081/rest/api/v2/products/", {
            method: "GET",
        }).then(response => {
            return response.json()
        }).then(data => {
            return data;
        }).catch(error => {
            console.log(error)
        })
        return products;
    }

});