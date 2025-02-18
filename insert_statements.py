import csv
import argparse

columns = {
    "users": {
        "first_name": "STRING",
        "last_name": "STRING",
        "username": "STRING",
        "hashed_password": "STRING",
        "phone": "STRING",
        "email": "STRING",
        "address": "STRING"
    },
    # Add more tables here please ty
}

functions = {
    "users": "insert_user"
}

### YOU DON'T NEED TO MODIFY ANYTHING BELOW THIS!!! ###

def escape_sql_value(value, value_type):
    if value_type == 'STRING':
        return f"'{value.replace("'", "''")}'"
    elif value_type == 'DATE':
        return f"'{value}'"
    elif value_type == 'NUMBER':
        return str(value)
    return str(value)

def generate_select_statements(csv_file, output_sql_file, table_name):
    
    if table_name not in columns:
        raise ValueError(f"Table '{table_name}' not found in predefined column types.")
    
    table_columns = columns[table_name]
    function_name = functions[table_name]
    
    with open(csv_file, mode='r', newline='', encoding='utf-8') as file:
        reader = csv.reader(file)
        headers = next(reader)
        
        if headers != list(table_columns.keys()):
            raise ValueError(f"CSV headers do not match expected columns for {table_name}: {list(table_columns.keys())}")
        
        with open(output_sql_file, mode='w', encoding='utf-8') as sql_out:
            
            for row in reader:
                values = [
                    escape_sql_value(value, table_columns[header]) 
                    for value, header in zip(row, headers)
                ]
                
                sql_statement = f"SELECT {function_name}({', '.join(values)});\n"
                sql_out.write(sql_statement)
            
    print(f"SQL file '{output_sql_file}' has been created successfully with SELECT statements for '{function_name}'.")

def main():
    parser = argparse.ArgumentParser(description="Generate SQL SELECT statements to call a function.")
    
    parser.add_argument('table', help="The table to generate SELECT statements for")
    parser.add_argument('csv_file', help="Path to the input CSV file")
    parser.add_argument('output_sql_file', help="Path to output SQL file")
    
    args = parser.parse_args()

    generate_select_statements(args.csv_file, args.output_sql_file, args.table)

if __name__ == '__main__':
    main()
