
-- Add mock suppliers
CALL magic_beans_schema.add_supplier_with_contact('Magic Beans Ltd', '123-456-7890', 'contact@magicbeans.com', '123 Bean St, Beantown');
CALL magic_beans_schema.add_supplier_with_contact('Golden Harvest', '987-654-3210', 'info@goldenharvest.com', '456 Farm Rd, Greendale');
CALL magic_beans_schema.add_supplier_with_contact('Evergreen Supplies', '555-123-4567', 'sales@evergreensupplies.com', '789 Greenway, Forest City');
CALL magic_beans_schema.add_supplier_with_contact('Oceanic Imports', '222-333-4444', 'support@oceanicimports.com', '321 Seaside Ave, Harborview');
CALL magic_beans_schema.add_supplier_with_contact('Skyline Traders', '777-888-9999', 'hello@skylinetraders.com', '654 Summit Dr, Metropolis');

-- Add mock inventory for beans
INSERT INTO magic_beans_schema.inventory (bean_id, quantity)
SELECT 
    id, 
    CASE 
        WHEN RANDOM() < 0.2 THEN 0
        ELSE (RANDOM() * 180 + 20)::INTEGER
    END
FROM magic_beans_schema.bean;
