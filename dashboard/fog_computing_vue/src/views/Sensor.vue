<template>
    <div class="page-sensor">
        <div class="columns is-multiline">
            <div class="column is-9">
                <figure class="image mb-6">
                    <img v-bind:src="sensor.get_image">
                </figure>

                <h1 class="title">{{ sensor.name }}</h1>

                <p>{{ sensor.description }}</p>
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
            value2: []
        }        
    },
    mounted() {
        this.getSensor()
        this.getValue()
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

        async getValue() {
            this.$store.commit('setIsLoading', true)

            const category_slug = this.$route.params.category_slug
            const sensor_slug = this.$route.params.sensor_slug
            const node = 'MASTER1'

            await axios
            .get(`/api/v1/index/${category_slug}/` + node)
            .then(response => {
                this.value1 = response.data.sensor_info.split(" ")[0]
                this.value2 = response.data.sensor_value
            })
            .catch(error => {
                console.log(error)
            })

            this.$store.commit('setIsLoading', false)

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
