import { LightningElement, track } from 'lwc';
import createNewAccount from '@salesforce/apex/AccountHandler.createNewAccount';

export default class CreateAccount extends LightningElement {
    @track openModal = false;
    
    // field variables
    name;
    phone;
    number;
    website;
    type;
    ownership;
    industry;
    employees;
    bstreet;
    bcity;
    bstate;
    bzip;
    bcountry;
    sstreet;
    scity;
    sstate;
    szip;
    scountry;
    // combobox variables
    typeValue = null;
    ownershipValue = null;
    industryValue = null;


    get typeOptions() {
        return [
            { label: '--None--', value: null },
            { label: 'Prospect', value: 'Prospect' },
            { label: 'Customer - Direct', value: 'Customer - Direct' },
            { label: 'Customer - Channel', value: 'Customer - Channel' },
            { label: 'Channel Partner / Reseller', value: 'Channel Partner / Reseller' },
            { label: 'Installation Partner', value: 'Installation Partner' },
            { label: 'Technology Partner', value: 'Technologu Partner' },
            { label: 'Other', value: 'Other' }
        ];
    }

    get ownershipOptions() {
        return [
            { label: '--None--', value: null },
            { label: 'Public', value: 'Public' },
            { label: 'Private', value: 'Private' },
            { label: 'Subsidiary', value: 'Subsidiary' },
            { label: 'Other', value: 'Other' }
        ];
    }

    get industryOptions() {
        return [
            { label: '--None--', value: null },
            { label: 'Agriculture', value: 'Agriculture' },
            { label: 'Apparel', value: 'Apparel' },
            { label: 'Apparel', value: 'Apparel' },
            { label: 'Biotechnology', value: 'Biotechnology' },
            { label: 'Chemicals', value: 'Chemicals' },
            { label: 'Comunications', value: 'Comunications' },
            { label: 'Construction', value: 'Construction' },
            { label: 'Consulting', value: 'Consulting' },
            { label: 'Education', value: 'Education' },
            { label: 'Electronics', value: 'Electronics' },
            { label: 'Energy', value: 'Energy' },
            { label: 'Engineering', value: 'Engineering' },
            { label: 'Entertainment', value: 'Entertainment' },
            { label: 'Environment', value: 'Environment' }
        ];
    }


    createAccount() {
        createNewAccount({
            name: this.name,
            phone: this.phone,
            accnumber: this.number,
            website: this.website,
            type: this.type,
            ownership: this.ownership,
            industry: this.industry,
            employees: this.employees,
            bstreet: this.bstreet,
            bcity: this.bcity,
            bstate: this.bstate,
            bzip: this.bzip,
            bcountry: this.bcountry,
            sstreet: this.sstreet,
            scity: this.scity,
            sstate: this.sstate,
            szip: this.szip,
            scountry: this.scountry
        })
        .then(() => {
            console.log('account created successfully');
        })
        .catch(() => {
            console.log('error occurred');
        });
        this.openModal = false;
    }

    showModal() {
        this.openModal = true;
    }
    
    closeModal() {
        this.openModal = false;
    }

    handleNameChange(event) {
        this.name = event.target.value;
        console.log(this.name);
    }

    handlePhoneChange(event) {
        this.phone = event.target.value;
    }

    handleNumberChange(event) {
        this.number = event.target.value;
    }

    handleWebsiteChange(event) {
        this.website = event.target.value;
    }

    handleTypeChange(event) {
        this.type = event.target.value;
        console.log(this.type);
    }

    handleOwnershipChange(event) {
        this.ownership = event.target.value;
    }

    handleIndustryChange(event) {
        this.industry = event.target.value;
    }

    handleEmployeesChange(event) {
        this.employees = event.target.value;
    }

    handleBillingStreetChange(event) {
        this.bstreet = event.target.value;
    }

    handleBillingCityChange(event) {
        this.bcity = event.target.value;
    }

    handleBillingStateChange(event) {
        this.bstate = event.target.value;
    }

    handleBillingCountryChange(event) {
        this.bcountry = event.target.value;
    }

    handleBillingZipChange(event) {
        this.bzip = event.target.value;
    }

    handleShippingStreetChange(event) {
        this.bstreet = event.target.value;
    }

    handleShippingCityChange(event) {
        this.bcity = event.target.value;
    }

    handleShippingStateChange(event) {
        this.bstate = event.target.value;
    }

    handleShippingCountryChange(event) {
        this.bcountry = event.target.value;
    }

    handleShippingZipChange(event) {
        this.szip = event.target.value;
    }


}