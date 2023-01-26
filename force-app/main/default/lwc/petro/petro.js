import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAccounts from '@salesforce/apex/PetroHandler.getAccounts';
import getAccount from '@salesforce/apex/PetroHandler.getAccount';
import createVisit from '@salesforce/apex/PetroHandler.createVisit';

export default class Petro extends LightningElement {
    @track lat = 0;
    @track long = 0;
    @track accountRecord;
    @track siteLat;
    @track siteLong;
    @track checkInLat = 0;
    @track checkInLong = 0;
    @track checkOutLat = 0;
    @track checkOutLong = 0;
    @track checkInTime;
    @track checkOutTime;
    @track visitDate;
    @track distance;
    @track purpose;
    @track isRendered = false;
    @track isChecked = false;
    @track selectedAcc;
    @track accounts = [];
    @track value = '';

    renderedCallback() {
        if (this.isRendered)
            return;
        this.isRendered = true;
        this.getCurrentPosition();
    }

    handleReset() {
        this.template.querySelectorAll('lightning-input').forEach(element => {
            element.value = null;
        });
        this.template.querySelectorAll('lightning-combobox').forEach(element => {
            element.value =  undefined;
        });
        this.accountRecord = null;
        this.purpose = null;
    }

    getCurrentPosition() {
        navigator.geolocation.getCurrentPosition(position => {
            this.lat = position.coords.latitude;
            this.long = position.coords.longitude;
        });
    }

    @wire(getAccounts)
    wiredAccounts({ data, error }) {
        if (data) {
            for (let i=0; i<data.length; i++) {
                this.accounts = [...this.accounts, {value: data[i].Id, label: data[i].Name}];
            }
        }
        else if (error) {
            console.log('error fetching accounts: ', error);
        }
    }

    get accountOptions() {
        return this.accounts;
    }

    get disableCheckIn() {
        if (this.accountRecord == null || this.purpose == null)
            return true;
        return false;
    }

    get disableCheckOut() {
        return !this.isChecked;
    }

    handleAccountSelection(event) {
        const selectedOption = event.detail.value;
        const filterChangeEvent = new CustomEvent('filterchange', {
            detail: { selectedOption },
        });
        this.dispatchEvent(filterChangeEvent);
        this.accountRecord = selectedOption;
        getAccount({accId: this.accountRecord})
        .then((result) => {
            console.log(result);
            console.log('sitelat: ', result.Location__Latitude__s);
            console.log('siteLong: ', result.Location__Longitude__s);
            this.siteLat = result.Location__Latitude__s;
            this.siteLong = result.Location__Longitude__s;
        })
        .catch(error => {
            console.log('error fetching account info: ', error);
        });
    }

    handlePurposeChange(event) {
        this.purpose = event.target.value;
    }
    
    rad = function(x) {
        return x * Math.PI / 180;
    };
      
    getDistance = function(lat1, long1, lat2, long2) {
        var R = 6378137; // Earth’s mean radius in meter
        var dLat = this.rad(lat2 - lat1);
        var dLong = this.rad(long2 - long1);
        var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
            Math.cos(this.rad(lat1)) * Math.cos(this.rad(lat2)) *
            Math.sin(dLong / 2) * Math.sin(dLong / 2);
        var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        var d = R * c;
        return d.toFixed(0); // returns the distance in meter
    };

    getTime() {
        let time = new Date().toLocaleTimeString();
        if (time !== undefined) {
            time = time.substring(0, time.length-3);
        }
        return time;
    }

    checkIn() {
        console.log('checkin');
        if (this.isChecked) {
            const evt = new ShowToastEvent({
                title: 'Invalid Check In',
                message: 'You are already checked in! Please check out first.',
                variant: 'warning',
            });
            this.dispatchEvent(evt);
        }
        else {
            if (this.lat !== 0 && this.long !== 0) {
                this.distance = this.getDistance(this.siteLat, this.siteLong, this.lat, this.long);
                if (this.distance > 500) {
                    this.checkInLat = this.lat;
                    this.checkInLong = this.long;
                    this.checkInTime = this.getTime();
                    this.isChecked = true;
                    this.isRendered = false;
                }
                else {
                    const evt = new ShowToastEvent({
                        title: 'Site too far!',
                        message: `Please reach the visit site to check in. You are too far from the site. ${this.distance}m`,
                        variant: 'error',
                    });
                    this.dispatchEvent(evt);
                }
            }
            else {
                const evt = new ShowToastEvent({
                    title: 'No Coordinates',
                    message: 'Coordinates not available!',
                    variant: 'warning',
                });
                this.dispatchEvent(evt);
            }
        }
    }

    checkOut() {
        console.log('checkout');
        if (this.lat !== 0 && this.long !== 0) {
            this.checkOutLat = this.lat;
            this.checkOutLong = this.long;
            this.isChecked = false;
            this.checkOutTime = this.getTime();
            console.log('checkin: ', this.checkInTime);
            console.log('checkinlat: ', this.checkInLat);
            console.log('checkinlong: ', this.checkInLong);
            console.log('checkoutlat: ', this.checkOutLat);
            console.log('checkoutlong: ', this.checkOutLong);
            console.log('checkout: ', this.checkInTime);
            console.log('distance: ', this.distance);
            createVisit({
                accountId: this.accountRecord,
                purpose: this.purpose,
                checkInTime: this.checkInTime,
                checkOutTime: this.checkOutTime,
                checkInLat: this.checkInLat,
                checkInLong: this.checkInLong,
                checkOutLat: this.checkOutLat,
                checkOutLong: this.checkOutLong,
                distance: this.distance
            })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Successfully visited this place!',
                        variant: 'success'
                    }),
                );
                this.handleReset();
                console.log('New Visit Added!');
            })
            .catch(error => {
                console.log('unable to create visit: ', error);
            })
        }
        else {
            const evt = new ShowToastEvent({
                title: 'No Coordinates',
                message: 'Coordinates not available!',
                variant: 'warning',
            });
            this.dispatchEvent(evt);
        }
    }

}