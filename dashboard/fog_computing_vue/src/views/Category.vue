<template>
    <div class="page-category">
        <div class="columns is-multiline">
            <div class="column is-12">
                <h2 class="is-size-2 has-text-centered">{{ category.name }}</h2>
            </div>

            
            <div 
                v-for="sensor in category.sensors"
                v-bind:key="sensor.id"
                v-bind:sensor="sensor" 
            >

                <div class="box">
                    <figure class="image mb-4">
                    <img :src="sensor.get_thumbnail">
                    </figure>

                    <h3 class="is-size-4">{{ sensor.name }}</h3>

                    <router-link v-bind:to="sensor.get_absolute_url" class="button is-dark mt-4">View measurements</router-link>
                </div>
            </div>










        </div>
    </div>
</template>

<script>
import axios from 'axios'
import { toast } from 'bulma-toast'

export default {
    name: 'Category',
    data() {
        return {
            category: {
                sensors: []
            }
        }
    },
    mounted() {
        this.getCategory()
    },
    methods: {
        async getCategory() {
            const categorySlug = this.$route.params.category_slug

            this.$store.commit('setIsLoading', true)

            axios
            .get(`/api/v1/sensors/${categorySlug}/`)
            .then(response => {
                this.category = response.data

                document.title = this.category.name
            })
            .catch(error => {
                console.log(error)

                toast({
                    message: 'Something went wrong. Please try again.',
                    type: 'is-danger',
                    dismissible: true,
                    pauseOnHover: true,
                    duration: 2000,
                    position: 'bottom-right',
                })
            })

            this.$store.commit('setIsLoading', false)
        }
    }
}
</script>
