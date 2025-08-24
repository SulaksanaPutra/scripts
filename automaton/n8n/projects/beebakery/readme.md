### Workflow 1: Product Creation

**Description**
Handles the creation of new products in the Beebakery system, including validation and database insertion.

**Steps**
1. Validate incoming product data.
2. Insert product into the database.
3. Send confirmation response.

**Expected Result**
- Product is successfully added to the database.
- API returns a success message.
- Validation errors are returned for invalid data.

---

### Workflow 2: Order Processing

**Description**
Manages the processing of customer orders, including stock checking, order entry, and status updates.

**Steps**
1. Validate order details.
2. Check inventory availability.
3. Create order entry in the system.
4. Update stock levels.
5. Send order confirmation to customer.

**Expected Result**
- Order is recorded in the database.
- Stock levels are updated correctly.
- Customer receives confirmation.
- Errors are handled gracefully.

---

### Workflow 3: Inventory Management

**Description**
Oversees inventory updates and adjustments to ensure accurate stock tracking for Beebakery.

**Steps**
1. Receive inventory update requests.
2. Validate inventory data.
3. Update inventory records.
4. Notify relevant teams if stock is low.

**Expected Result**
- Inventory records are accurate.
- Alerts are triggered for low stock.
- Invalid updates are rejected with errors.
