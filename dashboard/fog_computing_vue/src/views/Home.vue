<template>
  <div class="home">
    <section class="hero is-medium is-dark mb-6">
        <div class="hero-body has-text-centered">
            <p class="title mb-6">
                Fog Computing Platform
            </p>
            <p class="subtitle">
                2021
            </p>
        </div>
    </section>

    <div class="columns is-multiline">
      <div class="column is-12">
          <h2 class="is-size-2 has-text-centered">Sensors</h2>
      </div>

      <div 
        v-for="sensor in sensorsList"
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

export default {
  name: 'Home',
  data() {
    return {
      sensorsList: []
    }
  },
  components: {
  },
  mounted() {
    this.getSensorsList()

    document.title = 'Home'
  },
  methods: {
    async getSensorsList() {
      this.$store.commit('setIsLoading', true)

      await axios
      .get('/api/v1/sensors-list/')
      .then(response => {
        this.sensorsList = response.data
      })
      .catch(error => {
        console.log(error)
      })

      this.$store.commit('setIsLoading', false)
    }
  }
}
</script>

<style scoped>
  .image {
    margin-top: -1.25rem;
    margin-left: -1.25rem;
    margin-right: -1.25rem;
  }
</style>
