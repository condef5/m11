import { Controller } from "@hotwired/stimulus";
import TomSelect from "tom-select";

export default class extends Controller {
  static values = { url: String, selected: String };

  connect() {
    this.initTomSelect();
  }

  disconnect() {
    if (this.select) {
      this.select.destroy();
    }
  }

  initTomSelect() {
    if (this.element) {
      let url = `${this.urlValue}.json`;
      const { data, values } = this.formatSelectedData();

      this.select = new TomSelect(this.element, {
        plugins: ["remove_button"],
        valueField: "id",
        labelField: "name",
        searchField: ["name", "level"],
        maxItems: 2,
        selectOnTab: true,
        placeholder: "Select",
        closeAfterSelect: true,
        hidePlaceholder: false,
        preload: true,
        create: false,
        openOnFocus: true,
        highlight: true,
        sortField: {
          field: "name",
          direction: "asc",
        },
        options: data,
        items: values,
        load: (search, callback) => {
          fetch(`${url}?filter=${search}`)
            .then((response) => response.json())
            .then((json) => {
              callback(json);
            })
            .catch(() => {
              callback();
            });
        },
        render: {
          option: function (data, escape) {
            return `
              <div class='flex gap-2'>
                <span class="block">${escape(data.name)}</span>
                <span class="text-gray-400">${escape(data.level)}</span>
              </div>
            `;
          },
        },
      });
    }
  }

  formatSelectedData() {
    try {
      const data = JSON.parse(this.selectedValue);
      const values = data.map((item) => item.id);

      return { data, values };
    } catch (error) {
      console.error(error);
      return { data: [], values: [] };
    }
  }
}
