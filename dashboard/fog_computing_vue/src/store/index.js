import { createStore } from 'vuex'

export default createStore({
  state: {
    isAuthenticated: false,
    token: '',
    isLoading: false
  },
  mutations: {
    setIsLoading(state, status) {
      state.isLoading = status
    }
  },
  actions: {
  },
  modules: {
  }
})
