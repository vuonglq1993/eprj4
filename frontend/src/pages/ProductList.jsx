import React from 'react';

const PRODUCTS = [
  {
    id: '1',
    name: 'BKLGO Hoodie',
    category: 'Clothing',
    quantity: 12,
    sku: '243598234',
    salary: '$170,750',
    status: 'In Stock',
    image: 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=120&h=120&fit=crop',
  },
  {
    id: '2',
    name: 'MacBook Pro',
    category: 'Electronics',
    quantity: 63,
    sku: '877712',
    salary: '$2,499',
    status: 'In Stock',
    image: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=120&h=120&fit=crop',
  },
  {
    id: '3',
    name: 'Metro Bar Stool',
    category: 'Furniture',
    quantity: 86,
    sku: '452891002',
    salary: '$189',
    status: 'Out of Stock',
    image: 'https://images.unsplash.com/photo-1503602642458-232111445657?w=120&h=120&fit=crop',
  },
  {
    id: '4',
    name: 'Air Max Runner',
    category: 'Shoes',
    quantity: 42,
    sku: '991203445',
    salary: '$159',
    status: 'In Stock',
    image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=120&h=120&fit=crop',
  },
  {
    id: '5',
    name: 'Minimal Desk Lamp',
    category: 'Furniture',
    quantity: 24,
    sku: '772001998',
    salary: '$89',
    status: 'In Stock',
    image: 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=120&h=120&fit=crop',
  },
  {
    id: '6',
    name: 'Canvas Tote',
    category: 'Clothing',
    quantity: 0,
    sku: '334455667',
    salary: '$45',
    status: 'Out of Stock',
    image: 'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=120&h=120&fit=crop',
  },
];

function StatusBadge({ status }) {
  const inStock = status === 'In Stock';
  return (
    <span className={`pl-status ${inStock ? 'pl-status--in' : 'pl-status--out'}`}>
      {status}
    </span>
  );
}

const ProductList = () => (
  <div className="productlist-page py-4 px-3">
    <div className="productlist-inner mx-auto">
      <div className="mb-4">
        <h2 className="productlist-title fw-bold mb-1">Product List</h2>
        <p className="text-muted small mb-0">Manage inventory and product details</p>
      </div>

      <div className="pl-table-card shadow-sm">
        <div className="table-responsive">
          <table className="table pl-table mb-0">
            <thead>
              <tr>
                <th scope="col">Product</th>
                <th scope="col">Category</th>
                <th scope="col">Quantity</th>
                <th scope="col">Sku</th>
                <th scope="col">Salary</th>
                <th scope="col">Status</th>
              </tr>
            </thead>
            <tbody>
              {PRODUCTS.map((row) => (
                <tr key={row.id}>
                  <td>
                    <div className="pl-product-cell d-flex align-items-center gap-3">
                      <img src={row.image} alt="" className="pl-product-thumb" width={40} height={40} />
                      <span className="pl-product-name fw-semibold">{row.name}</span>
                    </div>
                  </td>
                  <td>
                    <span className="pl-cell-muted">{row.category}</span>
                  </td>
                  <td>{row.quantity}</td>
                  <td>
                    <span className="pl-cell-muted">{row.sku}</span>
                  </td>
                  <td>
                    <span className="pl-salary">{row.salary}</span>
                  </td>
                  <td>
                    <StatusBadge status={row.status} />
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
);

export default ProductList;
