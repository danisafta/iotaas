<template>
    <div class="page-sensor">
        <div class="columns is-multiline">
            <div class="column is-9">
                <figure class="image mb-6">
                    <img v-bind:src="sensor.get_image">
                </figure>

                <h1 class="title">{{ sensor.name }}</h1>

                <p>{{ sensor.description }}</p>
                <p>{{ sensor.node }}</p>
                <p>{{ node1 }}</p>
                
                
                <router-link to="/charts" class="navbar-item">CHARTS</router-link>
                <!-- <router-link :to="/${category_slug}/${sensor_slug}/table" class="navbar-item">TABLES</router-link> -->

            </div>

            <div class="column is-3">
                <h2 class="subtitle">Information</h2>
                    <table>
                        <thead>
                            <td>NAME</td>
                            <td>VALUE</td>
                            <td>TIME</td>
                        </thead>
                        <tbody>
                            <td>{{ value1 }}</td>
                            <td>{{ value2 }}</td>
                            <td>{{ currentDate() }}</td>
                        </tbody>
                    </table>  

            </div>
        </div>
    </div>
</template>


<script>

import axios from 'axios'


export default {
    name: 'Sensor',
    data() {
        return{
            sensor: {},
            value1: [],
            value2: [],
            node1: [],
            category_slug: '',
            sensor_slug: ''
        }        
    },

    mounted() {
        this.getSensor(),
        this.getNode(),
        // this.getValue()
        this.getResp()
        
    },

    methods: {
        async getSensor() {
            this.$store.commit('setIsLoading', true)

            const category_slug = this.$route.params.category_slug
            const sensor_slug = this.$route.params.sensor_slug

            await axios
            .get(`/api/v1/sensors/${category_slug}/${sensor_slug}`)
            .then(response => {
                this.sensor = response.data

                document.title = this.sensor.name
            })
            .catch(error => {
                console.log(error)
            })

            this.$store.commit('setIsLoading', false)

        },
        
        async getNode() {
            // this.$store.commit('setIsLoading', true)

            const category_slug = this.$route.params.category_slug
            const sensor_slug = this.$route.params.sensor_slug

            // this.$store.commit('setIsLoading', false)

            try {
            const response = await axios.get(`api/v1/sensors/${category_slug}/${sensor_slug}`)
            console.log(response.data.node)
            }
            catch(e) {
                console.error(e)
            }
            console.log(response.data.node)

            return response.data.node

        },

        // async getResp() {
        //     const node = await getNode()
        //     // const val = await getVal()
        //     return node
        // },
        
        async getValue() {
            this.$store.commit('setIsLoading', true)

            const category_slug = this.$route.params.category_slug
            const ur = `/api/v1/index/${category_slug}/${this.node}`
            
                // axios
                // .get(ur)
                // .then(response => {
                //     this.value1 = response.data.sensor_info.split(" ")[0]
                //     this.value2 = response.data.sensor_value
                //     console.log(this.value1)
                //     console.log(this.value2)
                // })
                // .catch(error => {
                //     console.log(error)
                // })

            try {
                const response = await axios.get(`api/v1/index/${category_slug}/${node}`)
            }
            catch(e) {
                console.error(e)
            }

            return response.data.sensor_info

            this.$store.commit('setIsLoading', false)
            return {
                value1,
                value2
            }
        },

        currentDate() {
            const current = new Date();
            const date = current.getFullYear()+'-'+(current.getMonth()+1)+'-'+current.getDate();
            const time = current.getHours() + ":" + current.getMinutes() + ":" + current.getSeconds();
            const dateTime = date +' '+ time;
            
            return dateTime;
        }
    }
}
</script>


<style lang="scss">
    table {
    $border: 1px solid #eee;
    border: $border;
    width: 100%;
    max-width: 500px;
    margin: 0 auto;
    td {
        padding: 5px;
        border: $border;
    }
    }
</style>
