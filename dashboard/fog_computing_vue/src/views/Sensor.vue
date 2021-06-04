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
            sensor: {}
        }        
    },
    mounted() {
        this.getSensor()
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
        }
    }
}
</script>
