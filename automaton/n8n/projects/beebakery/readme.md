# Beebakery n8n Workflows

This repository contains n8n workflows for the Beebakery application, including order creation, landing page delivery, and sales dashboard reporting.

---

## 1. Beebakery Create Order API

Handles incoming order requests and stores them in MongoDB.

### Workflow Nodes
- **Create Order (Webhook)**: Listens for POST requests at `/srcdoc/order`.
- **Edit Fields (Set)**: Extracts `no_order`, `created_at`, and `items` from the request body.
- **Insert Documents (MongoDB)**: Inserts the order into the `orders` collection.

### Usage
1. Send a POST request with JSON body containing `no_order`, `created_at`, and `items`.
2. Data is stored in MongoDB for further processing.

---

## 2. Beebakery Landing Page

Serves the frontend POS page to users.

### Workflow Nodes
- **PosPage (Webhook)**: Serves the landing page at `/beebakery`.
- **Respond to Webhook**: Delivers HTML page with product catalog, categories, and cart functionality.

### Features
- Dynamic product grid and category filtering.
- Cart management with quantity adjustments.
- Order submission via POST to `/srcdoc/order`.
- Modal feedback for order submission status.

---

## 3. Beebakery Salesman Dashboard

Provides a summary and detailed reporting for sales.

### Workflow Nodes
- **Webhook**: Listens at `/report` for dashboard requests.
- **Find Documents (MongoDB)**: Fetches all orders from the `orders` collection.
- **Code**: Processes orders to calculate total revenue, total items sold, top product, top category, and category breakdown.
- **Respond to Webhook**: Returns a dynamic HTML dashboard.

### Features
- KPI summary cards (Total Revenue, Total Items Sold, Top Product, Top Category).
- Category breakdown table with sales stats and last sold item.
- Recommendation/analysis cards for sales insights.

---

## Setup Instructions

1. Import the workflows into your n8n instance.
2. Configure MongoDB credentials for the database nodes.
3. Deploy the workflows and test endpoints:
   - `POST /srcdoc/order` for creating orders.
   - `GET /beebakery` to access the POS page.
   - `GET /report` to view the sales dashboard.

---

## Notes

- Ensure that Tailwind CSS is accessible in the landing page and dashboard HTML.
- Orders submitted via the landing page are automatically stored in MongoDB.
- The dashboard uses processed data to provide actionable insights for sales management.
