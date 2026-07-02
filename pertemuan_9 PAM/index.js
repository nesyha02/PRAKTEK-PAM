const express = require('express');

const app = express();
const port = 3000;

// Middleware
app.use(express.json());

// Route utama
app.get('/', (req, res) => {
    res.send('Server API berjalan');
});

// Data produk
let products = [
    {
        id: 1,
        name: 'laptop',
        price: 10000000
    },
    {
        id: 2,
        name: 'mouse',
        price: 200000
    }
];

// GET - Menampilkan semua produk
app.get('/products', (req, res) => {
    res.json(products);
});

// POST - Menambah produk
app.post('/products', (req, res) => {
    const newProduct = {
        id: products.length + 1,
        name: req.body.name,
        price: req.body.price
    };

    products.push(newProduct);

    res.json({
        message: 'Data berhasil ditambahkan',
        data: newProduct
    });
});

// PUT - Mengubah data produk
app.put('/products/:id', (req, res) => {
    const id = parseInt(req.params.id);

    const product = products.find(p => p.id === id);

    if (!product) {
        return res.status(404).json({
            message: 'Data tidak ditemukan'
        });
    }

    product.name = req.body.name;
    product.price = req.body.price;

    res.json({
        message: 'Data berhasil diupdate',
        data: product
    });
});

// DELETE - Menghapus produk
app.delete('/products/:id', (req, res) => {
    const id = parseInt(req.params.id);

    products = products.filter(p => p.id !== id);

    res.json({
        message: 'Data berhasil dihapus'
    });
});

// Menjalankan server
app.listen(port, () => {
    console.log(`Server berjalan di port ${port}`);
});