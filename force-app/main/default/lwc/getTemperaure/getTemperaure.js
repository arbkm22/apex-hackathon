import { LightningElement, wire, api } from 'lwc';
import getTemp from '@salesforce/apex/FetchTemperature.getTemp';
import getUser from '@salesforce/apex/FetchTemperature.getUser';

export default class GetTemperaure extends LightningElement {
    @api temp = 0;
    // @api recordId;
    // record;
    // @wire(getUser)
    // wiredUser({ data, error }) {
    //     if (data) {
    //         this.record = data[0];
    //     }
    //     else if (error) {
    //         console.log('Error in fetching user');
    //     }
    // }

    // get userName() {
    //     return this.record?.Name;
    // }

    // get userCity() {
    //     return this.record?.City;
    // }

    // get userTemp() {
    //     return this.record?.temp;
    // }
    handleClick(event) {
        console.log('button clicked');
        getTemp()
        .then(response => {
            console.log(response);
            this.temp = response;
            // this.userTemp();
        });
    }
}