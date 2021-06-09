<template>
    <div class="page-search">
        <div class="columns is-multiline">
            <div class="column is-12">
                <h1 class="title">Search</h1>

                <h2 class="is-size-5 has-text-grey">Search term: "{{ query }}"</h2>
            </div>

            <SensorBox 
                v-for="sensor in sensors"
                v-bind:key="sensor.id"
                v-bind:sensor="sensor" />
        </div>
    </div>
</template>

<script>
import axios from 'axios'
import SensorBox from '@/components/SensorBox.vue'
export default {
    name: 'Search',
    components: {
        SensorBox
    },
    data() {
        return {
            sensors: [],
            query: ''
        }
    },
    mounted() {
        document.title = 'Search'
        let uri = window.location.search.substring(1)
        let params = new URLSearchParams(uri)
        if (params.get('query')) {
            this.query = params.get('query')
            this.performSearch()
        }
    },
    methods: {
        async performSearch() {
            this.$store.commit('setIsLoading', true)
            await axios
                .post('/api/v1/sensors/search/', {'query': this.query})
                .then(response => {
                    this.sensors = response.data
                })
                .catch(error => {
                    console.log(error)
                })
            this.$store.commit('setIsLoading', false)
        }
    }
}
</script>