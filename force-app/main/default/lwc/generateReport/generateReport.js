import { LightningElement, track, wire, api } from 'lwc';
import getAccounts from '@salesforce/apex/GetAccounts.getAccounts';
import getContacts from '@salesforce/apex/GetAccounts.getContacts';
import accounts from '@salesforce/apex/GetAccounts.accounts';
import workbook from "@salesforce/resourceUrl/xlsx";
import { loadScript } from "lightning/platformResourceLoader";


export default class GenerateReport extends LightningElement {
    @track accountsData = [];
    @track contactsData = [];
    @track xlsHeader = [];
    @api xlsData = [];
    @track worksheetNameList = [];
    @track filename = "lwc_assignment.xlsx";
    librariesLoaded = false;

    accountColumns = ['Id', 'Name', 'AccountNumber', 'Phone Number', 'Type', 'Industry', 'Website', 'Ownership', 'NumberOfEmployees', 'AnnualRevenue', 'Sic'];
    contactColumns = ['Id', 'Name', 'Phone', 'Title', 'Department', 'Email', 'LeadSource', 'Language', 'Level', 'Birthday'];

    // @wire(getAccounts)
    // wiredAccount({ data, error }) {
    //     if (data) {
    //         console.log(data);
    //         this.accountsData = data;
    //         this.xlsFormatter(data, this.accountColumns, "Accounts");
    //     }
    //     else if (error) {
    //         console.log("error: ", error);
    //     }
    // }

    renderedCallback() {
        console.log("rendered callback xlsx");
        if (this.librariesLoaded)
            return;
        this.librariesLoaded = true;
        Promise.all([loadScript(this, workbook + "/xlsx.full.min.js")])
        .then(() => {
            console.log("success");
        })
        .catch(error => {
            console.log(error.message);
            console.log(error);
        });
    }

    

    @wire(accounts)
    wiredAccounts({ data, error }) {
        if (data) {
            console.log(data);
            this.accountsData = data;
            this.xlsFormatter(data, this.accountColumns, "Accounts");
        }
        else if (error) {
            console.log("error: ", error);
        }
    }

    @wire(getContacts)
    wiredContacts({ data, error }) {
        if (data) {
            console.log(data);
            this.contactsData = data;
            this.xlsFormatter(data, this.contactColumns, "Contacts");
        }
        else if (error) {
            console.log("error: ", error);
        }
    }

    // connectedCallback() {
    //     //apex call for bringing the contact data  
    //     getContacts()
    //       .then(result => {
    //         console.log(result);
    //         this.contactHeader = Object.keys(result[0]);
    //         this.contactsData = [...this.contactData, ...result];
    //         this.xlsFormatter(result, "Contacts");
    //       })
    //       .catch(error => {
    //         console.error(error);
    //       });
    //     //apex call for bringing the account data  
    //     getAccounts()
    //       .then(result => {
    //         console.log(result);
    //         this.accountHeader = Object.keys(result[0]);
    //         this.accountsData = [...this.accountData, ...result];
    //         this.xlsFormatter(result, "Accounts");
    //       })
    //       .catch(error => {
    //         console.error(error);
    //       });
    //   }

    @api xlsFormatter(data, header, sheetName) {
        console.log("xlsFormatter: data = ", data.length);
        let Header = Object.keys(data[0]);
        this.xlsHeader.push(header);
        this.worksheetNameList.push(sheetName);
        this.xlsData.push(data);
    }

    @api download() {
        console.log("generateReport");
        // create a new xlsx object
        const XLSX = window.XLSX;
        // let xlsData = this.xlsData;
        // let xlsHeader = this.headerList;
        // let ws_name = this.worksheetNameList;
        let createXLSLFormatObj = Array(this.xlsData.length).fill([]);
        console.log("xlsData: ", this.xlsData.length);
        // add headers in the excel file
        this.xlsHeader.forEach((item, index) => createXLSLFormatObj[index] = [item])
        // add required data in the createXLSL object
        this.xlsData.forEach((item, selectedRowIndex)=> {
            let xlsRowKey = Object.keys(item[0]);
            item.forEach((value, index) => {
                var innerRowData = [];
                xlsRowKey.forEach(item=>{
                    innerRowData.push(value[item]);
                });
                createXLSLFormatObj[selectedRowIndex].push(innerRowData);
            });
        });
        // create a new workbook
        var wb = XLSX.utils.book_new();
        // create a new wprksheet
        var ws = Array(createXLSLFormatObj.length).fill([]);
        // append the data to the worksheet
        for (let i = 0; i < ws.length; i++) {
            let data = XLSX.utils.aoa_to_sheet(createXLSLFormatObj[i]);
            data['!cols'] = this.fitToColumn(createXLSLFormatObj[i]);
            ws[i] = [...ws[i], data];
            XLSX.utils.book_append_sheet(wb, ws[i][0], this.worksheetNameList[i]);
        }
        console.log(createXLSLFormatObj.length);
        XLSX.writeFile(wb, this.filename);
    }

    fitToColumn(arrayOfArray) {
        return arrayOfArray[0].map((a, i) => ({ wch: Math.max(...arrayOfArray.map(a2 => a2[i] ? a2[i].toString().length : 0)) }));
    }

    // exportAccountsData() {
    //     let doc = '<table>';
    //     doc += '<style>';
    //     doc += 'table, th, td {';
    //     doc += '    border: 1px solid black;';
    //     doc += '    border-collapse: collapse;';
    //     doc += '}';
    //     doc += '</style>'
    //     doc += '<tr>';
    //     this.columns.forEach(element => {
    //         doc += '<th>' + element + '</th>'
    //     });
    //     doc += '</tr>';
    //     this.accountsData.forEach(record => {
    //         doc += '<tr>';
    //         doc += '<th>'+record.Name+'</th>';
    //         doc += '<th>'+record.AccountNumber+'</th>';
    //         doc += '<th>'+record.Phone+'</th>';
    //         doc += '<th>'+record.Type+'</th>';
    //         doc += '<th>'+record.Industry+'</th>';
    //         doc += '<th>'+record.Website+'</th>';
    //         doc += '<th>'+record.Ownership+'</th>';
    //         doc += '<th>'+record.NumberOfEmployees+'</th>';
    //         doc += '<th>'+record.AnnualRevenue+'</th>';
    //         doc += '<th>'+record.Sic+'</th>';
    //         doc += '</tr>';
    //     });
    //     doc += '</table>';
    //     var newElement = 'data:application/vnd.ms-excel,' + encodeURIComponent(doc);
    //     let downloadElement = document.createElement('a');
    //     downloadElement.href = newElement;
    //     downloadElement.target = '_self';
    //     downloadElement.download = 'Account Data.xls';
    //     document.body.appendChild(downloadElement);
    //     downloadElement.click();
    // }
}