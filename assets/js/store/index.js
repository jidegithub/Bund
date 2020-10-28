import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    accounts: [],
    index: ""
  },
  mutations: {
    change_accounts(state, accounts) {
      state.accounts = accounts;
    },
    change_index(state, index) {
      state.index = index;
    },
    update_account(state, account) {
      Vue.set(state.accounts, state.index, account);
    }
  },

  getters: {
    account_data(state) {
      return state.accounts;
    },
    clicked_account(state) {
      return state.accounts[state.index];
    }
  }
});
