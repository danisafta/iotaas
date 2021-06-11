<template>
    <div class="page-category">
        <div class="columns is-multiline">
            <div class="column is-12">
                <h2 class="is-size-2 has-text-centered">{{ category.name }}</h2>
            </div>
   
      <SensorBox
        v-for="sensor in category.sensors"
        v-bind:key="sensor.id"
        v-bind:sensor="sensor" />

        </div>
    </div>
</template>

<script>
import axios from 'axios'
import { toast } from 'bulma-toast'
import SensorBox from '@/components/SensorBox'

export default {
    name: 'Category',
    components: {
        SensorBox
    },
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
    watch: {
        $route(to, from) {
            if (to.name == "Category") {
                this.getCategory()
            }
        }

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
