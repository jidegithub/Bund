import Vue from "vue";
import ElementUI from "element-ui";
//import lang from 'element-ui/lib/umd/locale/en'
import locale from "element-ui/lib/locale";
import VueDataTables from "vue-data-tables";
import axios from "axios";
import store from "./store";
import { mapGetters, mapState } from "vuex";

// locale.use(lang)
Vue.use(ElementUI, { locale });
Vue.use(VueDataTables);
//Vue.use(require("vue-moment"));

var bund_navbar = document.getElementById("nav-bar");
if (bund_navbar != null) {
  var dropdownpr = new Vue({
    el: bund_navbar,
    data() {
      return {
        isOpenDropDownPr: false
      };
    },

    methods: {
      openDropDown() {
        console.log("clicked button");
      }
    }
  });
}

var bund_account = document.getElementById("account");
if (bund_account != null) {
  var account = new Vue({
    el: "#account",
    store,
    data() {
      return {
        accounts: [],
        editAccountNo: "",
        actionType:"",
        accountHeaderText:"Add New Account",
        accountButtonText:"Create",
        accountNotifMsg:"Account Successfully Created",
        total: 0,
        testing:"",
        selectedRow: [],
        selectionMessage: "",
        pagination: { pageSizes: [25, 50, 100] },
        tableProps: {
          border: false,
          stripe: false,
          defaultSort: {
            prop: "flow_no",
            order: "descending"
          }
        },
        layout: "table",
        row_data: "",
        row_index: "",
        table_detail: "",
        startIndex_tabledetail: 1,
        endIndex_tabledetail: 0,
        table_isFirstPage: true,
        selectedNoOfPages: "20",
        selectedPeriodForFilter: "all",
        currentPageNo: "1",
        numberofpages: 0,
        search: "",
        inserted_at: "",
        dateSelected: "all",
        isAcctFormHidden: true,
        isAcctModalHidden: true,
        isAcctSuccesNotifHidden: true,
        countries: [],
        states: [],
        newAccount: {
          company: "",
          city: "",
          contact_person: "",
          country: "",
          email_address: "",
          note: "",
          phone: "",
          sector: "",
          state: "",
          status: "Engaged",
          street: "",
          zip: ""
        },
        accountFormError: {
          companyError: true,
          contactError: true,
          emailError: true,
          phoneError: true,
          streetError: true,
          countryError: true,
          stateError: true,
          cityError: true,
          sectorError: true
        },
        country: "",
        state:"",
        postedStatusMsg: "",
        accountErrorText: true,
        clickCount : 0
        
      };
    },

    computed: {
      ...mapGetters(["account_data", "clicked_account"]),
      selectionExists() {
        return this.selectedRow.length > 0 && this.selectedRow != null;
      },
     
    },

    updated() {
      this.accountStore = this.account_data;
      this.$store.watch(
        () => this.saved_package_alert,
        saved_package_alert => {
          console.log("watched: ", saved_package_alert);
          if (this.saved_package_alert == true) {
            setTimeout(() => {
              this.$store.commit("toggle_saved_package_alert", false);
            }, 3000);
          }
        }
      );
    },
    created() {
      axios.get("http://localhost:4000/api/countries").then(res => {
        this.countries = res.data;
      });
    },
    
    watch: {
       clicked_account(account) {
        window.location.href = "/accounts/"+ account.id
      },
      clickCount: function(){          
          this.editAccount();
        }     
    },
    methods: {
     editAccount(){
      let accountData = this.account_data.find(account => account.id == this.editAccountNo)
      let account = this.newAccount;
      let country = this.countries.find(country => country.name == accountData.country);
      
      
      account.company = accountData.company;
      account.city= accountData.city;
      account.contact_person= accountData.contact_person;
      account.country= country.id;

      this.loadStates();     

      account.email_address= accountData.email_address;
      account.note= accountData.note;
      account.phone= accountData.phone;
      account.sector= accountData.sector;
      account.state= accountData.state;
      account.status= accountData.status;
      account.street= accountData.street;

      this.openModal(); 

      this.actionType = "edit";
      this.accountHeaderText = "Edit Account";
      this.accountButtonText = "Save";
      this.accountNotifMsg = "Edit Successful"

     },
       changed: function(event) {
        this.$store.commit("change", event.target.value);
      },

      fetchData(inserted_at) {
        
        var vm = this;
        axios
          .get("api/accounts", {
            params: { insert_time: inserted_at }
          })
          .then(response => {
            this.$store.commit("change_accounts", response.data);
            let accountStore = this.account_data;
            this.accounts = accountStore.filter(
              account => accountStore.indexOf(account) <= (Number(this.selectedNoOfPages) -1)
            );
            this.total = accountStore.length;
            vm.tabledetail(vm.selectedNoOfPages, "next");
          });
      },
      handleSelectionChange(val) {
        this.selectionMessage =
          val.length == 1 ? "1 Selected" : val.length + " Selected";
        this.selectedRow = val;
      },
      toggleSelection() {
        if (this.selectedRow) {
          this.selectedRow.forEach(row => {
            console.log("Mult", this.$refs.multipleTable);
            this.$refs.multipleTable.toggleRowSelection(row);
          });
        } else {
          this.$refs.multipleTable.clearSelection();
        }
      },
      tableListner(row, actionType) {
        
        if (row.company !== null) {
         
          return [
            {
              id: row.id,
              companyName: row.company,
              handler: _ => {
                this.row_index = this.account_data.indexOf(row);
                this.$store.commit("change_index", this.row_index);
                this.row_data = this.clicked_account;
              },
              editHandler:_ => {
                this.editAccountNo = row.id;
                this.clickCount = this.clickCount + 1;
              }
            }
          ];
        }
      },
      tabledetail(pageNoSelected, nav_status) {
        pageNoSelected = Number(pageNoSelected);
        //When navigating next (Default)
        if (nav_status == "next") {
          //when there's no record
          if (this.total == "0") {
            this.table_detail = "0 of 0";
          } else {
            //when the records is less 20, 30, 40
            if (this.total <= pageNoSelected) {
              this.table_detail =
                this.startIndex_tabledetail +
                " - " +
                this.total +
                " of " +
                this.total;
              this.table_isFirstPage = true;
            } else {
              //when records more than 20,30,40
              let currentpageNo = Number(this.currentPageNo);
              let total = Number(this.total);
              let startIndex_tabledetail = Number(this.startIndex_tabledetail);

              //when it's the first page (that's first set of record)
              if (currentpageNo == 1) {
                this.numberofpages = parseInt(
                  Number(this.total) / pageNoSelected
                );
                this.endIndex_tabledetail = pageNoSelected;
                this.table_isFirstPage = true;
              }

              let numberofpages = Number(this.numberofpages);
              let tabledetail;

              //when it's the last page
              if (numberofpages == 0) {
                tabledetail =
                  this.startIndex_tabledetail +
                  " - " +
                  this.total +
                  " of " +
                  this.total;

                this.endIndex_tabledetail =
                  Number(this.endIndex_tabledetail) + pageNoSelected;
              } else {
                tabledetail =
                  this.startIndex_tabledetail +
                  " - " +
                  this.endIndex_tabledetail +
                  " of " +
                  this.total;
                this.endIndex_tabledetail =
                  Number(this.endIndex_tabledetail) + pageNoSelected;
              }

              //setup for next call of tabledetail()
              this.numberofpages = numberofpages - 1;
              this.startIndex_tabledetail =
                startIndex_tabledetail + pageNoSelected;
              this.currentPageNo = currentpageNo + 1;
              this.table_detail = tabledetail;
            }
          }
        }
        //When navigating previous
        else {
          let start = Number(this.startIndex_tabledetail) - pageNoSelected * 2;
          let end = Number(this.endIndex_tabledetail) - pageNoSelected * 2;
          this.table_detail = start + " - " + end + " of " + this.total;

          //setup for next call of tabledetail()
          this.numberofpages = this.numberofpages + 1;
          this.startIndex_tabledetail =
            this.startIndex_tabledetail - pageNoSelected;
          this.endIndex_tabledetail =
            this.endIndex_tabledetail - pageNoSelected;
          this.currentPageNo = this.currentPageNo - 1;
        }
      },

      handleNoOfRecordsPerPage() {
        let noOfRecordsPerPage = this.selectedNoOfPages;
        this.startIndex_tabledetail = 1;
        this.endIndex_tabledetail = Number(noOfRecordsPerPage);
        this.currentPageNo = "1";
        this.numberofpages = 0;

        this.tabledetail(noOfRecordsPerPage, "next");
        let accounts = this.account_data;
        this.accounts = accounts.filter(
          account =>
            accounts.indexOf(account) >= 0 &&
            accounts.indexOf(account) <= noOfRecordsPerPage - 1
        );
      },
      prevClicked() {
        if (
          !(
            this.startIndex_tabledetail - 1 == this.selectedNoOfPages ||
            this.startIndex_tabledetail == 1
          )
        ) {
          let pageNoSelected = Number(this.selectedNoOfPages);

          let start =
            Number(this.startIndex_tabledetail) - 1 - pageNoSelected * 2;
          let end = start + pageNoSelected - 1;

          let accounts = this.account_data;
          this.accounts = accounts.filter(
            account =>
              accounts.indexOf(account) >= start &&
              accounts.indexOf(account) <= end
          );

          this.tabledetail(this.selectedNoOfPages, "");
        } else {
          alert("first page - No previous");
        }
      },
      openModal() {
        this.actionType = "";
        this.accountHeaderText = "Add New Account";
        this.accountButtonText = "Create";
        this.isAcctFormHidden = false;
        this.isAcctModalHidden = false;
      },
      nextClicked() {
        if (
          Number(this.numberofpages) != -1 &&
          !(this.startIndex_tabledetail == 1)
        ) {
          let start = Number(this.startIndex_tabledetail - 1);
          let end = start + Number(this.selectedNoOfPages) - 1;
          let accounts = this.account_data;
          this.accounts = accounts.filter(
            account =>
              accounts.indexOf(account) >= start &&
              accounts.indexOf(account) <= end
          );
          this.tabledetail(this.selectedNoOfPages, "next");
          this.table_isFirstPage = "";
        } else {
          alert("last page - No Next");
        }
      },
      setFilterDuration() {
        let begin = this.dateSelected;
        if (begin != "all") {
          this.inserted_at = moment()
            .subtract(begin * 7, "days")
            .format();
          this.fetchData(this.inserted_at);
        } else {
          this.inserted_at = "";
          this.fetchData(this.inserted_at);
        }
      },
      loadStates() {
        this.newAccount.state="";
        axios.get("/api/countries/" + this.newAccount.country).then(res => {
          //this.newAccount.country = res.data.name;
          this.country = res.data.name;
          this.states = res.data.states;
        });
      },
      submitAccount(e) {
        e.preventDefault();       

        var url = "/api/accounts";
        // let csrf = document
        //   .querySelector("meta[name='csrf-token']")
        //   .getAttribute("content");

        var new_account = {
          account: {
            company: this.newAccount.company,
            city: this.newAccount.city,
            contact_person: this.newAccount.contact_person,
            country: this.country,
            email_address: this.newAccount.email_address,
            note: this.newAccount.note,
            phone: this.newAccount.phone,
            sector: this.newAccount.sector,
            state: this.newAccount.state,
            status: this.newAccount.status,
            street: this.newAccount.street
          }
        };


        let Account = new_account.account;
        let Error = this.accountFormError;

        


        if (Account.company == "") {
          Error.companyError = false;
        }
        if (Account.city == "") {
          Error.cityError = false;
        }
        if (Account.contact_person == "") {
          Error.contactError = false;
        }
        if (Account.country == "") {
          Error.countryError = false;
        }
        if (Account.email_address == "") {
          Error.emailError = false;
        }
        if (Account.note == "") {
          Error.noteError = false;
        }
        if (Account.phone == "") {
          Error.phoneError = false;
        }
        if (Account.sector == "") {
          Error.sectorError = false;
        }
        if (Account.state == "") {
          Error.stateError = false;
        }
        // if (Account.status == "") {
        //   Error.statusError = false;
        // }
        if (Account.street == "") {
          Error.streetError = false;
        }

        if (
          Account.company !== "" &&
          Account.city !== "" &&
          Account.contact_person !== "" &&
          Account.country !== "" &&
          Account.email_address !== "" &&
          Account.phone !== "" &&
          Account.sector !== "" &&
          Account.state !== "" &&
          Account.street !== ""
        ) {

          if(this.actionType !== "edit"){
            axios
            .post(url, new_account, {
              headers: { "Content-Type": "application/json" }
            })
            .then(response => {
              //this.postedStatusMsg = "Account created successfully!!!!!!!";
             
              this.isAcctFormHidden = true;
              this.isAcctSuccesNotifHidden = false;
              this.clearAccountForm(); 
              this.accountNotifMsg = "Account Successfully Created"             
            });
          }
          else{
             url = "/api/accounts/"+ this.editAccountNo 
            axios
            .put(url, new_account, {
              headers: { "Content-Type": "application/json" }
            })
            .then(response => {
              //this.postedStatusMsg = "Account created successfully!!!!!!!";
             
              this.isAcctFormHidden = true;
              this.isAcctSuccesNotifHidden = false;
              this.clearAccountForm(); 
              this.accountNotifMsg = "Edit Successful"
            });
          }

         
          this.startIndex_tabledetail = 1;
          this.endIndex_tabledetail = 0;
          this.table_isFirstPage = true;
          this.currentPageNo = "1";
          this.numberofpages = 0;
          let vm = this;
          setTimeout(vm.fetchData,1000,'');
          //this.fetchData('');
         
          this.isAcctFormHidden = true;
          this.isAcctSuccesNotifHidden = false;
        } else {
          this.accountErrorText = false;
        }
      },
      closeModal() {
        this.isAcctFormHidden = true;
        this.isAcctModalHidden = true;
        this.isAcctSuccesNotifHidden = true;
        // window.location.href = "/accounts";
      },
      clearAccountForm() {

        let Account = this.newAccount;
        

        Account.company = "";
        Account.city = "";
        Account.contact_person = "";
        Account.country = "";
        Account.email_address = "";
        Account.note = "";
        Account.phone = "";
        Account.sector = "";
        Account.state = "";
        Account.zip="";
        Account.status = "Engaged";
        Account.street = "";
        this.resetError()
      },

      closeNewAccount(){
        this.clearAccountForm();
        this.isAcctFormHidden = true;
        this.isAcctModalHidden = true;
        this.isAcctSuccesNotifHidden = true;
        
      },

      resetError(){
        let Error = this.accountFormError;
        Error.companyError = true;
        Error.contactError = true;
        Error.emailError = true;
        Error.phoneError = true;
        Error.streetError = true;
        Error.countryError = true;
        Error.stateError = true;
        Error.cityError = true;
        Error.statusERror = true;
        Error.sectorError = true;
        this.accountErrorText = true;
      }
    }
  });
}
