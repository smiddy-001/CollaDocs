import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import LoginView from '../views/LoginView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },
    {
      path: '/profile',
      name: 'profile',
      component: LoginView
    }
    // {
    //   path: '/about',
    //   name: 'about',
    //   // lazy-loaded when the route is visited.
    // //   component: () => import('../views/HomeView.vue')
    // }
  ]
})

export default router