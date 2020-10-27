FROM node:14 as builder

RUN npm install -g gulp

WORKDIR /tpl
RUN set -x \
    && git clone https://github.com/kalvn/Shaarli-Material.git material \
    && cd material \
    && npm install --unsafe-perm node-sass \
    && npm install \
    && gulp build

WORKDIR /plugins
RUN set -x \
    && git clone https://github.com/ArthurHoaro/code-coloration.git code_coloration \
    && git clone https://github.com/ilesinge/shaarli-related.git related \
    && git clone https://github.com/immanuelfodor/shaarli-descriptor.git shaarli_descriptor  \
    && git clone https://github.com/immanuelfodor/shaarli-markdown-toolbar.git markdown_toolbar \
    && git clone https://github.com/immanuelfodor/shaarli-custom-css.git custom_css \
    && git clone https://github.com/immanuelfodor/emojione.git emojione \
    && git clone https://github.com/kalvn/shaarli-plugin-autosave.git autosave \
    && git clone https://github.com/kalvn/shaarli2mastodon shaarli2mastodon \
    && git clone https://github.com/ArthurHoaro/shaarli2twitter.git shaarli2twitter \
    && git clone https://github.com/trailjeep/shaarli-favicons.git favicons \
    && rm -rf **/.git

FROM shaarli/shaarli:master
LABEL maintainer="SuperITMan <admin at superitman dot com>"

WORKDIR /var/www/shaarli
COPY --from=builder /tpl/material/material tpl/material
COPY --from=builder /plugins/code_coloration/code_coloration plugins/code_coloration
COPY --from=builder /plugins/related/related plugins/related
COPY --from=builder /plugins/shaarli_descriptor/shaarli_descriptor plugins/shaarli_descriptor
COPY --from=builder /plugins/markdown_toolbar/markdown_toolbar plugins/markdown_toolbar
COPY --from=builder /plugins/custom_css/custom_css plugins/custom_css
COPY --from=builder /plugins/emojione plugins/emojione
COPY --from=builder /plugins/autosave plugins/autosave
COPY --from=builder /plugins/shaarli2mastodon plugins/shaarli2mastodon
COPY --from=builder /plugins/shaarli2twitter/shaarli2twitter plugins/shaarli2twitter
COPY --from=builder /plugins/favicons/favicons plugins/favicons

RUN set -x \
    && chown -R nginx:nginx tpl plugins