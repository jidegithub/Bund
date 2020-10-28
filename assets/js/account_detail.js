import Vue from "vue";
import ElementUI from "element-ui";
Vue.use(ElementUI);

var bund_accountDetail = document.getElementById("account-detail");
if (bund_accountDetail != null) {
  var accountDetail = new Vue({
    el: bund_accountDetail,
    data() {
      return {
        activeName: 'task'
      };
    },

    methods: {
        handleClick(tab, event) {
            console.log(tab, event);
          }
    }
  });
}