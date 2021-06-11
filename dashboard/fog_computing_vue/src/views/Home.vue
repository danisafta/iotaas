<template>
  <div class="home">
    <section class="hero is-medium is-dark is-bold mb-6">
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
      <template v-if="$store.state.isAuthenticated">
        <div class="column is-12">
            <h2 class="is-size-2 has-text-centered">Sensors</h2>
        </div>

        <SensorBox
          v-for="sensor in sensorsList"
          v-bind:key="sensor.id"
          v-bind:sensor="sensor" />
      </template>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

import SensorBox from '@/components/SensorBox.vue'

export default {
  name: 'Home',
  data() {
    return {
      sensorsList: []
    }
  },
  components: {
    SensorBox
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