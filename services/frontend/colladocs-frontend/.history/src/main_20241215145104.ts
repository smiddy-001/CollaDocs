import { createApp } from 'vue';
import App from './App.vue';
import router from './router';

import { OhVueIcon, addIcons } from "oh-vue-icons";
import * as BiIcons from "oh-vue-icons/icons/bi";


const Fa = Object.values({ ...FaIcons });
addIcons(...Fa);


const app = createApp(App);

app.use(router);
app.component("v-icon", OhVueIcon);
app.mount('#app');