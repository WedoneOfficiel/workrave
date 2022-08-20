import nunjucks from 'nunjucks';
import moment from 'moment';
import path from 'path';
import semver from 'semver';

import { dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));

class Generator {
  params: any;
  catalog: any;

  tag_to_version(tag: any) {
    return tag
      .replace(/_([0-9])/g, '.$1')
      .replace(/-[0-9]+/g, '')
      .replace(/_/g, '-')
      .replace(/^v/g, '');
  }

  constructor(catalog: any, params: any) {
    this.catalog = catalog;
    this.params = params;

    nunjucks
      .configure({
        autoescape: false,
        watch: false,
      })
      .addFilter('data_format', (date: string, format: string) => {
        return moment(date).format(format);
      })
      .addFilter('data_format_from_unix', (date: string, format: string) => {
        return moment.unix(+date).format(format);
      })
      .addFilter('channel', (item: any) => {
        const version = this.tag_to_version(item.tag);
        const increment = item.increment;

        if (increment !== '0' && increment !== '') {
          return 'dev';
        }

        const pre = semver.prerelease(version);
        if (pre) {
          return pre[0];
        }
        return '';
      })

      .addFilter('version', (item: any) => {
        return this.tag_to_version(item.tag);
      });
  }

  async generate() {
    try {
      const context = {
        builds: this.catalog.builds,
      };
      const template_filename: string = path.join(__dirname, '..', 'templates', 'appcast.tmpl');
      return nunjucks.render(template_filename, context);
    } catch (e) {
      console.error(e);
    }
    return '';
  }
}
export { Generator };
