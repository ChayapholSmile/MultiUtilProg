import requests
from datetime import datetime
import json
import os

# ใส่ข้อมูลของคุณ
SPREADSHEET_ID = '1s_0ZX_rqV01ghRjxPOPFfSqH3rwSNmgxKX6TuWfd6Ag'
SHEET_NAME = 'License'
API_KEY = 'AIzaSyDgxTWXvIUQND4C7gzapRW6KNqEaBPQ8Y0'

# อ่าน license_id จากไฟล์ ../license
def read_license_id():
    try:
        with open('../license', 'r') as file:
            line = file.readline().strip()
            if line.startswith('license_id='):
                return line[len('license_id='):]
            else:
                raise ValueError("Invalid file format")
    except Exception as e:
        print(f"ERROR: Cannot check license")
        exit(1)

license_id_to_check = read_license_id()
current_date = datetime.now().strftime('%Y-%m-%d')

# สร้าง URL สำหรับเข้าถึง Google Sheets API
url = f"https://sheets.googleapis.com/v4/spreadsheets/{SPREADSHEET_ID}/values/{SHEET_NAME}?key={API_KEY}"

# ดึงข้อมูลจาก Google Sheets
response = requests.get(url)
data = response.json()

# ตรวจสอบว่าดึงข้อมูลสำเร็จหรือไม่
if 'values' not in data:
    print("Cannot Retrieve Information, Please check your network connection")
    exit(1)

# ค้นหาหัวข้อคอลัมน์
headers = data['values'][0]
values = data['values'][1:]

# แปลงข้อมูลเป็น dictionary
rows = [dict(zip(headers, row)) for row in values]

license_found = False
package_info = {}

for row in rows:
    if row.get('License ID') == license_id_to_check:
        issuer = row.get('Issuer', 'Unknown')
        issued_to = row.get('Issued to', 'Unknown')
        expiration = row.get('Expiration', 'No')
        package = row.get('Package', 'Unknown')  # Assume package info is in the column 'Package'

        # ตรวจสอบวันหมดอายุ
        if expiration.lower() != "no" and expiration <= current_date:
            print("License Expired")
            exit(1)

        # เขียนไฟล์ batch
        batch_file_content = (
            f'set ISSUER={issuer}\n'
            f'set ISSUED_TO={issued_to}\n'
            f'set PACKAGE={package}\n'
        )

        with open('license_vars.bat', 'w') as file:
            file.write(batch_file_content)

        # ตรวจสอบว่าไฟล์ถูกสร้างและเขียนข้อมูลอย่างถูกต้อง
        if os.path.exists('license_vars.bat'):
            with open('license_vars.bat', 'r') as file:
                content = file.read()
                if content == batch_file_content:
                    print("สร้างไฟล์ license_vars.bat เรียบร้อยแล้ว")
                else:
                    print("ERROR: File content does not match expected content")
                    exit(1)
        else:
            print("ERROR: File was not created")
            exit(1)

        license_found = True
        break

if not license_found:
    print("License Not Found")
    exit(1)
