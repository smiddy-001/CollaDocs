// routes.js
import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from './routes/Home.vue'
import Login from './routes/Login.vue'

Vue.use(VueRouter)

const routes = [
  { path: '/login', component: Login },
  { path: '/', component: Home }
]

const router = new VueRouter({
  routes
})

export default router