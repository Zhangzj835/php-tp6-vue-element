<template>
  <div class="x-handle" @mousedown="mouseDown" :style="'height: '+height+'px'"></div>  
</template>
 
<script>
export default {
  name: "XHandle",
  props: {
    height: {
      type: Number,
      default: 0,
    },
  },
  data() {
    return {
      lastX: "",
    };
  },

  created() {
    document.addEventListener("mouseup", this.mouseUp);
  },

  destroyed() {
    document.removeEventListener("mouseup", this.mouseUp);
  },

  methods: {
    mouseDown(event) {
      document.addEventListener("mousemove", this.mouseMove);
      this.lastX = event.screenX;
    },
    mouseMove(event) {
      this.$emit("widthChange", this.lastX - event.screenX);
      this.lastX = event.screenX;
      console.log(this.lastX, "...", event.screenX);
    },
    mouseUp() {
      this.lastX = "";
      document.removeEventListener("mousemove", this.mouseMove);
    },
  },
};
</script>
<style scoped>
.x-handle {
  float: right;
  width: 2px;  
  cursor: w-resize;
  z-index: 10;
  background: #FFF;      
}
</style>