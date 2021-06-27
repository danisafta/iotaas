import { createRouter, createWebHistory } from 'vue-router'
import store from '../store'
import Home from '../views/Home.vue'
import Sensor from '../views/Sensor.vue'
import Category from '../views/Category.vue'
import Search from '../views/Search.vue'
import SignUp from '../views/SignUp.vue'
import LogIn from '../views/LogIn.vue'
import MyAccount from '../views/MyAccount.vue'
import Charts from '../views/Charts.vue'
import Table from '../views/Table.vue'


const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home,

  },
  {
    path: '/about',
    name: 'About',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import(/* webpackChunkName: "about" */ '../views/About.vue')
  },
  {
    path: '/sign-up',
    name: 'SignUp',
    component: SignUp
  },
  {
    path: '/log-in',
    name: 'LogIn',
    component: LogIn
  },
  {
    path: '/my-account',
    name: 'MyAccount',
    component: MyAccount,
    meta: {
      requireLogin: true
    }
  },
  {
    path: '/charts',
    name: 'Charts',
    component: Charts,
  },
  {
    path: '/:category_slug/:sensor_slug/table',
    name: 'Table',
    component: Table,
  },
  // {
  //   path: '/table',
  //   name: 'Table',
  //   component: Table,
  // },
  {
    path: '/search',
    name: 'Search',
    component: Search
  },
  {
    path:'/:category_slug/:sensor_slug',
    name: 'Sensor',
    component: Sensor

  },
  {
    path:'/:category_slug/',
    name: 'Category',
    component: Category

  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

router.beforeEach((to, from, next) => {
  if (to.matched.some(record => record.meta.requireLogin) && !store.state.isAuthenticated) {
    next({ name: 'LogIn', query: { to: to.path } });
  } else {
    next()
  }
})

export default router
